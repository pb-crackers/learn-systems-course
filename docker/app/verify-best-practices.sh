#!/usr/bin/env bash
# DOC-07: Dockerfile Best Practices Verification
# Run from project root: bash docker/app/verify-best-practices.sh
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

echo "=== DOC-07: Dockerfile Best Practices Verification ==="
echo ""

# Check 1: image "app:optimized" exists
IMAGE_TAG=$(docker images app:optimized --format "{{.Repository}}:{{.Tag}}" 2>/dev/null || echo "")
if [ "$IMAGE_TAG" = "app:optimized" ]; then
  check "image 'app:optimized' exists" "pass"
else
  check "image 'app:optimized' not found — run: docker build --no-cache -t app:optimized -f docker/app/Dockerfile.optimized docker/app/" "fail"
fi

# Check 2: optimized image size under 200MB
# Docker reports sizes in B, KB, MB, GB — parse the output
if [ -n "$IMAGE_TAG" ]; then
  IMAGE_SIZE_STR=$(docker images app:optimized --format "{{.Size}}" 2>/dev/null || echo "")
  SIZE_OK="fail"

  if echo "$IMAGE_SIZE_STR" | grep -qE "^[0-9]+(\.[0-9]+)?MB$"; then
    # Parse MB value
    SIZE_NUM=$(echo "$IMAGE_SIZE_STR" | grep -oE "[0-9]+(\.[0-9]+)?")
    if python3 -c "import sys; sys.exit(0 if float('$SIZE_NUM') < 200 else 1)" 2>/dev/null; then
      SIZE_OK="pass"
    fi
  elif echo "$IMAGE_SIZE_STR" | grep -qE "^[0-9]+(\.[0-9]+)?kB$"; then
    # kB is well under 200MB
    SIZE_OK="pass"
  elif echo "$IMAGE_SIZE_STR" | grep -qE "^[0-9]+(\.[0-9]+)?GB$"; then
    # GB is over 200MB
    SIZE_OK="fail"
  fi

  if [ "$SIZE_OK" = "pass" ]; then
    check "image 'app:optimized' is under 200MB (size: $IMAGE_SIZE_STR)" "pass"
  else
    check "image 'app:optimized' is NOT under 200MB (size: $IMAGE_SIZE_STR) — ensure Dockerfile.optimized uses FROM node:20-alpine" "fail"
  fi
else
  check "image size check — skipped (image 'app:optimized' not found)" "fail"
fi

# Check 3: container runs as non-root user (UID != 0)
if [ -n "$IMAGE_TAG" ]; then
  CONTAINER_UID=$(docker run --rm app:optimized id -u 2>/dev/null || echo "0")
  if [ "$CONTAINER_UID" != "0" ] && [ -n "$CONTAINER_UID" ]; then
    check "container runs as non-root user (uid=$CONTAINER_UID)" "pass"
  else
    check "container runs as root (uid=0) — add USER instruction to Dockerfile.optimized (e.g., USER node)" "fail"
  fi
else
  check "non-root user check — skipped (image 'app:optimized' not found)" "fail"
fi

# Check 4: HEALTHCHECK is defined in the image config
if [ -n "$IMAGE_TAG" ]; then
  HEALTHCHECK=$(docker inspect app:optimized --format "{{.Config.Healthcheck}}" 2>/dev/null || echo "")
  if [ -n "$HEALTHCHECK" ] && [ "$HEALTHCHECK" != "<nil>" ] && [ "$HEALTHCHECK" != "map[]" ]; then
    check "HEALTHCHECK is defined in 'app:optimized' image config" "pass"
  else
    check "no HEALTHCHECK defined in 'app:optimized' — add HEALTHCHECK instruction to Dockerfile.optimized" "fail"
  fi
else
  check "HEALTHCHECK check — skipped (image 'app:optimized' not found)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
