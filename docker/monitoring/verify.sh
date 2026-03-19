#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0
COMPOSE_FILE="docker/monitoring/compose.yml"

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

echo "=== Monitoring Stack Verification ==="
echo ""

# 1. App container running
APP_RUNNING=$(docker compose -f "$COMPOSE_FILE" ps --format json 2>/dev/null | grep -c '"app"' || echo "0")
check "App container running" "$([ "$APP_RUNNING" -ge 1 ] && echo pass || echo fail)"

# 2. Prometheus container running
PROM_RUNNING=$(docker compose -f "$COMPOSE_FILE" ps --format json 2>/dev/null | grep -c '"prometheus"' || echo "0")
check "Prometheus container running" "$([ "$PROM_RUNNING" -ge 1 ] && echo pass || echo fail)"

# 3. Grafana container running
GRAFANA_RUNNING=$(docker compose -f "$COMPOSE_FILE" ps --format json 2>/dev/null | grep -c '"grafana"' || echo "0")
check "Grafana container running" "$([ "$GRAFANA_RUNNING" -ge 1 ] && echo pass || echo fail)"

# 4. Alertmanager container running
ALERTMANAGER_RUNNING=$(docker compose -f "$COMPOSE_FILE" ps --format json 2>/dev/null | grep -c '"alertmanager"' || echo "0")
check "Alertmanager container running" "$([ "$ALERTMANAGER_RUNNING" -ge 1 ] && echo pass || echo fail)"

# 5. App /metrics endpoint accessible and has http_requests_total
METRICS_OK=$(curl -sf http://localhost:3000/metrics 2>/dev/null | grep -c 'http_requests_total' || echo "0")
check "App /metrics endpoint has http_requests_total" "$([ "$METRICS_OK" -ge 1 ] && echo pass || echo fail)"

# 6. Prometheus scrapes app (up == 1)
PROM_UP=$(curl -sf "http://localhost:9090/api/v1/query?query=up%7Bjob%3D%22monitored-app%22%7D" 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); v=d['data']['result']; print(v[0]['value'][1] if v else '0')" 2>/dev/null || echo "0")
check "Prometheus scrapes app (up{job=\"monitored-app\"}==1)" "$([ "$PROM_UP" = "1" ] && echo pass || echo fail)"

# 7. Grafana API healthy
GRAFANA_STATUS=$(curl -sf "http://localhost:3001/api/health" 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('database','unknown'))" 2>/dev/null || echo "fail")
check "Grafana API healthy (database=ok)" "$([ "$GRAFANA_STATUS" = "ok" ] && echo pass || echo fail)"

# 8. Alert rules loaded in Prometheus
RULES_COUNT=$(curl -sf "http://localhost:9090/api/v1/rules" 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); groups=d['data']['groups']; print(sum(len(g['rules']) for g in groups))" 2>/dev/null || echo "0")
check "At least 1 alert rule loaded in Prometheus" "$([ "$RULES_COUNT" -ge 1 ] && echo pass || echo fail)"

# 9. App /health endpoint
HEALTH_STATUS=$(curl -sf "http://localhost:3000/health" 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('status','fail'))" 2>/dev/null || echo "fail")
check "App /health endpoint returns status=healthy" "$([ "$HEALTH_STATUS" = "healthy" ] && echo pass || echo fail)"

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
