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

echo "=== Verifying: IaC Basics Exercise ==="
echo ""

# Check 1: Container 'learn-iac-web' is running
CONTAINER_RUNNING=$(docker inspect --format '{{.State.Running}}' learn-iac-web 2>/dev/null || echo "false")
check "Container 'learn-iac-web' is running" \
  "$([ "$CONTAINER_RUNNING" = "true" ] && echo pass || echo fail)"

# Check 2: terraform.tfstate file exists in docker/iac/01-basics/
STATE_FILE="$(dirname "$0")/../01-basics/terraform.tfstate"
check "terraform.tfstate file exists in docker/iac/01-basics/" \
  "$([ -f "$STATE_FILE" ] && echo pass || echo fail)"

# Check 3: State file contains resource records
if [ -f "$STATE_FILE" ] && command -v jq >/dev/null 2>&1; then
  RESOURCE_COUNT=$(jq '.resources | length' "$STATE_FILE" 2>/dev/null || echo "0")
  check "terraform.tfstate contains resource records" \
    "$([ "$RESOURCE_COUNT" -gt 0 ] && echo pass || echo fail)"
else
  check "terraform.tfstate contains resource records (jq required)" \
    "$([ -f "$STATE_FILE" ] && echo pass || echo fail)"
fi

# Check 4: Container has 'managed-by=opentofu' label
LABEL=$(docker inspect --format '{{index .Config.Labels "managed-by"}}' learn-iac-web 2>/dev/null || echo "")
check "Container has 'managed-by=opentofu' label" \
  "$([ "$LABEL" = "opentofu" ] && echo pass || echo fail)"

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
