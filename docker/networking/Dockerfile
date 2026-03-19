FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    # DNS tools
    dnsutils \
    # HTTP tools
    curl wget \
    # Network inspection
    iproute2 \
    iputils-ping \
    traceroute \
    # Port checking
    netcat-openbsd \
    # Packet capture
    tcpdump \
    # SSH client
    openssh-client \
    # Firewall tools
    iptables \
    ufw \
    # General
    vim nano less \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /tmp/exercise
CMD ["sleep", "infinity"]
