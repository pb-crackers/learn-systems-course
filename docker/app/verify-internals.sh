#!/usr/bin/env bash
# DOC-01: Container Internals Verification
# Run from project root: bash docker/app/verify-internals.sh
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

echo "=== DOC-01: Container Internals Verification ==="
echo ""

# Check 1: container named "mybox" is running
MYBOX_NAME=$(docker ps --filter name=mybox --format "{{.Names}}" 2>/dev/null || echo "")
if [ "$MYBOX_NAME" = "mybox" ]; then
  check "container 'mybox' is running" "pass"
else
  check "container 'mybox' is not running — run: docker run -d --name mybox ubuntu:22.04 sleep infinity" "fail"
fi

# Check 2: can retrieve the host PID for mybox (PID > 0)
HOST_PID=$(docker inspect mybox --format "{{.State.Pid}}" 2>/dev/null || echo "0")
if [ "$HOST_PID" -gt 0 ] 2>/dev/null; then
  check "host PID for 'mybox' is visible (PID $HOST_PID)" "pass"
else
  check "cannot retrieve host PID for 'mybox' — ensure the container is running" "fail"
  HOST_PID=0
fi

# Check 3: namespace links visible in /proc/<PID>/ns/ (pid, net, mnt present)
if [ "$HOST_PID" -gt 0 ] && [ -d "/proc/$HOST_PID/ns" ]; then
  NS_COUNT=$(ls /proc/"$HOST_PID"/ns/ 2>/dev/null | grep -cE "^(pid|net|mnt)$" || echo "0")
  if [ "$NS_COUNT" -ge 3 ]; then
    check "namespace links (pid, net, mnt) visible in /proc/$HOST_PID/ns/" "pass"
  else
    check "namespace links not found at /proc/$HOST_PID/ns/ — check with: ls -la /proc/$HOST_PID/ns/" "fail"
  fi
else
  check "namespace links visible in /proc/<PID>/ns/ — requires container running and sufficient permissions" "fail"
fi

# Check 4: PID inside container (should be 1) differs from host PID
CONTAINER_PID1=$(docker exec -T mybox cat /proc/1/status 2>/dev/null | grep "^Pid:" | awk '{print $2}' || echo "")
if [ -n "$CONTAINER_PID1" ] && [ "$CONTAINER_PID1" = "1" ] && [ "$HOST_PID" -gt 1 ]; then
  check "PID inside container is 1, host sees it as PID $HOST_PID (namespace isolation confirmed)" "pass"
elif [ -n "$CONTAINER_PID1" ]; then
  check "PID inside container: $CONTAINER_PID1 — namespace isolation may not be visible; run: docker exec mybox cat /proc/1/status | grep Pid" "fail"
else
  check "cannot read /proc/1/status inside container — run: docker exec mybox cat /proc/1/status" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
