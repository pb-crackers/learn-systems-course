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

echo "=== Verifying: Package Management ==="
echo ""

# Check 1: 'tree' package is installed
if dpkg -s tree > /dev/null 2>&1; then
  check "tree package is installed (dpkg -s tree succeeds)" "pass"
else
  check "tree package is not installed — run: apt-get install -y tree" "fail"
fi

# Check 2: tree-files.txt exists and is non-empty
if [ -f /tmp/exercise/tree-files.txt ] && [ -s /tmp/exercise/tree-files.txt ]; then
  check "tree-files.txt exists (you ran dpkg -L tree)" "pass"
else
  check "tree-files.txt exists at /tmp/exercise/tree-files.txt (run: dpkg -L tree > /tmp/exercise/tree-files.txt)" "fail"
fi

# Check 3: curl-deps.txt exists and is non-empty
if [ -f /tmp/exercise/curl-deps.txt ] && [ -s /tmp/exercise/curl-deps.txt ]; then
  check "curl-deps.txt exists (you ran apt-cache depends curl)" "pass"
else
  check "curl-deps.txt exists at /tmp/exercise/curl-deps.txt (run: apt-cache depends curl > /tmp/exercise/curl-deps.txt)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
