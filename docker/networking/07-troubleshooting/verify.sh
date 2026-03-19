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

echo "=== Verifying: Network Troubleshooting Exercise ==="
echo ""

# Check 1: Diagnosis written to /tmp/diagnosis.txt
# This lab checks process, not outcome — write your diagnosis to pass
if [ -f /tmp/diagnosis.txt ] && [ -s /tmp/diagnosis.txt ]; then
  check "Diagnosis written to /tmp/diagnosis.txt" "pass"
else
  check "Write your diagnosis: echo 'The fault is: app listening on port 8080 not 80' > /tmp/diagnosis.txt" "fail"
fi

# Check 2: The app IS reachable on port 8080 (confirms learner found the real port)
if curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://app-server:8080/ 2>/dev/null | grep -q "200"; then
  check "Discovered app responds on port 8080 (the intentional fault — wrong port)" "pass"
else
  check "Try: curl http://app-server:8080/ — the app is running but on a non-standard port" "fail"
fi

# Check 3: The standard port 80 does NOT work (confirms the fault is reproduced)
http_code_80=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://app-server/ 2>/dev/null || echo "000")
if [ "$http_code_80" != "200" ]; then
  check "Confirmed: http://app-server/ (port 80) is not responding — fault reproduced" "pass"
else
  check "http://app-server/ returned 200 — the fault may have been fixed or is not the port issue" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
