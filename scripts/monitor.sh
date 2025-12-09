#!/bin/bash
TARGET_IP=$1
echo "========== NETWORK REPORT: $(date) =========="
echo "[1] Latency Check:"
ping -c 3 -q $TARGET_IP
echo "[2] Bandwidth Check:"
iperf3 -c $TARGET_IP -t 3 --json > result.json
SPEED=$(grep "bits_per_second" result.json | head -1 | awk '{print $2}')
echo ">>> Speed Raw: $SPEED bps"

