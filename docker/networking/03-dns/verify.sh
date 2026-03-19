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

echo "=== Verifying: DNS Resolution Exercise ==="
echo ""

# Check 1: Forward lookup — dig resolves app.learn.local to expected IP
if dig +short app.learn.local @dns 2>/dev/null | grep -q "10\.0\.0\."; then
  check "dig resolves app.learn.local to expected IP (10.0.0.10)" "pass"
else
  check "dig could not resolve app.learn.local — is CoreDNS running? (docker compose ps)" "fail"
fi

# Check 2: Reverse lookup — PTR record for 10.0.0.10 returns app.learn.local
if dig +short -x 10.0.0.10 @dns 2>/dev/null | grep -qi "app.learn.local"; then
  check "Reverse DNS lookup for 10.0.0.10 returns app.learn.local (PTR record works)" "pass"
else
  check "Reverse lookup failed — run: dig -x 10.0.0.10 @dns" "fail"
fi

# Check 3: DNS trace saved to /tmp/exercise/dns-trace.txt
if [ -f /tmp/exercise/dns-trace.txt ] && [ -s /tmp/exercise/dns-trace.txt ]; then
  check "DNS trace saved to /tmp/exercise/dns-trace.txt" "pass"
else
  check "Run: dig +trace app.learn.local @dns > /tmp/exercise/dns-trace.txt" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
