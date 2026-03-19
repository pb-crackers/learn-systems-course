#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Firewalls and iptables ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

cat <<'INSTRUCTIONS'

Your new service is deployed but external users can't reach it. A firewall
rule may be silently dropping traffic before it ever reaches your application.
You need to understand iptables and ufw to diagnose and fix firewall issues.

This lab has:
  firewall-host  — you are here; has NET_ADMIN capability for iptables/ufw
  target         — nginx server you will allow/block traffic to

Exercises:

  1. Show current iptables rules (initially empty — default ACCEPT policy):
       iptables -L -v -n

  2. Verify the target nginx is currently reachable:
       curl -s -o /dev/null -w "%{http_code}\n" http://target/

  3. Allow established connections (required for stateful firewall — add first):
       iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  4. Allow SSH (so you don't lock yourself out):
       iptables -A INPUT -p tcp --dport 22 -j ACCEPT

  5. Allow HTTP traffic:
       iptables -A INPUT -p tcp --dport 80 -j ACCEPT

  6. Allow HTTPS traffic:
       iptables -A INPUT -p tcp --dport 443 -j ACCEPT

  7. Drop all other incoming traffic (default deny):
       iptables -A INPUT -j DROP

  8. View the updated rules:
       iptables -L -v -n

  9. Save current rules to a file:
       iptables -L -n > /tmp/exercise/rules.txt

 10. Test that an allowed port (80) still works:
       curl -s -o /dev/null -w "%{http_code}\n" http://target/

 11. Test that a blocked port (8080) is now unreachable:
       nc -zv -w 2 target 8080 || echo "Port 8080 blocked as expected"

 12. Try ufw (a simpler frontend to iptables):
       ufw allow 22/tcp
       ufw allow 80/tcp
       ufw allow 443/tcp
       ufw status

When done, run: bash /verify/06-firewalls.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You have NET_ADMIN capability — iptables commands will work."
echo "Target nginx server is at hostname 'target'"
echo "When done, run: bash /verify/06-firewalls.sh"
exec /bin/bash
