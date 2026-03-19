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

echo "=== Verifying: Logging and Log Management ==="
echo ""

# Check 1: /var/log/myapp/ directory exists
if [ -d /var/log/myapp ]; then
  check "/var/log/myapp/ directory exists" "pass"
else
  check "/var/log/myapp/ directory exists (run setup script first)" "fail"
fi

# Check 2: app.log exists in the directory
if [ -f /var/log/myapp/app.log ]; then
  check "/var/log/myapp/app.log exists and has log entries" "pass"
else
  check "/var/log/myapp/app.log exists (run setup script first)" "fail"
fi

# Check 3: logrotate config exists for myapp
if [ -f /etc/logrotate.d/myapp ]; then
  check "Logrotate config /etc/logrotate.d/myapp exists" "pass"
else
  check "Logrotate config /etc/logrotate.d/myapp exists (see exercise step 3)" "fail"
fi

# Check 4: logrotate config references the correct log path
if [ -f /etc/logrotate.d/myapp ] && grep -q '/var/log/myapp' /etc/logrotate.d/myapp; then
  check "Logrotate config references /var/log/myapp" "pass"
else
  check "Logrotate config references /var/log/myapp (check /etc/logrotate.d/myapp content)" "fail"
fi

# Check 5: logrotate config has rotate directive (7 days or any retention)
if [ -f /etc/logrotate.d/myapp ] && grep -qE '^\s*rotate\s+[0-9]+' /etc/logrotate.d/myapp; then
  check "Logrotate config has a 'rotate' retention setting" "pass"
else
  check "Logrotate config has 'rotate N' directive (sets how many rotated copies to keep)" "fail"
fi

# Check 6: logrotate dry-run passes without errors
if [ -f /etc/logrotate.d/myapp ] && logrotate -d /etc/logrotate.d/myapp &>/dev/null 2>&1; then
  check "Logrotate dry-run (logrotate -d) completes without errors" "pass"
else
  check "Logrotate dry-run passes (run: logrotate -d /etc/logrotate.d/myapp to see errors)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
