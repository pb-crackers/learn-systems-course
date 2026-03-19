#!/usr/bin/env bash
# DOC-05: Docker Networking Verification
# Run from project root: bash docker/app/verify-networking.sh
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

echo "=== DOC-05: Docker Networking Verification ==="
echo ""

# Find a custom (non-default) network — look for appnet, mynet, or any bridge network created by user
CUSTOM_NET=$(docker network ls --format "{{.Name}}" 2>/dev/null | grep -Ev "^(bridge|host|none)$" | head -1 || echo "")

# Check 1: at least one custom network exists
if [ -n "$CUSTOM_NET" ]; then
  check "custom network '$CUSTOM_NET' exists" "pass"
else
  check "no custom network found — run: docker network create appnet" "fail"
fi

# Check 2: at least 2 containers on the custom network
if [ -n "$CUSTOM_NET" ]; then
  CONTAINER_COUNT=$(docker network inspect "$CUSTOM_NET" --format "{{len .Containers}}" 2>/dev/null || echo "0")
  if [ "$CONTAINER_COUNT" -ge 2 ]; then
    check "custom network '$CUSTOM_NET' has $CONTAINER_COUNT containers connected" "pass"
  else
    check "custom network '$CUSTOM_NET' has fewer than 2 containers (found $CONTAINER_COUNT) — connect two containers with --network $CUSTOM_NET" "fail"
  fi
else
  check "container count on custom network — skipped (no custom network found)" "fail"
fi

# Check 3: containers can resolve each other by name via DNS
if [ -n "$CUSTOM_NET" ] && [ "$CONTAINER_COUNT" -ge 2 ] 2>/dev/null; then
  # Get names of first two containers on the network
  CONTAINER_NAMES=$(docker network inspect "$CUSTOM_NET" --format "{{range .Containers}}{{.Name}} {{end}}" 2>/dev/null || echo "")
  FIRST=$(echo "$CONTAINER_NAMES" | awk '{print $1}')
  SECOND=$(echo "$CONTAINER_NAMES" | awk '{print $2}')

  if [ -n "$FIRST" ] && [ -n "$SECOND" ]; then
    # Try ping between containers (busybox-based or full images may not have ping)
    PING_RESULT=$(docker exec -T "$FIRST" ping -c 1 -W 2 "$SECOND" 2>/dev/null && echo "ok" || echo "fail")
    if [ "$PING_RESULT" = "ok" ]; then
      check "container '$FIRST' can ping '$SECOND' by name (DNS resolution working)" "pass"
    else
      # Fallback: try nslookup as DNS check even if ping unavailable
      DNS_RESULT=$(docker exec -T "$FIRST" nslookup "$SECOND" 2>/dev/null | grep -c "Address" || echo "0")
      if [ "$DNS_RESULT" -gt 0 ]; then
        check "DNS resolution works: '$FIRST' resolves '$SECOND' by name" "pass"
      else
        check "containers cannot resolve each other by name — both must be on the same custom network: --network $CUSTOM_NET" "fail"
      fi
    fi
  else
    check "container DNS resolution — cannot determine container names on '$CUSTOM_NET'" "fail"
  fi
else
  check "container DNS resolution — skipped (fewer than 2 containers on custom network)" "fail"
fi

# Check 4: any running container on the custom network has a port mapping (optional — pass if network exists)
if [ -n "$CUSTOM_NET" ]; then
  PORT_MAPPED=$(docker ps --filter network="$CUSTOM_NET" --format "{{.Ports}}" 2>/dev/null | grep -c "->") || PORT_MAPPED=0
  if [ "$PORT_MAPPED" -gt 0 ] 2>/dev/null; then
    check "at least one container on '$CUSTOM_NET' has a host port mapping" "pass"
  else
    check "no containers on '$CUSTOM_NET' have port mappings — publish a port with -p when running: docker run -d -p 3000:3000 --network $CUSTOM_NET ..." "fail"
  fi
else
  check "port mapping check — skipped (no custom network found)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
