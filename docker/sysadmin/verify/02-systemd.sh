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

echo "=== Verifying: systemd Service Management ==="
echo ""

# Check 1: unit file exists
if [ -f /etc/systemd/system/hello.service ]; then
  check "Unit file /etc/systemd/system/hello.service exists" "pass"
else
  check "Unit file /etc/systemd/system/hello.service exists (see exercise step 1)" "fail"
fi

# Check 2: unit file has required sections
if [ -f /etc/systemd/system/hello.service ] && \
   grep -q '\[Unit\]' /etc/systemd/system/hello.service && \
   grep -q '\[Service\]' /etc/systemd/system/hello.service && \
   grep -q '\[Install\]' /etc/systemd/system/hello.service; then
  check "Unit file has [Unit], [Service], and [Install] sections" "pass"
else
  check "Unit file has [Unit], [Service], and [Install] sections (check file content)" "fail"
fi

# Check 3: ExecStart points to hello.sh
if [ -f /etc/systemd/system/hello.service ] && \
   grep -q 'ExecStart=/usr/local/bin/hello.sh' /etc/systemd/system/hello.service; then
  check "ExecStart=/usr/local/bin/hello.sh is set in unit file" "pass"
else
  check "ExecStart=/usr/local/bin/hello.sh is set in unit file (check [Service] section)" "fail"
fi

# Check 4: service is active
if systemctl is-active hello &>/dev/null 2>&1; then
  check "hello.service is currently active (running)" "pass"
else
  check "hello.service is active (run: sudo systemctl start hello)" "fail"
fi

# Check 5: service is enabled
if systemctl is-enabled hello &>/dev/null 2>&1; then
  check "hello.service is enabled (will start on boot)" "pass"
else
  check "hello.service is enabled (run: sudo systemctl enable hello)" "fail"
fi

# Check 6: journal has output from the service
if journalctl -u hello --no-pager -n 5 2>/dev/null | grep -q "hello"; then
  check "journalctl shows output from hello.service" "pass"
else
  check "journalctl has output from hello (service may need to run for a few seconds)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
