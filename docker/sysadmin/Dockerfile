FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    procps \
    sysstat \
    cron \
    at \
    passwd \
    sudo \
    util-linux \
    fdisk \
    mount \
    curl wget vim nano less tree \
    man-db \
    rsyslog \
    logrotate \
    && rm -rf /var/lib/apt/lists/*
COPY verify/ /usr/local/lib/learn-systems/verify/
COPY setup/ /usr/local/lib/learn-systems/setup/
RUN chmod +x /usr/local/lib/learn-systems/verify/*.sh \
             /usr/local/lib/learn-systems/setup/*.sh
RUN useradd -m -s /bin/bash student && \
    echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /home/student
CMD ["/bin/bash"]
