#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: DNS Resolution ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

cat <<'INSTRUCTIONS'

You are preparing for a DNS cutover — migrating a service to a new IP.
Before switching traffic, you need to verify DNS records are correct by
querying the authoritative nameserver directly, bypassing all caches.

This lab runs a CoreDNS server pre-configured with the learn.local zone:
  app.learn.local  →  10.0.0.10
  db.learn.local   →  10.0.0.11
  web.learn.local  →  10.0.0.12

The DNS server is reachable at hostname "dns" within this lab network.

Exercises:

  1. Query the lab DNS server for app.learn.local:
       dig app.learn.local @dns
     The ANSWER SECTION shows the A record and its TTL.

  2. Get just the IP address (useful in scripts):
       dig +short app.learn.local @dns

  3. Query for all three lab hostnames:
       dig +short db.learn.local @dns
       dig +short web.learn.local @dns

  4. Perform a reverse DNS lookup (PTR record):
       dig -x 10.0.0.10 @dns
     The ANSWER SECTION shows the PTR record mapping back to app.learn.local.

  5. Trace the full resolution chain for a public domain:
       dig +trace example.com
     This shows every step from root nameservers to the authoritative answer.
     This is the most powerful DNS debugging tool.

  6. Save a trace to the exercise output directory:
       dig +trace app.learn.local @dns > /tmp/exercise/dns-trace.txt

  7. Query MX records for a public domain:
       dig mx gmail.com

  8. Check how different resolvers see the same domain:
       dig +short example.com @8.8.8.8
       dig +short example.com @1.1.1.1

When done, run: bash /verify/03-dns.sh

INSTRUCTIONS

echo ""
echo "Lab ready! DNS server is at 10.0.0.2 (hostname: dns)"
echo "When done, run: bash /verify/03-dns.sh"
exec /bin/bash
