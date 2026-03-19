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

echo "=== Verifying: Processes ==="
echo ""

# Check 1: found-pid.txt exists and contains a number
if [ -f /tmp/exercise/found-pid.txt ]; then
  pid_content=$(cat /tmp/exercise/found-pid.txt | tr -d '[:space:]')
  if echo "$pid_content" | grep -qE '^[0-9]+$'; then
    check "found-pid.txt exists and contains a PID number (you wrote: $pid_content)" "pass"
  else
    check "found-pid.txt contains non-numeric content — write just the PID number" "fail"
  fi
else
  check "found-pid.txt exists at /tmp/exercise/found-pid.txt (echo <PID> > /tmp/exercise/found-pid.txt)" "fail"
fi

# Check 2: process-cmdline.txt exists and is non-empty
if [ -f /tmp/exercise/process-cmdline.txt ] && [ -s /tmp/exercise/process-cmdline.txt ]; then
  check "process-cmdline.txt exists (you read /proc/<PID>/cmdline)" "pass"
else
  check "process-cmdline.txt exists at /tmp/exercise/process-cmdline.txt (run: cat /proc/<PID>/cmdline | tr '\\0' ' ' > /tmp/exercise/process-cmdline.txt)" "fail"
fi

# Check 3: signal-sent.txt exists and is non-empty
if [ -f /tmp/exercise/signal-sent.txt ] && [ -s /tmp/exercise/signal-sent.txt ]; then
  check "signal-sent.txt exists (you documented sending a signal)" "pass"
else
  check "signal-sent.txt exists at /tmp/exercise/signal-sent.txt (run: echo 'Sent SIGTERM to <PID>' > /tmp/exercise/signal-sent.txt)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
