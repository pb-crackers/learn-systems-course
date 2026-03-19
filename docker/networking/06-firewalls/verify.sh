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

echo "=== Verifying: Firewall Exercise ==="
echo ""

# Check 1: iptables shows at least one non-default rule (beyond the ACCEPT policy line)
rule_count=$(iptables -L INPUT -n 2>/dev/null | grep -c -E "ACCEPT|DROP|REJECT" || echo "0")
if [ "$rule_count" -gt 0 ]; then
  check "iptables INPUT chain has $rule_count rule(s) defined" "pass"
else
  check "No iptables rules found — run exercises 3-7 to add firewall rules" "fail"
fi

# Check 2: Port 80 on target is reachable (allowed traffic still works)
http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://target/ 2>/dev/null || echo "000")
if [ "$http_code" = "200" ]; then
  check "HTTP port 80 on target is reachable (allowed port works through firewall)" "pass"
else
  check "Cannot reach http://target/ (got: $http_code) — ensure port 80 is in your ACCEPT rules before the DROP rule" "fail"
fi

# Check 3: Rules saved to /tmp/exercise/rules.txt
if [ -f /tmp/exercise/rules.txt ] && [ -s /tmp/exercise/rules.txt ]; then
  check "iptables rules saved to /tmp/exercise/rules.txt" "pass"
else
  check "Run: iptables -L -n > /tmp/exercise/rules.txt" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
