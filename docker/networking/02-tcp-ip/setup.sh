#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: TCP/IP Stack and IP Addressing ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

cat <<'INSTRUCTIONS'

You are debugging why two containers on the same Docker network cannot
communicate. Your first step is to inspect IP addresses, understand the
subnet, and examine which ports are listening — the same workflow you
use in real container debugging.

The lab network has two containers:
  server  — 10.0.0.10
  client  — 10.0.0.20 (you are here)

Exercises:

  1. Show all network interfaces and IP addresses with CIDR notation:
       ip addr show
     Note the CIDR (e.g., /24) — this tells you the subnet size.
     Save the output:
       ip addr show > /tmp/exercise/ip-info.txt

  2. Show the routing table:
       ip route show
     Identify the directly-connected network and the default gateway.
     Save the output:
       ip route show > /tmp/exercise/routes.txt

  3. Ask the kernel how it would route traffic to the server:
       ip route get 10.0.0.10
     Compare this to routing to an external IP:
       ip route get 8.8.8.8

  4. List all listening TCP ports:
       ss -tlnp

  5. Start a netcat listener on port 9000 in the background:
       nc -lk 9000 &>/dev/null &
     Verify it appears in ss output:
       ss -tlnp | grep 9000

  6. Verify the server is reachable via ping:
       ping -c 3 10.0.0.10

  7. Record the subnet the two containers share:
       echo "10.0.0.0/24" > /tmp/exercise/subnet-answer.txt

When done, run: bash /verify/02-tcp-ip.sh

INSTRUCTIONS

echo ""
echo "Lab ready! Client IP is 10.0.0.20, server IP is 10.0.0.10"
echo "When done, run: bash /verify/02-tcp-ip.sh"
exec /bin/bash
