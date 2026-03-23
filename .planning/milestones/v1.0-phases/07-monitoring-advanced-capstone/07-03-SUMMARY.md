---
phase: 07-monitoring-advanced-capstone
plan: "03"
subsystem: capstone
tags: [capstone, monitoring, prometheus, grafana, docker, iac, cicd, memory-leak]
dependency_graph:
  requires: ["07-01", "07-02"]
  provides: ["CAP-02"]
  affects: ["content/modules/08-monitoring"]
tech_stack:
  added: []
  patterns:
    - Silent memory leak via module-scope array accumulation (leakStore + setInterval)
    - prom-client 15.1.3 collectDefaultMetrics for nodejs_heap_used_bytes
    - OpenTofu kreuzwerker/docker v3.9.0 from registry.opentofu.org
    - GitHub Actions minimal CI (lint + build) with checkout@v6 + build-push-action@v7
    - Docker Compose mem_limit: 256m for predictable OOM threshold
key_files:
  created:
    - docker/advanced-capstone/app/app.js
    - docker/advanced-capstone/app/package.json
    - docker/advanced-capstone/app/Dockerfile
    - docker/advanced-capstone/prometheus/prometheus.yml
    - docker/advanced-capstone/prometheus/rules/alerts.yml
    - docker/advanced-capstone/grafana/provisioning/datasources/prometheus.yml
    - docker/advanced-capstone/alertmanager/alertmanager.yml
    - docker/advanced-capstone/iac/main.tf
    - docker/advanced-capstone/iac/variables.tf
    - docker/advanced-capstone/iac/outputs.tf
    - docker/advanced-capstone/.github/workflows/ci.yml
    - docker/advanced-capstone/compose.yml
    - docker/advanced-capstone/verify.sh
    - docker/advanced-capstone/README.md
  modified:
    - content/modules/08-monitoring/07-advanced-capstone.mdx
decisions:
  - "[07-monitoring-advanced-capstone P03]: verify.sh uses $COMPOSE_DIR relative path resolution so it works when called from any directory (not just project root)"
  - "[07-monitoring-advanced-capstone P03]: OpenTofu state file check in verify.sh is SKIP (not FAIL) — IaC step is optional per capstone brief"
  - "[07-monitoring-advanced-capstone P03]: main.tf references var.prometheus_port in both the ports block and prometheus_url output — consistent variable use"
metrics:
  duration: 5min
  completed_date: "2026-03-19"
  tasks_completed: 2
  files_created_or_modified: 15
---

# Phase 7 Plan 3: Advanced Capstone (CAP-02) Summary

**One-liner:** Silent memory leak via module-scope leakStore array diagnosed through nodejs_heap_used_bytes in a 4-service Prometheus/Grafana/Alertmanager Compose stack with OpenTofu IaC and GitHub Actions CI.

## What Was Built

### Task 1: Advanced Capstone Infrastructure

Created the complete `docker/advanced-capstone/` directory tree with all infrastructure files:

**App (`docker/advanced-capstone/app/`):**
- `app.js` — Express app with prom-client instrumentation (Counter, Histogram, Gauge, collectDefaultMetrics) plus the intentional memory leak: module-scope `leakStore` array, `simulateLeak()` pushing 100 objects every second via `setInterval(1000)`. Leak is completely silent — no console output.
- `package.json` — express ^4.21.0 + prom-client 15.1.3
- `Dockerfile` — multi-stage node:20-alpine build, non-root appuser, HEALTHCHECK via wget

**Monitoring configs:**
- `prometheus/prometheus.yml` — scrapes localhost:9090 (self) and app:3000 (capstone app), routes alerts to alertmanager:9093
- `prometheus/rules/alerts.yml` — 3 alert rules: AppDown (critical), HighMemoryUsage (warning, >200MB), HeapGrowthAnomaly (warning, heap rate >50KB/s for 3m)
- `grafana/provisioning/datasources/prometheus.yml` — auto-provisions Prometheus datasource, isDefault, httpMethod POST
- `alertmanager/alertmanager.yml` — webhook receiver posting to app:3000/alert-webhook

**Compose stack (`compose.yml`):**
- 4 services: app (mem_limit: 256m), prometheus:v3.10.0, grafana:12.4.1 (port 3001), alertmanager:v0.28.1
- capstone bridge network, named volumes for prometheus-data and grafana-data
- GF_AUTH_ANONYMOUS_ENABLED for passwordless local dev

**IaC (`iac/`):**
- `main.tf` — kreuzwerker/docker v3.9.0 from registry.opentofu.org, provisions docker_network + docker_image + docker_container for Prometheus with volume mounts
- `variables.tf` — prometheus_port variable with validation (1-65535)
- `outputs.tf` — prometheus_container_id and network_id outputs

**CI workflow (`.github/workflows/ci.yml`):**
- lint-and-test job: checkout@v6, setup-node@v4 (Node 20), npm ci, npm run lint, npm test
- build job (needs lint-and-test): setup-buildx-action@v4, build-push-action@v7 (push: false)

**`verify.sh`** — 10 checks: 4 service running checks (via `docker compose ps --format json`), Prometheus scrapes app (up==1), Grafana API healthy (database=ok), alert rules loaded (>=1), nodejs_heap_used_bytes exists, OpenTofu state file (SKIP if absent), CI workflow file exists. PASS/FAIL summary with color output.

**`README.md`** — Capstone brief with 10-step instructions, 3-tier hints in `<details>` blocks, Difficulty: Challenge marker.

### Task 2: Advanced Capstone MDX Lesson

Overwrote stub at `content/modules/08-monitoring/07-advanced-capstone.mdx` (17 lines) with full 213-line lesson:

- Frontmatter: difficulty Challenge, estimatedMinutes 90, tags including memory-leak and incident-response
- Overview with "Why This Matters" scenario (new DevOps engineer, users reporting slowness)
- Architecture diagram (ASCII) showing GitHub Actions -> Docker Build -> Compose stack with 4 services
- ExerciseCard (Challenge) with 13-step exercise brief covering: stack startup, Prometheus/Grafana verification, dashboard building, traffic generation, PromQL diagnosis, root cause identification, postmortem writing, optional IaC step
- VerificationChecklist with 6 items: services running, Prometheus targets, dashboard panels, PromQL memory leak query, root cause (leakStore), postmortem written
- Skills integration callout mapping all 8 modules to capstone touchpoints
- QuickReference table: module -> key skill -> where it appears in capstone
- Final congratulations callout

## Deviations from Plan

### Auto-fixed Issues

None. Plan executed exactly as written.

### Minor Implementation Notes

- `verify.sh` uses `$COMPOSE_DIR` (resolved from `${BASH_SOURCE[0]}`) rather than hardcoded `docker/advanced-capstone` path — makes it work when called from any directory
- `main.tf` outputs reuse `var.prometheus_port` instead of hardcoding 9090 in the prometheus_url output — consistent with variables.tf pattern
- OpenTofu state check in verify.sh is SKIP (not FAIL) per plan spec: "SKIP if not exists (optional IaC step)"

## Self-Check: PASSED

All 15 created/modified files confirmed present on disk.
Both task commits confirmed in git log:
- ddeba10: feat(07-03): build advanced capstone infrastructure
- f7abeaa: feat(07-03): write full advanced capstone MDX lesson
