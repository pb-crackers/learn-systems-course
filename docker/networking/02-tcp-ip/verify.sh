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

echo "=== Verifying: TCP/IP Stack Exercise ==="
echo ""

# Check 1: ip-info.txt exists and contains IP address data
if [ -f /tmp/exercise/ip-info.txt ] && grep -q "inet " /tmp/exercise/ip-info.txt; then
  check "IP address info saved to /tmp/exercise/ip-info.txt" "pass"
else
  check "Run: ip addr show > /tmp/exercise/ip-info.txt" "fail"
fi

# Check 2: routes.txt exists and is non-empty
if [ -f /tmp/exercise/routes.txt ] && [ -s /tmp/exercise/routes.txt ]; then
  check "Routing table saved to /tmp/exercise/routes.txt" "pass"
else
  check "Run: ip route show > /tmp/exercise/routes.txt" "fail"
fi

# Check 3: subnet-answer.txt exists and contains the 10.0.0 subnet
if [ -f /tmp/exercise/subnet-answer.txt ] && grep -q "10\.0\.0" /tmp/exercise/subnet-answer.txt; then
  check "Subnet recorded in /tmp/exercise/subnet-answer.txt (contains 10.0.0)" "pass"
else
  check "Run: echo '10.0.0.0/24' > /tmp/exercise/subnet-answer.txt" "fail"
fi

# Check 4: server is reachable via ping
if ping -c 1 -W 2 10.0.0.10 &>/dev/null; then
  check "Server at 10.0.0.10 is reachable via ping (same subnet communication works)" "pass"
else
  check "Cannot ping 10.0.0.10 — is the server container running? (docker compose ps)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
