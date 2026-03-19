#!/usr/bin/env bash
# DOC-04: Docker Volumes Verification
# Run from project root: bash docker/app/verify-volumes.sh
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

echo "=== DOC-04: Docker Volumes Verification ==="
echo ""

# Check 1: at least one named volume exists
VOLUME_COUNT=$(docker volume ls --format "{{.Name}}" 2>/dev/null | wc -l | tr -d ' ' || echo "0")
FIRST_VOLUME=$(docker volume ls --format "{{.Name}}" 2>/dev/null | head -1 || echo "")

if [ "$VOLUME_COUNT" -gt 0 ] && [ -n "$FIRST_VOLUME" ]; then
  check "at least one named volume exists ($FIRST_VOLUME)" "pass"
else
  check "no named volumes found — run: docker volume create appdata" "fail"
fi

# Check 2: named volume can be mounted and written to (verify it's functional)
if [ -n "$FIRST_VOLUME" ]; then
  WRITE_TEST=$(docker run --rm -v "${FIRST_VOLUME}:/testmnt" busybox:latest sh -c "echo verify > /testmnt/.verify_check && cat /testmnt/.verify_check" 2>/dev/null || echo "")
  if [ "$WRITE_TEST" = "verify" ]; then
    check "named volume '$FIRST_VOLUME' is mountable and writable" "pass"
  else
    check "could not write to volume '$FIRST_VOLUME' — check: docker volume inspect $FIRST_VOLUME" "fail"
  fi
else
  check "volume mountability — skipped (no volumes found)" "fail"
fi

# Check 3: data persists across container recreations
# Write a unique marker to the volume, then read it back in a fresh container
if [ -n "$FIRST_VOLUME" ]; then
  MARKER="persist-$(date +%s)"
  docker run --rm -v "${FIRST_VOLUME}:/testmnt" busybox:latest sh -c "echo '$MARKER' > /testmnt/.persist_test" 2>/dev/null || true
  READ_BACK=$(docker run --rm -v "${FIRST_VOLUME}:/testmnt" busybox:latest cat /testmnt/.persist_test 2>/dev/null || echo "")
  if [ "$READ_BACK" = "$MARKER" ]; then
    check "data persists in volume '$FIRST_VOLUME' across container recreations" "pass"
  else
    check "data did not persist in volume '$FIRST_VOLUME' — check volume driver: docker volume inspect $FIRST_VOLUME" "fail"
  fi
else
  check "data persistence — skipped (no volumes found)" "fail"
fi

# Check 4: volume inspect shows Mountpoint (volume is properly registered with Docker)
if [ -n "$FIRST_VOLUME" ]; then
  MOUNTPOINT=$(docker volume inspect "$FIRST_VOLUME" --format "{{.Mountpoint}}" 2>/dev/null || echo "")
  if [ -n "$MOUNTPOINT" ]; then
    check "volume '$FIRST_VOLUME' has Docker-managed mountpoint" "pass"
  else
    check "cannot inspect volume '$FIRST_VOLUME' — run: docker volume inspect $FIRST_VOLUME" "fail"
  fi
else
  check "volume inspect — skipped (no volumes found)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
