#!/usr/bin/env bash
# DOC-02: Docker Images Verification
# Run from project root: bash docker/app/verify-images.sh
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

echo "=== DOC-02: Docker Images Verification ==="
echo ""

# Check 1: image "myapp:v1" exists
IMAGE_TAG=$(docker images myapp:v1 --format "{{.Repository}}:{{.Tag}}" 2>/dev/null || echo "")
if [ "$IMAGE_TAG" = "myapp:v1" ]; then
  check "image 'myapp:v1' exists" "pass"
else
  check "image 'myapp:v1' not found — run: docker build -t myapp:v1 -f docker/app/Dockerfile.basic docker/app/" "fail"
fi

# Check 2: container "myapp" is running
MYAPP_NAME=$(docker ps --filter name=myapp --format "{{.Names}}" 2>/dev/null || echo "")
if [ "$MYAPP_NAME" = "myapp" ]; then
  check "container 'myapp' is running" "pass"
else
  check "container 'myapp' is not running — run: docker run -d --name myapp -p 3000:3000 myapp:v1" "fail"
fi

# Check 3: app responds on port 3000 with HTTP 200
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/ 2>/dev/null || echo "000")
if [ "$HTTP_CODE" = "200" ]; then
  check "app responds on localhost:3000 with HTTP 200" "pass"
else
  check "app not responding on localhost:3000 (got HTTP $HTTP_CODE) — ensure container is running with -p 3000:3000" "fail"
fi

# Check 4: image has at least one layer
LAYER_COUNT=$(docker image inspect myapp:v1 --format "{{len .RootFS.Layers}}" 2>/dev/null || echo "0")
if [ "$LAYER_COUNT" -gt 0 ] 2>/dev/null; then
  check "image 'myapp:v1' has $LAYER_COUNT layer(s) (built from Dockerfile)" "pass"
else
  check "cannot inspect layers for 'myapp:v1' — ensure image exists: docker images myapp:v1" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
