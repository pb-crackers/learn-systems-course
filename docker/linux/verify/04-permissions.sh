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

echo "=== Verifying: File Permissions and Ownership ==="
echo ""

# Check 1: secret.txt has permissions 600
if [ -f /tmp/exercise/secret.txt ]; then
  perms=$(stat -c '%a' /tmp/exercise/secret.txt)
  if [ "$perms" = "600" ]; then
    check "secret.txt has permissions 600 (owner read/write only)" "pass"
  else
    check "secret.txt has permissions $perms — expected 600 (run: chmod 600 /tmp/exercise/secret.txt)" "fail"
  fi
else
  check "secret.txt exists at /tmp/exercise/secret.txt" "fail"
fi

# Check 2: scripts/ directory is executable (traverse permission)
if [ -d /tmp/exercise/scripts ]; then
  if [ -x /tmp/exercise/scripts ]; then
    check "scripts/ directory has execute permission (traversable)" "pass"
  else
    check "scripts/ directory is not executable — run: chmod 750 /tmp/exercise/scripts" "fail"
  fi
else
  check "scripts/ directory exists at /tmp/exercise/scripts" "fail"
fi

# Check 3: shared/ has the sticky bit set
if [ -d /tmp/exercise/shared ]; then
  if [ -k /tmp/exercise/shared ]; then
    check "shared/ directory has the sticky bit set (shown as 't')" "pass"
  else
    check "shared/ directory does not have the sticky bit — run: chmod +t /tmp/exercise/shared" "fail"
  fi
else
  check "shared/ directory exists at /tmp/exercise/shared" "fail"
fi

# Check 4: deploy.sh is executable by owner
if [ -f /tmp/exercise/scripts/deploy.sh ]; then
  if [ -x /tmp/exercise/scripts/deploy.sh ]; then
    check "scripts/deploy.sh is executable" "pass"
  else
    check "scripts/deploy.sh is not executable — run: chmod u+x /tmp/exercise/scripts/deploy.sh" "fail"
  fi
else
  check "scripts/deploy.sh exists at /tmp/exercise/scripts/deploy.sh" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
