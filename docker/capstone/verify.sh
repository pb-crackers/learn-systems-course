#!/usr/bin/env bash
# docker/capstone/verify.sh
# Run from the project root: bash docker/capstone/verify.sh
#
# Verifies the Foundation Capstone stack is correctly deployed.
# All 7 checks correspond to VerificationChecklist items in the lesson MDX.

set -euo pipefail

# python3 is required for parsing docker compose ps JSON output
command -v python3 >/dev/null || { echo "ERROR: python3 is required but not found in PATH"; exit 1; }

PASS=0
FAIL=0
COMPOSE_FILE="docker/capstone/compose.yml"

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

echo "=== Foundation Capstone Verification ==="
echo ""

# ─── Check 1: web service is running ───────────────────────────────────────
WEB_STATE=$(docker compose -f "$COMPOSE_FILE" ps --format json web 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d[0]['State'])" 2>/dev/null || echo "missing")

if [ "$WEB_STATE" = "running" ]; then
  check "web service is running" "pass"
else
  check "web service is not running — run: bash docker/capstone/deploy.sh then re-run verify.sh" "fail"
fi

# ─── Check 2: api service is running ───────────────────────────────────────
API_STATE=$(docker compose -f "$COMPOSE_FILE" ps --format json api 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d[0]['State'])" 2>/dev/null || echo "missing")

if [ "$API_STATE" = "running" ]; then
  check "api service is running" "pass"
else
  check "api service is not running — check: docker compose -f docker/capstone/compose.yml logs api" "fail"
fi

# ─── Check 3: db service is running ────────────────────────────────────────
DB_STATE=$(docker compose -f "$COMPOSE_FILE" ps --format json db 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d[0]['State'])" 2>/dev/null || echo "missing")

if [ "$DB_STATE" = "running" ]; then
  check "db service is running" "pass"
else
  check "db service is not running — check: docker compose -f docker/capstone/compose.yml logs db" "fail"
fi

# ─── Check 4: web service accessible on localhost:8080 ─────────────────────
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 http://localhost:8080/ 2>/dev/null || echo "000")

if [ "$HTTP_CODE" = "200" ]; then
  check "web service responds on localhost:8080 (HTTP 200)" "pass"
else
  check "web service not responding on port 8080 (got HTTP $HTTP_CODE) — check ports: mapping in compose.yml for the web service" "fail"
fi

# ─── Check 5: API responds via web reverse proxy (inter-service networking) ─
API_VIA_WEB=$(docker compose -f "$COMPOSE_FILE" exec -T web \
  curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 http://api:3000/health 2>/dev/null || echo "000")

if [ "$API_VIA_WEB" = "200" ]; then
  check "web can reach API service by hostname 'api' (inter-service networking works)" "pass"
else
  check "web cannot reach api service — check both services are on the same custom Compose network (got HTTP $API_VIA_WEB). Run: docker compose -f docker/capstone/compose.yml exec web curl http://api:3000/health" "fail"
fi

# ─── Check 6: API container runs as non-root user ──────────────────────────
API_UID=$(docker compose -f "$COMPOSE_FILE" exec -T api id -u 2>/dev/null || echo "0")

if [ "$API_UID" != "0" ]; then
  check "API container runs as non-root user (uid=$API_UID)" "pass"
else
  check "API container runs as root (uid=0) — add a USER instruction in docker/capstone/api/Dockerfile after creating a system user" "fail"
fi

# ─── Check 7: deploy.sh exists and is executable ───────────────────────────
if [ -x docker/capstone/deploy.sh ]; then
  check "deploy.sh exists and is executable" "pass"
else
  check "deploy.sh missing or not executable — create docker/capstone/deploy.sh and run: chmod +x docker/capstone/deploy.sh" "fail"
fi

echo ""
TOTAL=$((PASS + FAIL))
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed. Foundation Capstone complete!\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$TOTAL"
  exit 1
fi
