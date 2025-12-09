#!/bin/bash
ROLE=$1
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
echo ">>> Configuring WireGuard for $ROLE..."
if [ "$ROLE" == "site-a" ]; then
    ip link add dev wg0 type wireguard
    ip address add dev wg0 10.0.0.1/24
    wg set wg0 listen-port 51820 private-key privatekey
    ip link set up dev wg0
    echo "Site A Ready. IP VPN: 10.0.0.1"
elif [ "$ROLE" == "site-b" ]; then
    ip link add dev wg0 type wireguard
    ip address add dev wg0 10.0.0.2/24
    wg set wg0 listen-port 51820 private-key privatekey
    ip link set up dev wg0
    echo "Site B Ready. IP VPN: 10.0.0.2"
fi
iperf3 -s -D

