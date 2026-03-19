#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: HTTP and HTTPS ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

cat <<'INSTRUCTIONS'

Your deployment succeeded but users are reporting errors. You need to
inspect the full HTTP exchange — request headers, response codes, and
response bodies — to diagnose what's happening. This lab runs an nginx
server accessible at hostname "webserver" on this lab network.

Endpoints available:
  http://webserver/        — Returns "Hello from Learn Systems" (200 OK)
  http://webserver/api     — Returns JSON response (200 OK)
  http://webserver/health  — Returns health check JSON (200 OK)
  http://webserver/missing — Returns 404 Not Found

Exercises:

  1. Make a basic HTTP request and see the response body:
       curl http://webserver/

  2. Show full request and response headers (-v for verbose):
       curl -v http://webserver/

  3. Get only the HTTP status code (useful in scripts):
       curl -s -o /dev/null -w "%{http_code}\n" http://webserver/

  4. Save the response headers to a file:
       curl -I http://webserver/ > /tmp/exercise/headers.txt
     Inspect the headers:
       cat /tmp/exercise/headers.txt

  5. Test the /api endpoint with a GET request:
       curl http://webserver/api

  6. Test with a custom request header (simulating auth):
       curl -H "Authorization: Bearer mytoken" http://webserver/api

  7. Test different HTTP methods:
       curl -X POST http://webserver/api
       curl -X DELETE http://webserver/api

  8. Check what a 404 looks like:
       curl -v http://webserver/missing

  9. Follow redirects automatically (no redirect in this lab, but the flag):
       curl -L http://webserver/

When done, run: bash /verify/04-http.sh

INSTRUCTIONS

echo ""
echo "Lab ready! nginx is at hostname 'webserver'"
echo "When done, run: bash /verify/04-http.sh"
exec /bin/bash
