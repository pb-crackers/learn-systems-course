#!/usr/bin/env bash
set -euo pipefail

PASS=0; FAIL=0

check() {
  local desc="$1" result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"; PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"; FAIL=$((FAIL + 1))
  fi
}

COMPOSE_FILE="$(dirname "$0")/compose.yml"

echo "Cloud Mapping Exercise — Verify"
echo "================================"
echo ""

# Check 1: Docker Compose stack is running (loadbalancer, app1, app2)
RUNNING_COUNT=$(docker compose -f "$COMPOSE_FILE" ps --status running --format json 2>/dev/null | grep -c '"Service"' || echo "0")
check "Compose stack has 3 running services (loadbalancer + app1 + app2)" \
  "$([ "$RUNNING_COUNT" -ge 3 ] && echo pass || echo fail)"

# Check 2: Load balancer accessible on port 8080
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 2>/dev/null || echo "000")
check "Load balancer responds on port 8080 (HTTP 200)" \
  "$([ "$HTTP_CODE" = "200" ] && echo pass || echo fail)"

# Check 3: app1 service is running
APP1_STATE=$(docker compose -f "$COMPOSE_FILE" ps --format json 2>/dev/null | python3 -c "import sys,json; data=[json.loads(l) for l in sys.stdin if l.strip()]; svc=[s for s in data if s.get('Service')=='app1']; print(svc[0].get('State','') if svc else '')" 2>/dev/null || echo "")
check "app1 service is running" \
  "$([ "$APP1_STATE" = "running" ] && echo pass || echo fail)"

# Check 4: app2 service is running
APP2_STATE=$(docker compose -f "$COMPOSE_FILE" ps --format json 2>/dev/null | python3 -c "import sys,json; data=[json.loads(l) for l in sys.stdin if l.strip()]; svc=[s for s in data if s.get('Service')=='app2']; print(svc[0].get('State','') if svc else '')" 2>/dev/null || echo "")
check "app2 service is running" \
  "$([ "$APP2_STATE" = "running" ] && echo pass || echo fail)"

# Check 5: Volume 'app-data' is defined in compose config
VOLUME_DEFINED=$(docker compose -f "$COMPOSE_FILE" config --volumes 2>/dev/null | grep -c "app-data" || echo "0")
check "Volume 'app-data' defined in compose config" \
  "$([ "$VOLUME_DEFINED" -ge 1 ] && echo pass || echo fail)"

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"; exit 1
fi
