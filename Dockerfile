FROM heroku-cron-base

ENV EH_ROOT_DIR=/var/eh\
    EH_BIN_DIR=/var/eh/bin\
    EH_RUN_DIR=/var/eh/run\
    EH_HEROKU_POSTGRES_BACKUPS_DIR=/eh/data/heroku/postgres/backups

RUN mkdir -p $EH_ROOT_DIR $EH_BIN_DIR $EH_RUN_DIR $EH_HEROKU_POSTGRES_BACKUPS_DIR

# Add EH util scripts
ADD heroku_backup.rb $EH_BIN_DIR/heroku_backup.rb
CMD chmod 0644 $EH_BIN_DIR/heroku_backup.rb

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/eh-crontab
RUN cat /etc/cron.d/eh-crontab >> /etc/crontab && rm /etc/cron.d/*

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Add crontab file in the cron directory
ADD init.sh $EH_BIN_DIR/init.sh
CMD chmod 0644 $EH_BIN_DIR/init.sh

#
VOLUME $EH_HEROKU_POSTGRES_BACKUPS_DIR

# Run the command on container startup
CMD $EH_BIN_DIR/init.sh