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

echo "=== Verifying: Shell Fundamentals ==="
echo ""

# Check 1: env-output.txt exists and contains environment variable output
if [ -f /tmp/exercise/env-output.txt ] && [ -s /tmp/exercise/env-output.txt ]; then
  if grep -q '=' /tmp/exercise/env-output.txt; then
    check "env-output.txt exists and contains environment variable output (KEY=VALUE format)" "pass"
  else
    check "env-output.txt exists but does not contain KEY=VALUE entries — run: env > /tmp/exercise/env-output.txt" "fail"
  fi
else
  check "env-output.txt exists at /tmp/exercise/env-output.txt (run: env > /tmp/exercise/env-output.txt)" "fail"
fi

# Check 2: pipeline-result.txt exists and is non-empty
if [ -f /tmp/exercise/pipeline-result.txt ] && [ -s /tmp/exercise/pipeline-result.txt ]; then
  check "pipeline-result.txt exists and is non-empty (you built a multi-stage pipeline)" "pass"
else
  check "pipeline-result.txt exists at /tmp/exercise/pipeline-result.txt (example: grep nginx /tmp/exercise/servers.txt | wc -l > /tmp/exercise/pipeline-result.txt)" "fail"
fi

# Check 3: combined-output.txt exists and contains both stdout and stderr
if [ -f /tmp/exercise/combined-output.txt ] && [ -s /tmp/exercise/combined-output.txt ]; then
  has_stdout=$(grep -c "stdout" /tmp/exercise/combined-output.txt 2>/dev/null || echo "0")
  has_stderr=$(grep -c "ERROR" /tmp/exercise/combined-output.txt 2>/dev/null || echo "0")
  if [ "$has_stdout" -gt 0 ] && [ "$has_stderr" -gt 0 ]; then
    check "combined-output.txt contains both stdout and stderr (2>&1 redirect confirmed)" "pass"
  else
    check "combined-output.txt exists but does not contain both streams — run: /tmp/exercise/mixed-output.sh > /tmp/exercise/combined-output.txt 2>&1" "fail"
  fi
else
  check "combined-output.txt exists at /tmp/exercise/combined-output.txt (run: /tmp/exercise/mixed-output.sh > /tmp/exercise/combined-output.txt 2>&1)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
