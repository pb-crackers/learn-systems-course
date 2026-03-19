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

echo "=== Verifying: How Computers Work ==="
echo ""

# Check 1: cpu-cores.txt exists and contains a number
if [ -f /tmp/exercise/cpu-cores.txt ]; then
  content=$(cat /tmp/exercise/cpu-cores.txt | tr -d '[:space:]')
  if echo "$content" | grep -qE '^[0-9]+$'; then
    check "cpu-cores.txt exists and contains a number (you wrote: $content)" "pass"
  else
    check "cpu-cores.txt exists but does not contain a plain number (got: $content)" "fail"
  fi
else
  check "cpu-cores.txt exists at /tmp/exercise/cpu-cores.txt" "fail"
fi

# Check 2: total-memory.txt exists and is non-empty
if [ -f /tmp/exercise/total-memory.txt ] && [ -s /tmp/exercise/total-memory.txt ]; then
  check "total-memory.txt exists and is non-empty" "pass"
else
  check "total-memory.txt exists at /tmp/exercise/total-memory.txt and is non-empty" "fail"
fi

# Check 3: block-devices.txt exists and is non-empty
if [ -f /tmp/exercise/block-devices.txt ] && [ -s /tmp/exercise/block-devices.txt ]; then
  check "block-devices.txt exists and is non-empty" "pass"
else
  check "block-devices.txt exists at /tmp/exercise/block-devices.txt and is non-empty" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
