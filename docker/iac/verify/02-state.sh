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

echo "=== Verifying: Terraform State Exercise ==="
echo ""

# Check 1: Container 'learn-state-demo' is running
CONTAINER_RUNNING=$(docker inspect --format '{{.State.Running}}' learn-state-demo 2>/dev/null || echo "false")
check "Container 'learn-state-demo' is running" \
  "$([ "$CONTAINER_RUNNING" = "true" ] && echo pass || echo fail)"

# Check 2: terraform.tfstate file exists in docker/iac/02-state/
STATE_FILE="$(dirname "$0")/../02-state/terraform.tfstate"
check "terraform.tfstate exists in docker/iac/02-state/" \
  "$([ -f "$STATE_FILE" ] && echo pass || echo fail)"

# Check 3: State file is valid JSON with resources
if [ -f "$STATE_FILE" ] && command -v jq >/dev/null 2>&1; then
  RESOURCE_COUNT=$(jq '.resources | length' "$STATE_FILE" 2>/dev/null || echo "0")
  check "terraform.tfstate is valid JSON with resources" \
    "$([ "$RESOURCE_COUNT" -gt 0 ] && echo pass || echo fail)"
else
  check "terraform.tfstate is valid JSON (jq required for full check)" \
    "$([ -f "$STATE_FILE" ] && echo pass || echo fail)"
fi

# Check 4: State file contains docker_container resource type
if [ -f "$STATE_FILE" ] && command -v jq >/dev/null 2>&1; then
  HAS_CONTAINER=$(jq '[.resources[] | select(.type == "docker_container")] | length' "$STATE_FILE" 2>/dev/null || echo "0")
  check "State file contains docker_container resource type" \
    "$([ "$HAS_CONTAINER" -gt 0 ] && echo pass || echo fail)"
else
  check "State file contains docker_container resource type (jq required)" \
    "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
