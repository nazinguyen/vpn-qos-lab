FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    wireguard iproute2 iptables iputils-ping iperf3 curl net-tools vim procps \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*.sh
CMD ["tail", "-f", "/dev/null"]

