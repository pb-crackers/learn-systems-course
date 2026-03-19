FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    procps \
    gawk \
    apt-utils \
    curl wget vim nano less tree \
    strace \
    man-db \
    iproute2 \
    sysstat \
    && rm -rf /var/lib/apt/lists/*
COPY verify/ /usr/local/lib/learn-systems/verify/
COPY setup/ /usr/local/lib/learn-systems/setup/
RUN chmod +x /usr/local/lib/learn-systems/verify/*.sh \
             /usr/local/lib/learn-systems/setup/*.sh
RUN useradd -m -s /bin/bash student && \
    useradd -m -s /bin/bash testuser && \
    groupadd devops && \
    usermod -aG devops student
WORKDIR /home/student
CMD ["/bin/bash"]
