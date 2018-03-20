FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y cron curl openssh-client ruby git wget

RUN wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
ENV PATH $PATH:/usr/local/heroku/bin
RUN heroku --version

RUN apt-get clean &&\
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
