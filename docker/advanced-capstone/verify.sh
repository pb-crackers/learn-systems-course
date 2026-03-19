#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

check() {
  local desc="$1" result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Advanced Capstone Verification ==="
echo ""

# Determine where to run compose commands from
COMPOSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. App service running
APP_RUNNING=$(docker compose -f "$COMPOSE_DIR/compose.yml" ps --format json 2>/dev/null | \
  python3 -c "
import sys, json
lines = sys.stdin.read().strip().splitlines()
services = [json.loads(l) for l in lines if l.strip()]
app = next((s for s in services if s.get('Service') == 'app'), None)
print('pass' if app and 'running' in (app.get('State') or app.get('Status', '')).lower() else 'fail')
" 2>/dev/null || echo "fail")
check "App service is running" "$APP_RUNNING"

# 2. Prometheus service running
PROM_RUNNING=$(docker compose -f "$COMPOSE_DIR/compose.yml" ps --format json 2>/dev/null | \
  python3 -c "
import sys, json
lines = sys.stdin.read().strip().splitlines()
services = [json.loads(l) for l in lines if l.strip()]
svc = next((s for s in services if s.get('Service') == 'prometheus'), None)
print('pass' if svc and 'running' in (svc.get('State') or svc.get('Status', '')).lower() else 'fail')
" 2>/dev/null || echo "fail")
check "Prometheus service is running" "$PROM_RUNNING"

# 3. Grafana service running
GRAFANA_RUNNING=$(docker compose -f "$COMPOSE_DIR/compose.yml" ps --format json 2>/dev/null | \
  python3 -c "
import sys, json
lines = sys.stdin.read().strip().splitlines()
services = [json.loads(l) for l in lines if l.strip()]
svc = next((s for s in services if s.get('Service') == 'grafana'), None)
print('pass' if svc and 'running' in (svc.get('State') or svc.get('Status', '')).lower() else 'fail')
" 2>/dev/null || echo "fail")
check "Grafana service is running" "$GRAFANA_RUNNING"

# 4. Alertmanager service running
AM_RUNNING=$(docker compose -f "$COMPOSE_DIR/compose.yml" ps --format json 2>/dev/null | \
  python3 -c "
import sys, json
lines = sys.stdin.read().strip().splitlines()
services = [json.loads(l) for l in lines if l.strip()]
svc = next((s for s in services if s.get('Service') == 'alertmanager'), None)
print('pass' if svc and 'running' in (svc.get('State') or svc.get('Status', '')).lower() else 'fail')
" 2>/dev/null || echo "fail")
check "Alertmanager service is running" "$AM_RUNNING"

# 5. Prometheus can reach app /metrics target (up == 1)
PROM_UP=$(curl -sf "http://localhost:9090/api/v1/query?query=up%7Bjob%3D%22app%22%7D" | \
  python3 -c "
import sys, json
d = json.load(sys.stdin)
v = d['data']['result']
print(v[0]['value'][1] if v else '0')
" 2>/dev/null || echo "0")
check "Prometheus scrapes app /metrics (up==1)" "$([ "$PROM_UP" = "1" ] && echo pass || echo fail)"

# 6. Grafana API accessible and database healthy
GRAFANA_STATUS=$(curl -sf "http://localhost:3001/api/health" | \
  python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('database', 'unknown'))
" 2>/dev/null || echo "fail")
check "Grafana API healthy (database=ok)" "$([ "$GRAFANA_STATUS" = "ok" ] && echo pass || echo fail)"

# 7. At least 1 alert rule loaded in Prometheus
RULES_COUNT=$(curl -sf "http://localhost:9090/api/v1/rules" | \
  python3 -c "
import sys, json
d = json.load(sys.stdin)
groups = d['data']['groups']
print(sum(len(g['rules']) for g in groups))
" 2>/dev/null || echo "0")
check "At least 1 alert rule loaded in Prometheus" "$([ "$RULES_COUNT" -ge 1 ] && echo pass || echo fail)"

# 8. Memory leak is detectable — nodejs_heap_used_bytes metric exists
HEAP_EXISTS=$(curl -sf "http://localhost:9090/api/v1/query?query=nodejs_heap_used_bytes" | \
  python3 -c "
import sys, json
d = json.load(sys.stdin)
print('yes' if d['data']['result'] else 'no')
" 2>/dev/null || echo "no")
check "nodejs_heap_used_bytes metric exists in Prometheus" "$([ "$HEAP_EXISTS" = "yes" ] && echo pass || echo fail)"

# 9. OpenTofu state file exists (optional IaC step — SKIP if not run yet)
if [ -f "$COMPOSE_DIR/iac/terraform.tfstate" ]; then
  check "OpenTofu state file (iac/terraform.tfstate) exists" "pass"
else
  printf "  \033[33mSKIP\033[0m: OpenTofu state file (iac/terraform.tfstate) — run: cd iac && tofu init && tofu apply\n"
fi

# 10. CI workflow file exists
check "GitHub Actions CI workflow file exists (.github/workflows/ci.yml)" \
  "$([ -f "$COMPOSE_DIR/.github/workflows/ci.yml" ] && echo pass || echo fail)"

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed. Advanced Capstone complete!\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
