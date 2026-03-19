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

echo "=== Verifying: HTTP/HTTPS Exercise ==="
echo ""

# Check 1: HTTP server responds with 200 OK
http_code=$(curl -s -o /dev/null -w "%{http_code}" http://webserver/ 2>/dev/null || echo "000")
if [ "$http_code" = "200" ]; then
  check "HTTP server responds with 200 OK at http://webserver/" "pass"
else
  check "HTTP server not responding (got: $http_code) — is nginx running? (docker compose ps)" "fail"
fi

# Check 2: Response headers captured to file with Content-Type present
if [ -f /tmp/exercise/headers.txt ] && grep -qi "content-type" /tmp/exercise/headers.txt; then
  check "HTTP response headers captured to /tmp/exercise/headers.txt (contains Content-Type)" "pass"
else
  check "Run: curl -I http://webserver/ > /tmp/exercise/headers.txt" "fail"
fi

# Check 3: /api endpoint returns JSON
api_response=$(curl -s http://webserver/api 2>/dev/null || echo "")
if echo "$api_response" | grep -qi "json\|status\|service\|{"; then
  check "/api endpoint returns JSON response" "pass"
else
  check "/api endpoint not responding as expected — run: curl http://webserver/api" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
