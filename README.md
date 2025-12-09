# Site-to-Site VPN & Network Quality Monitoring Lab 

![Network Status](https://img.shields.io/badge/Network-Operational-success) ![Stack](https://img.shields.io/badge/Tech-WireGuard%20%7C%20Docker%20%7C%20Bash-blue)

##  Introduction
This project simulates a secure **Site-to-Site VPN infrastructure** connecting two independent network nodes (simulated branch offices). It demonstrates core Network Engineering competencies including **L3 Tunneling, Static Routing, Traffic Encryption**, and **Automated QoS Monitoring**.

The goal is to establish a secure communication channel over an untrusted network and monitor connection health (Bandwidth, Latency, Jitter) in real-time.

##  Network Architecture

```mermaid
graph LR
    subgraph Site A [Head Office Node]
        A[Interface: wg0] -- IP: 10.0.0.1 --> Internet
    end
    
    subgraph Site B [Branch Office Node]
        B[Interface: wg0] -- IP: 10.0.0.2 --> Internet
    end

    Internet((Docker Bridge Network))
    A <== "Encrypted Tunnel (UDP 51820)" ==> B
````

  * **Technology:** WireGuard (VPN Protocol).
  * **Topology:** Point-to-Point (P2P).
  * **Overlay Network:** `10.0.0.0/24`.
  * **Underlay Network:** Docker Bridge (Simulating WAN).

##  Key Features

  * **Secure Tunneling:** Implements modern VPN standards using WireGuard for high-performance encrypted communication.
  * **QoS Monitoring:** Custom Bash automation wrapping `iperf3` and `ping` to measure:
      * **Throughput/Bandwidth** (Gbps).
      * **Latency** (RTT).
      * **Packet Loss** (%).
  * **Infrastructure as Code:** Fully containerized environment using Docker & Docker Compose.
  * **Traffic Analysis Ready:** Pre-configured for packet capture and header analysis using `tcpdump`.

##  Installation & Setup

### Prerequisites

  * Docker & Docker Compose.
  * Linux/WSL environment.

### 1\. Clone the repository

```bash
git clone https://github.com/nazinguyen/vpn-qos-lab.git
cd vpn-qos-lab
```

### 2\. Start the Network Nodes

```bash
docker-compose up -d --build
```

This will initialize two containers: `site-a` and `site-b` with `NET_ADMIN` privileges.

##  Configuration Guide (Manual Key Exchange)

Since WireGuard relies on Public/Private key pairs, follow these steps to establish the handshake:

**Step 1: Generate Keys on Site A**

```bash
docker exec -it site-a bash
# Inside container:
./scripts/start_vpn.sh site-a
# Note the Public Key displayed on the screen.
```

**Step 2: Generate Keys on Site B & Peer with A**

```bash
docker exec -it site-b bash
# Inside container:
./scripts/start_vpn.sh site-b
# Connect to A (Replace <KEY_A> with the actual public key from Step 1):
wg set wg0 peer <KEY_A> allowed-ips 10.0.0.1/32 endpoint site-a:51820
```

**Step 3: Complete Peering on Site A**
Back in Site A terminal, add Site B as a peer:

```bash
# Replace <KEY_B> with Site B's public key:
wg set wg0 peer <KEY_B> allowed-ips 10.0.0.2/32 endpoint site-b:51820
```

##  Monitoring & QoS Report

Once the tunnel is established (verify with `wg show`), run the monitoring tool to audit network quality.

**Run Monitoring Script:**

```bash
./scripts/monitor.sh 10.0.0.1
```

**Sample Output:**

```text
========== NETWORK QUALITY REPORT ==========
Target VPN Node: 10.0.0.1
Date: Mon Dec 09 14:30:00 UTC 2025
--------------------------------------------
[1] Checking Latency & Packet Loss...
64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.047 ms
Packet Loss: 0%
--------------------------------------------
[2] Measuring Bandwidth & Jitter...
>>> Bandwidth Raw: 4.89 Gbits/sec
--------------------------------------------
Status: COMPLETED.
```

##  Network Concepts Applied

  * **OSI Model Layer 3 & 4:** Handling IP routing and UDP transport for VPN.
  * **NAT & Firewalling:** Understanding how traffic traverses interfaces (`eth0` to `wg0`).
  * **Metric Analysis:** interpreting Jitter and Latency for SLA compliance.

##  Author

**Nguyen An Vinh**

  * **Role:** Aspiring Network Engineer / DevOps.
  * **Contact:** navinh2k4@gmail.com

<!-- end list -->
