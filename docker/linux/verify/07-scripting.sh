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

echo "=== Verifying: Shell Scripting ==="
echo ""

# Check 1: deploy.sh exists
if [ ! -f /tmp/exercise/deploy.sh ]; then
  check "deploy.sh exists at /tmp/exercise/deploy.sh" "fail"
  echo ""
  printf "\033[31mRESULT: FAIL\033[0m — Script not found, cannot continue checks.\n"
  exit 1
fi

# Check 2: deploy.sh starts with a shebang
first_line=$(head -1 /tmp/exercise/deploy.sh)
if echo "$first_line" | grep -qE '^#!/usr/bin/env bash|^#!/bin/bash'; then
  check "deploy.sh starts with a valid shebang (#!/usr/bin/env bash or #!/bin/bash)" "pass"
else
  check "deploy.sh first line is not a shebang — first line is: $first_line" "fail"
fi

# Check 3: deploy.sh contains set -e (at minimum) or set -euo pipefail
if grep -q 'set -euo pipefail\|set -e' /tmp/exercise/deploy.sh; then
  check "deploy.sh contains set -e or set -euo pipefail (error handling enabled)" "pass"
else
  check "deploy.sh does not contain 'set -e' or 'set -euo pipefail' — add safe-mode flags" "fail"
fi

# Check 4: deploy.sh is executable
if [ -x /tmp/exercise/deploy.sh ]; then
  check "deploy.sh is executable (chmod +x applied)" "pass"
else
  check "deploy.sh is not executable — run: chmod +x /tmp/exercise/deploy.sh" "fail"
fi

# Check 5: deploy.sh contains a function definition
if grep -qE 'function [a-zA-Z_]+|[a-zA-Z_]+[[:space:]]*\(\)[[:space:]]*\{' /tmp/exercise/deploy.sh; then
  check "deploy.sh contains a function definition" "pass"
else
  check "deploy.sh does not contain a function definition — add a log() or similar function" "fail"
fi

# Check 6: script runs successfully with a valid argument (exit 0)
if bash /tmp/exercise/deploy.sh test-env > /dev/null 2>&1; then
  check "deploy.sh runs successfully when given a valid argument (exits 0)" "pass"
else
  check "deploy.sh exits non-zero when given argument 'test-env' — check for syntax errors: bash -n /tmp/exercise/deploy.sh" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
