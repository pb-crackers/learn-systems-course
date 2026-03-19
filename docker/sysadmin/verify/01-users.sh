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

echo "=== Verifying: User and Group Management ==="
echo ""

# Check 1: alice user exists
if id alice &>/dev/null 2>&1; then
  check "User 'alice' exists" "pass"
else
  check "User 'alice' exists (run: sudo useradd -m -s /bin/bash alice)" "fail"
fi

# Check 2: alice is in devteam group
if id alice &>/dev/null 2>&1 && groups alice 2>/dev/null | grep -qw devteam; then
  check "alice is a member of the 'devteam' group" "pass"
else
  check "alice is a member of 'devteam' (run: sudo usermod -aG devteam alice)" "fail"
fi

# Check 3: bob user exists
if id bob &>/dev/null 2>&1; then
  check "User 'bob' exists" "pass"
else
  check "User 'bob' exists (run: sudo useradd -m -s /bin/bash bob)" "fail"
fi

# Check 4: bob is in ops group
if id bob &>/dev/null 2>&1 && groups bob 2>/dev/null | grep -qw ops; then
  check "bob is a member of the 'ops' group" "pass"
else
  check "bob is a member of 'ops' (run: sudo usermod -aG ops bob)" "fail"
fi

# Check 5: alice has sudoers drop-in file
if [ -f /etc/sudoers.d/alice ]; then
  check "Sudoers drop-in file /etc/sudoers.d/alice exists" "pass"
else
  check "Sudoers drop-in /etc/sudoers.d/alice exists (see exercise step 5)" "fail"
fi

# Check 6: alice has sudo access (NOPASSWD)
if sudo -l -U alice 2>/dev/null | grep -q NOPASSWD; then
  check "alice has NOPASSWD sudo access" "pass"
else
  check "alice has NOPASSWD sudo access (check /etc/sudoers.d/alice content)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
