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

echo "=== Verifying: Disk Management ==="
echo ""

# Check 1: loopback device exists and is attached
if losetup /dev/loop0 &>/dev/null 2>&1; then
  check "Loopback device /dev/loop0 is attached" "pass"
else
  check "Loopback device /dev/loop0 is attached (run setup script: bash /usr/local/lib/learn-systems/setup/04-disk.sh)" "fail"
fi

# Check 2: /mnt/data is a mount point with something mounted
if mount | grep -q '/mnt/data'; then
  check "/mnt/data is mounted" "pass"
else
  check "/mnt/data is mounted (run: sudo mount /dev/loop0p1 /mnt/data)" "fail"
fi

# Check 3: filesystem is accessible (df reports it)
if df -h /mnt/data &>/dev/null 2>&1 && mount | grep -q '/mnt/data'; then
  check "Filesystem on /mnt/data is accessible (df -h /mnt/data works)" "pass"
else
  check "Filesystem is accessible at /mnt/data (check: df -h /mnt/data)" "fail"
fi

# Check 4: /etc/fstab has an entry for /mnt/data
if grep -q '/mnt/data' /etc/fstab; then
  check "/etc/fstab has an entry for /mnt/data" "pass"
else
  check "/etc/fstab has entry for /mnt/data (see exercise step 7)" "fail"
fi

# Check 5: fstab entry uses UUID (not raw device path)
if grep '/mnt/data' /etc/fstab 2>/dev/null | grep -q 'UUID='; then
  check "fstab entry uses UUID= (not raw device path like /dev/loop0p1)" "pass"
else
  check "fstab entry uses UUID= (recommended: UUID=<value> instead of /dev/loop0p1)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
