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

echo "=== Verifying: Operating Systems ==="
echo ""

# Check 1: kernel-version.txt exists and is non-empty
if [ -f /tmp/exercise/kernel-version.txt ] && [ -s /tmp/exercise/kernel-version.txt ]; then
  check "kernel-version.txt exists and is non-empty" "pass"
else
  check "kernel-version.txt exists at /tmp/exercise/kernel-version.txt (run: uname -r > /tmp/exercise/kernel-version.txt)" "fail"
fi

# Check 2: strace-output.txt exists and contains system call output
if [ -f /tmp/exercise/strace-output.txt ] && [ -s /tmp/exercise/strace-output.txt ]; then
  if grep -qE 'write\(|openat\(|read\(|execve\(' /tmp/exercise/strace-output.txt; then
    check "strace-output.txt contains system call traces (write(, openat(, or similar)" "pass"
  else
    check "strace-output.txt exists but does not contain recognizable system calls — re-run strace and redirect stderr with 2>" "fail"
  fi
else
  check "strace-output.txt exists at /tmp/exercise/strace-output.txt (run: strace ls /tmp 2>/tmp/exercise/strace-output.txt)" "fail"
fi

# Check 3: init-cmdline.txt exists and is non-empty
if [ -f /tmp/exercise/init-cmdline.txt ] && [ -s /tmp/exercise/init-cmdline.txt ]; then
  check "init-cmdline.txt exists (you read /proc/1/cmdline)" "pass"
else
  check "init-cmdline.txt exists at /tmp/exercise/init-cmdline.txt (run: cat /proc/1/cmdline | tr '\\0' ' ' > /tmp/exercise/init-cmdline.txt)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
