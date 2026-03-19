#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

check() {
  local desc="$1"
  local result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Verifying: Terraform Modules Exercise ==="
echo ""

# Check 1: Container 'learn-frontend' is running
FRONTEND_RUNNING=$(docker inspect --format '{{.State.Running}}' learn-frontend 2>/dev/null || echo "false")
check "Container 'learn-frontend' is running" \
  "$([ "$FRONTEND_RUNNING" = "true" ] && echo pass || echo fail)"

# Check 2: Container 'learn-api' is running
API_RUNNING=$(docker inspect --format '{{.State.Running}}' learn-api 2>/dev/null || echo "false")
check "Container 'learn-api' is running" \
  "$([ "$API_RUNNING" = "true" ] && echo pass || echo fail)"

# Check 3: Frontend accessible on port 8081
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081 2>/dev/null || echo "000")
check "Frontend accessible on port 8081 (HTTP 200)" \
  "$([ "$FRONTEND_STATUS" = "200" ] && echo pass || echo fail)"

# Check 4: API accessible on port 8082
API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8082 2>/dev/null || echo "000")
check "API accessible on port 8082 (HTTP 200)" \
  "$([ "$API_STATUS" = "200" ] && echo pass || echo fail)"

# Check 5: State file contains at least 4 resources (2 images + 2 containers)
STATE_FILE="$(dirname "$0")/../03-modules/terraform.tfstate"
if [ -f "$STATE_FILE" ] && command -v jq >/dev/null 2>&1; then
  RESOURCE_COUNT=$(jq '.resources | length' "$STATE_FILE" 2>/dev/null || echo "0")
  check "terraform.tfstate contains at least 4 resources (2 images + 2 containers)" \
    "$([ "$RESOURCE_COUNT" -ge 4 ] && echo pass || echo fail)"
else
  check "terraform.tfstate contains at least 4 resources (jq required)" \
    "$([ -f "$STATE_FILE" ] && echo pass || echo fail)"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
