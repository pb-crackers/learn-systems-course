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

echo "=== Verifying: Text Processing ==="
echo ""

# Check 1: error-urls.txt exists and contains at least 3 lines
if [ -f /tmp/exercise/error-urls.txt ]; then
  line_count=$(wc -l < /tmp/exercise/error-urls.txt)
  if [ "$line_count" -ge 3 ]; then
    check "error-urls.txt exists and has $line_count lines (at least 3 500-error URLs found)" "pass"
  else
    check "error-urls.txt exists but only has $line_count lines — extract more 500-error URLs (run: grep ' 500 ' access.log | awk '{print \$7}' > /tmp/exercise/error-urls.txt)" "fail"
  fi
else
  check "error-urls.txt exists at /tmp/exercise/error-urls.txt (run: grep ' 500 ' /tmp/exercise/access.log | awk '{print \$7}' > /tmp/exercise/error-urls.txt)" "fail"
fi

# Check 2: top-ips.txt exists and is non-empty
if [ -f /tmp/exercise/top-ips.txt ] && [ -s /tmp/exercise/top-ips.txt ]; then
  check "top-ips.txt exists and is non-empty (you counted requests per IP)" "pass"
else
  check "top-ips.txt exists at /tmp/exercise/top-ips.txt (run: awk '{print \$1}' /tmp/exercise/access.log | sort | uniq -c | sort -rn > /tmp/exercise/top-ips.txt)" "fail"
fi

# Check 3: app.conf has been modified — PORT=8080 should be gone
if [ -f /tmp/exercise/app.conf ]; then
  if ! grep -q 'PORT=8080' /tmp/exercise/app.conf; then
    check "app.conf was modified (PORT=8080 is no longer present — sed substitution applied)" "pass"
  else
    check "app.conf still contains PORT=8080 — run: sed -i 's/PORT=8080/PORT=9090/' /tmp/exercise/app.conf" "fail"
  fi
else
  check "app.conf exists at /tmp/exercise/app.conf" "fail"
fi

# Check 4: pipeline-output.txt exists and is non-empty
if [ -f /tmp/exercise/pipeline-output.txt ] && [ -s /tmp/exercise/pipeline-output.txt ]; then
  check "pipeline-output.txt exists and is non-empty (you built a multi-stage pipeline)" "pass"
else
  check "pipeline-output.txt exists at /tmp/exercise/pipeline-output.txt (run your 4-stage pipeline and redirect output there)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
