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

echo "=== Verifying: Linux Filesystem ==="
echo ""

# Check 1: hard link — original.txt and hardlink.txt share the same inode
if [ -f /tmp/exercise/original.txt ] && [ -f /tmp/exercise/hardlink.txt ]; then
  orig_inode=$(stat -c '%i' /tmp/exercise/original.txt)
  hard_inode=$(stat -c '%i' /tmp/exercise/hardlink.txt)
  if [ "$orig_inode" = "$hard_inode" ]; then
    check "hardlink.txt shares inode $orig_inode with original.txt (hard link confirmed)" "pass"
  else
    check "hardlink.txt exists but has a different inode ($hard_inode) than original.txt ($orig_inode) — use ln (not ln -s)" "fail"
  fi
else
  check "hardlink.txt exists at /tmp/exercise/hardlink.txt (run: ln /tmp/exercise/original.txt /tmp/exercise/hardlink.txt)" "fail"
fi

# Check 2: symbolic link exists
if [ -L /tmp/exercise/softlink.txt ]; then
  check "softlink.txt is a symbolic link" "pass"
else
  check "softlink.txt is a symbolic link at /tmp/exercise/softlink.txt (run: ln -s /tmp/exercise/original.txt /tmp/exercise/softlink.txt)" "fail"
fi

# Check 3: inode-listing.txt exists and is non-empty
if [ -f /tmp/exercise/inode-listing.txt ] && [ -s /tmp/exercise/inode-listing.txt ]; then
  check "inode-listing.txt exists (you ran ls -lai)" "pass"
else
  check "inode-listing.txt exists at /tmp/exercise/inode-listing.txt (run: ls -lai /tmp/exercise/ > /tmp/exercise/inode-listing.txt)" "fail"
fi

# Check 4: mount-info.txt exists and is non-empty
if [ -f /tmp/exercise/mount-info.txt ] && [ -s /tmp/exercise/mount-info.txt ]; then
  check "mount-info.txt exists (you ran findmnt or mount)" "pass"
else
  check "mount-info.txt exists at /tmp/exercise/mount-info.txt (run: findmnt > /tmp/exercise/mount-info.txt)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
