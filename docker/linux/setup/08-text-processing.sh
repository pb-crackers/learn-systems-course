#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Text Processing ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

# Generate a realistic Apache-format web server access log (~500 lines)
# Mix of IPs, URLs, status codes — with patterns to make exercises interesting
generate_log() {
  local outfile="$1"
  local lines="$2"

  # IPs — some repeat heavily (interesting for top-N analysis)
  local ips=("192.168.1.100" "10.0.0.55" "172.16.0.12" "10.0.0.55" "203.0.113.42"
             "192.168.1.100" "10.0.0.55" "198.51.100.7" "192.168.1.100" "10.0.0.22")

  # URLs — some with 500s (interesting for error analysis)
  local get_urls=("/api/users" "/api/orders" "/api/products" "/" "/about"
                  "/health" "/metrics" "/api/users/123" "/static/app.js" "/static/app.css")
  local post_urls=("/api/orders" "/api/login" "/api/users" "/api/checkout")

  # Status code distribution: mostly 200, some 301/304, 404s, and a cluster of 500s on specific endpoints
  local statuses_get=(200 200 200 200 200 200 200 200 301 304 404 500)
  local statuses_post=(200 200 200 201 400 422 500 500)

  # Month names for timestamps
  local months=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")

  > "$outfile"

  local i=0
  while [ "$i" -lt "$lines" ]; do
    local ip_idx=$(( i % ${#ips[@]} ))
    local ip="${ips[$ip_idx]}"

    # Vary the day/hour/minute for each line
    local day=$(( (i % 28) + 1 ))
    local hour=$(( i % 24 ))
    local minute=$(( (i * 7 + 3) % 60 ))
    local second=$(( (i * 13 + 7) % 60 ))
    local month="${months[$((i % 12))]}"
    local timestamp=$(printf "%02d/%s/2026:%02d:%02d:%02d +0000" "$day" "$month" "$hour" "$minute" "$second")

    # Decide GET or POST based on line index
    if [ $(( i % 5 )) -eq 0 ]; then
      local method="POST"
      local url_idx=$(( i % ${#post_urls[@]} ))
      local url="${post_urls[$url_idx]}"
      local status_idx=$(( i % ${#statuses_post[@]} ))
      local status="${statuses_post[$status_idx]}"
    else
      local method="GET"
      local url_idx=$(( i % ${#get_urls[@]} ))
      local url="${get_urls[$url_idx]}"
      local status_idx=$(( i % ${#statuses_get[@]} ))
      local status="${statuses_get[$status_idx]}"
    fi

    # Response size varies by status
    local size
    if [ "$status" = "200" ] || [ "$status" = "201" ]; then
      size=$(( (i * 97 + 512) % 8192 + 128 ))
    elif [ "$status" = "500" ]; then
      size=$(( (i * 13 + 89) % 512 + 64 ))
    else
      size=$(( (i * 31 + 64) % 256 + 32 ))
    fi

    printf '%s - - [%s] "%s %s HTTP/1.1" %s %s\n' \
      "$ip" "$timestamp" "$method" "$url" "$status" "$size" >> "$outfile"

    i=$((i + 1))
  done
}

generate_log /tmp/exercise/access.log 500

# Create a config file for sed practice
cat <<'APPCONF' > /tmp/exercise/app.conf
# Application Configuration
APP_NAME=myapp
PORT=8080
DEBUG=false
DATABASE_URL=postgres://localhost:5432/myapp
LOG_LEVEL=info
MAX_CONNECTIONS=100
TIMEOUT=30
WORKERS=4
APPCONF

echo "Generated /tmp/exercise/access.log ($(wc -l < /tmp/exercise/access.log) lines)"
echo "Created /tmp/exercise/app.conf"

cat <<'INSTRUCTIONS'

Your task: analyze a web server access log and transform a config file using
Linux text processing tools. This is exactly how engineers triage production
incidents — no GUI, no database, just pipes and the tools you already have.

Access log is at: /tmp/exercise/access.log
Config file is at: /tmp/exercise/app.conf

Exercises:
  1. Find all 500-status error URLs:
       grep ' 500 ' /tmp/exercise/access.log | awk '{print $7}'
     Save at least 3 unique error URLs to /tmp/exercise/error-urls.txt

  2. Count requests per IP (top IPs):
       awk '{print $1}' /tmp/exercise/access.log | sort | uniq -c | sort -rn
     Save the output to /tmp/exercise/top-ips.txt

  3. Use sed to change the PORT in app.conf from 8080 to 9090:
       sed -i 's/PORT=8080/PORT=9090/' /tmp/exercise/app.conf
     Verify: grep PORT /tmp/exercise/app.conf

  4. Build a 4+ stage pipeline (count 500 errors per URL, sorted by frequency):
       grep ' 500 ' /tmp/exercise/access.log \
         | awk '{print $7}' \
         | sort \
         | uniq -c \
         | sort -rn
     Save the output to /tmp/exercise/pipeline-output.txt

  5. Explore further with awk — extract only GET requests with 200 status:
       awk '$6 == "\"GET" && $9 == "200"' /tmp/exercise/access.log | head -10

When done, run: bash /usr/local/lib/learn-systems/verify/08-text-processing.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You are in $(pwd)"
echo "Log file at: /tmp/exercise/access.log (500 lines, realistic Apache format)"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/08-text-processing.sh"
exec /bin/bash
