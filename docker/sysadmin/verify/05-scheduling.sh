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

echo "=== Verifying: Process Scheduling ==="
echo ""

# Check 1: backup.sh exists
if [ -f /usr/local/bin/backup.sh ] && [ -x /usr/local/bin/backup.sh ]; then
  check "backup.sh exists and is executable at /usr/local/bin/backup.sh" "pass"
else
  check "backup.sh exists at /usr/local/bin/backup.sh (run setup script first)" "fail"
fi

# Check 2: report.sh exists
if [ -f /usr/local/bin/report.sh ] && [ -x /usr/local/bin/report.sh ]; then
  check "report.sh exists and is executable at /usr/local/bin/report.sh" "pass"
else
  check "report.sh exists at /usr/local/bin/report.sh (run setup script first)" "fail"
fi

# Check 3: crontab has a backup entry
if crontab -l 2>/dev/null | grep -q 'backup.sh'; then
  check "crontab has a backup.sh entry" "pass"
else
  check "crontab has backup.sh scheduled (run: crontab -e, add: */2 * * * * /usr/local/bin/backup.sh)" "fail"
fi

# Check 4: cron syntax is valid (5 fields before the command)
if crontab -l 2>/dev/null | grep 'backup.sh' | grep -qE '^(\*|[0-9*/,-]+)[[:space:]]+(\*|[0-9*/,-]+)[[:space:]]+(\*|[0-9*/,-]+)[[:space:]]+(\*|[0-9*/,-]+)[[:space:]]+(\*|[0-9*/,-]+)[[:space:]]'; then
  check "crontab backup entry has valid 5-field syntax" "pass"
else
  check "crontab backup entry has valid cron syntax (5 fields: min hour day month weekday)" "fail"
fi

# Check 5: backup ran at least once (log file has content)
if [ -f /var/backups/myapp/backup.log ] && [ -s /var/backups/myapp/backup.log ]; then
  check "backup.sh has run at least once (/var/backups/myapp/backup.log exists and is non-empty)" "pass"
else
  check "backup.sh has run (wait 2+ minutes for cron, or test manually: bash /usr/local/bin/backup.sh)" "fail"
fi

# Check 6: systemd timer is active (optional — timer unit approach)
# This check is conditional: only tested if the timer file exists.
if [ -f /etc/systemd/system/report.timer ]; then
  if systemctl is-active report.timer &>/dev/null 2>&1; then
    check "report.timer systemd timer is active" "pass"
  else
    check "report.timer exists but is not active (run: sudo systemctl enable --now report.timer)" "fail"
  fi
else
  # Timer not created — skip this check, note it's optional
  printf "  \033[33mSKIP\033[0m: systemd timer for report.sh (not created yet — see exercise step 5)\n"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
