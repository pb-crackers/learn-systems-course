#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Network Troubleshooting ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

cat <<'INSTRUCTIONS'

It is 2 AM. The monitoring alert says "service unreachable." Users report
that http://app/ is not responding. The application team says the app
container is running and they have not changed anything.

Your mission: find the fault and write your diagnosis to /tmp/diagnosis.txt

The lab has three services:
  app       — the broken service (users expect it at http://app/)
  database  — should not be involved in this issue
  client    — you are here

Diagnostic approach (work up the network stack):

  LAYER 3: Can I reach the host?
    ping -c 3 app
    ping -c 3 database

  LAYER 4: Is the service listening on the expected port?
    nc -zv -w 2 app 80      (is port 80 open?)
    nc -zv -w 2 app 8080    (is something on 8080?)

  LAYER 7: Does the application respond?
    curl -v http://app/
    curl -v http://app:8080/

  PACKET LEVEL: What's actually on the wire?
    tcpdump -i eth0 host app -A -c 10

Tools available: ping, traceroute, nc, curl, ss, tcpdump, ip

When you have identified the fault, write your diagnosis:
  echo "The fault is: ..." > /tmp/diagnosis.txt

Then run: bash /verify/07-troubleshooting.sh

INSTRUCTIONS

echo ""
echo "Lab ready! Services: app, database"
echo "You have NET_ADMIN and NET_RAW capabilities (tcpdump works)"
echo "When done, run: bash /verify/07-troubleshooting.sh"
exec /bin/bash
