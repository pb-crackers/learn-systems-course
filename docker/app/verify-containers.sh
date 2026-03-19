#!/usr/bin/env bash
# DOC-03: Docker Containers Verification
# Run from project root: bash docker/app/verify-containers.sh
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

echo "=== DOC-03: Docker Containers Verification ==="
echo ""

# Determine which exercise container is running (debug-app or limited-app)
DEBUG_NAME=$(docker ps --filter name=debug-app --format "{{.Names}}" 2>/dev/null || echo "")
LIMITED_NAME=$(docker ps --filter name=limited-app --format "{{.Names}}" 2>/dev/null || echo "")

RUNNING_NAME=""
if [ "$DEBUG_NAME" = "debug-app" ]; then
  RUNNING_NAME="debug-app"
elif [ "$LIMITED_NAME" = "limited-app" ]; then
  RUNNING_NAME="limited-app"
fi

# Check 1: at least one exercise container is running
if [ -n "$RUNNING_NAME" ]; then
  check "exercise container '$RUNNING_NAME' is running" "pass"
else
  check "no exercise container running — run: docker run -d --name debug-app -p 3000:3000 myapp:v1" "fail"
fi

# Check 2: can exec into the running container
if [ -n "$RUNNING_NAME" ]; then
  EXEC_OUT=$(docker exec -T "$RUNNING_NAME" echo "exec works" 2>/dev/null || echo "")
  if [ "$EXEC_OUT" = "exec works" ]; then
    check "docker exec works on '$RUNNING_NAME'" "pass"
  else
    check "docker exec failed on '$RUNNING_NAME' — try: docker exec $RUNNING_NAME echo test" "fail"
  fi
else
  check "docker exec — skipped (no container running)" "fail"
fi

# Check 3: container logs are accessible and non-empty
if [ -n "$RUNNING_NAME" ]; then
  LOG_LINE=$(docker logs "$RUNNING_NAME" 2>&1 | head -1 || echo "")
  if [ -n "$LOG_LINE" ]; then
    check "logs accessible for '$RUNNING_NAME'" "pass"
  else
    check "no log output found for '$RUNNING_NAME' — try: docker logs $RUNNING_NAME" "fail"
  fi
else
  check "container logs — skipped (no container running)" "fail"
fi

# Check 4: limited-app has a memory limit set (non-zero)
if [ "$LIMITED_NAME" = "limited-app" ]; then
  MEM_LIMIT=$(docker inspect limited-app --format "{{.HostConfig.Memory}}" 2>/dev/null || echo "0")
  if [ "$MEM_LIMIT" -gt 0 ] 2>/dev/null; then
    check "limited-app has memory limit set (${MEM_LIMIT} bytes)" "pass"
  else
    check "limited-app has no memory limit — run: docker run -d --name limited-app --memory=128m --cpus=0.5 -p 3001:3000 myapp:v1" "fail"
  fi
else
  check "resource-limited container — run with memory limit: docker run -d --name limited-app --memory=128m --cpus=0.5 -p 3001:3000 myapp:v1" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
