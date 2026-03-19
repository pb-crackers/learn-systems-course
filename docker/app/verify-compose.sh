#!/usr/bin/env bash
# DOC-06: Docker Compose Verification
# Run from project root: bash docker/app/verify-compose.sh
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

echo "=== DOC-06: Docker Compose Verification ==="
echo ""

# Expected compose file location for the exercise
COMPOSE_FILE="docker/app/compose.yml"

# Check 1: compose.yml exists at the expected location
if [ -f "$COMPOSE_FILE" ]; then
  check "compose.yml exists at $COMPOSE_FILE" "pass"
else
  check "compose.yml not found at $COMPOSE_FILE — create it as part of the lesson exercise" "fail"
fi

# Check 2: at least 2 services are running via docker compose
if [ -f "$COMPOSE_FILE" ]; then
  SERVICE_COUNT=$(docker compose -f "$COMPOSE_FILE" ps --format json 2>/dev/null | \
    python3 -c "import sys,json; data=json.load(sys.stdin); print(len(data))" 2>/dev/null || echo "0")
  if [ "$SERVICE_COUNT" -ge 2 ] 2>/dev/null; then
    check "$SERVICE_COUNT services running in compose stack" "pass"
  else
    check "fewer than 2 services running (found $SERVICE_COUNT) — run: docker compose -f $COMPOSE_FILE up -d" "fail"
  fi
else
  # Fallback: check if ANY docker compose project is running
  ANY_RUNNING=$(docker compose ps --format json 2>/dev/null | \
    python3 -c "import sys,json; data=json.load(sys.stdin); print(len(data))" 2>/dev/null || echo "0")
  if [ "$ANY_RUNNING" -ge 2 ] 2>/dev/null; then
    check "$ANY_RUNNING services running in default compose stack" "pass"
    SERVICE_COUNT="$ANY_RUNNING"
  else
    check "no compose services running — create compose.yml and run: docker compose up -d" "fail"
    SERVICE_COUNT=0
  fi
fi

# Check 3: at least one service shows healthy status (healthcheck configured)
if [ -f "$COMPOSE_FILE" ]; then
  HEALTHY_COUNT=$(docker compose -f "$COMPOSE_FILE" ps 2>/dev/null | grep -c "(healthy)" || echo "0")
  if [ "$HEALTHY_COUNT" -gt 0 ] 2>/dev/null; then
    check "$HEALTHY_COUNT service(s) showing (healthy) status — healthcheck is working" "pass"
  else
    # Services may be running but not have healthchecks — check if services are at least running
    RUNNING_COUNT=$(docker compose -f "$COMPOSE_FILE" ps 2>/dev/null | grep -c "running" || echo "0")
    if [ "$RUNNING_COUNT" -ge 2 ] 2>/dev/null; then
      check "services are running (add HEALTHCHECK to compose.yml for full credit)" "fail"
    else
      check "no healthy services found — add healthcheck: to your compose.yml services" "fail"
    fi
  fi
else
  check "healthcheck status — skipped (compose.yml not found)" "fail"
fi

# Check 4: a named volume is defined (compose-managed volume exists)
if [ -f "$COMPOSE_FILE" ]; then
  # Named volumes from compose projects have the project name prefix
  PROJECT_NAME=$(basename "$(pwd)")-$(dirname "$COMPOSE_FILE" | tr '/' '_') 2>/dev/null || true
  # Check if any volume related to the compose file project exists
  COMPOSE_VOLUMES=$(docker compose -f "$COMPOSE_FILE" config --volumes 2>/dev/null | head -5 || echo "")
  if [ -n "$COMPOSE_VOLUMES" ]; then
    check "named volume(s) defined in compose.yml: $COMPOSE_VOLUMES" "pass"
  else
    check "no named volumes defined in compose.yml — add a top-level volumes: block and mount it in a service" "fail"
  fi
else
  check "named volume check — skipped (compose.yml not found)" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
