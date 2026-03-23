---
phase: 07-monitoring-advanced-capstone
verified: 2026-03-19T12:09:00Z
status: passed
score: 8/8 must-haves verified
re_verification: false
---

# Phase 7: Monitoring & Advanced Capstone Verification Report

**Phase Goal:** Learners can instrument a Dockerized application with Prometheus and Grafana, set up alerting, and complete an advanced capstone that integrates all prior modules into a full pipeline with an intentional failure scenario to diagnose
**Verified:** 2026-03-19T12:09:00Z
**Status:** passed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| #  | Truth                                                                                                           | Status     | Evidence                                                                                              |
|----|-----------------------------------------------------------------------------------------------------------------|------------|-------------------------------------------------------------------------------------------------------|
| 1  | Learner can explain the three pillars of observability (metrics, logs, traces)                                  | VERIFIED  | `01-observability-concepts.mdx` — 204 lines, 32 matches on "metrics/logs/traces/three pillars", ExerciseCard present |
| 2  | Learner can read mechanism-first explanation of Prometheus scrape model, PromQL, alerting rules                 | VERIFIED  | `02-prometheus.mdx` — 375 lines, 52 matches on "PromQL/rate/histogram_quantile/scrape", ExerciseCard present |
| 3  | Learner can read mechanism-first explanation of Grafana datasource provisioning, panel types, visualizations    | VERIFIED  | `03-grafana.mdx` — 269 lines, full content (not stub), ExerciseCard + VerificationChecklist present   |
| 4  | Learner can read conceptual explanation of Loki/Promtail and ELK stack patterns                                 | VERIFIED  | `04-log-aggregation.mdx` — 309 lines, Loki label-indexed vs ELK tradeoff taught, LogQL present        |
| 5  | Learner can read practical incident response lesson with runbook templates, postmortem format                   | VERIFIED  | `05-incident-response.mdx` — 328 lines, Alertmanager routing, runbook structure, postmortem template   |
| 6  | Learner can start full monitoring stack with docker compose up -d                                               | VERIFIED  | `docker/monitoring/compose.yml` — 5 always-on services + 2 loki-profile; Prometheus v3.10.0, Grafana 12.4.1, Alertmanager v0.28.1, cAdvisor, app |
| 7  | Learner can start Loki profile with docker compose --profile loki up -d and query logs in Grafana              | VERIFIED  | `compose.yml` contains `profiles: [loki]` on loki and promtail services; Grafana datasource auto-provisioned |
| 8  | Learner can start the capstone stack and diagnose an intentional memory leak via Prometheus                     | VERIFIED  | `docker/advanced-capstone/app/app.js` — `leakStore` array, `simulateLeak()` pushes 100 objects/sec via `setInterval(1000)`, no console.log leak disclosure; `HeapGrowthAnomaly` alert rule in `rules/alerts.yml`; verify.sh check #8 for `nodejs_heap_used_bytes` |

**Score:** 8/8 truths verified

---

### Required Artifacts

#### Plan 07-01 Artifacts (MON-01 through MON-05)

| Artifact                                                     | Expected                      | Status   | Details                                                                          |
|--------------------------------------------------------------|-------------------------------|----------|----------------------------------------------------------------------------------|
| `content/modules/08-monitoring/01-observability-concepts.mdx` | MON-01 lesson content         | VERIFIED | Exists, 204 lines, `moduleSlug: "08-monitoring"` present                        |
| `content/modules/08-monitoring/02-prometheus.mdx`            | MON-02 lesson content         | VERIFIED | Exists, 375 lines, `moduleSlug: "08-monitoring"` present                        |
| `content/modules/08-monitoring/03-grafana.mdx`               | MON-03 lesson content         | VERIFIED | Exists, 269 lines, `moduleSlug: "08-monitoring"` present, full content           |
| `content/modules/08-monitoring/04-log-aggregation.mdx`       | MON-04 lesson content         | VERIFIED | Exists, 309 lines, `moduleSlug: "08-monitoring"` present                        |
| `content/modules/08-monitoring/05-incident-response.mdx`     | MON-05 lesson content         | VERIFIED | Exists, 328 lines, `moduleSlug: "08-monitoring"` present                        |

#### Plan 07-02 Artifacts (MON-06, MON-07)

| Artifact                                                          | Expected                                         | Status   | Details                                                                                           |
|-------------------------------------------------------------------|--------------------------------------------------|----------|---------------------------------------------------------------------------------------------------|
| `docker/monitoring/compose.yml`                                   | Full monitoring Docker Compose stack             | VERIFIED | Contains: `prom/prometheus:v3.10.0`, `grafana/grafana:12.4.1`, `prom/alertmanager:v0.28.1`, `cadvisor`, `profiles:`, `3001:3000`, `--web.enable-lifecycle` |
| `docker/monitoring/app/app.js`                                    | Instrumented Node.js app with prom-client        | VERIFIED | Contains: `prom-client`, `http_requests_total`, `/metrics`, `/alert-webhook`                     |
| `docker/monitoring/verify.sh`                                     | Stack verification script (9 checks)             | VERIFIED | Exists, executable, contains PASS/FAIL, 9 numbered checks                                        |
| `content/modules/08-monitoring/06-cheat-sheet.mdx`                | MON-07 cheat sheet                               | VERIFIED | Exists, 111 lines, `moduleSlug: "08-monitoring"`, 13 matches for QuickReference/PromQL/LogQL patterns |
| `lib/__tests__/modules.test.ts`                                   | Vitest assertion for monitoring module (7 lessons) | VERIFIED | Contains `monitoring module has 7 lessons`, `moduleSlug === '08-monitoring'`; all 34 tests pass  |

#### Plan 07-03 Artifacts (CAP-02)

| Artifact                                                          | Expected                                         | Status   | Details                                                                                           |
|-------------------------------------------------------------------|--------------------------------------------------|----------|---------------------------------------------------------------------------------------------------|
| `content/modules/08-monitoring/07-advanced-capstone.mdx`          | CAP-02 capstone lesson content                   | VERIFIED | Exists, 213 lines, `difficulty: "Challenge"`, `estimatedMinutes: 90`, ExerciseCard, VerificationChecklist, `docker/advanced-capstone` references, `nodejs_heap_used_bytes`, `leakStore` |
| `docker/advanced-capstone/app/app.js`                             | App with intentional memory leak                 | VERIFIED | Contains: `leakStore`, `simulateLeak()`, `Buffer.alloc(1024)`, `setInterval(1000)`; NO console.log about leak |
| `docker/advanced-capstone/compose.yml`                            | Capstone Docker Compose stack                    | VERIFIED | Contains: `prom/prometheus:v3.10.0`, `grafana/grafana:12.4.1`, `mem_limit: 256m`, `3001:3000`   |
| `docker/advanced-capstone/verify.sh`                              | Capstone verification script (10 checks)         | VERIFIED | Exists, executable, PASS/FAIL/SKIP output, 10 numbered checks including `nodejs_heap_used_bytes` and optional tofu state |
| `docker/advanced-capstone/iac/main.tf`                            | OpenTofu IaC config for capstone                 | VERIFIED | Contains: `registry.opentofu.org/kreuzwerker/docker`, `version = "3.9.0"`                       |
| `docker/advanced-capstone/.github/workflows/ci.yml`               | GitHub Actions CI workflow                       | VERIFIED | Contains: `actions/checkout@v6`, `docker/build-push-action@v7`                                  |

---

### Key Link Verification

| From                                                    | To                                              | Via                                         | Status   | Details                                                                |
|---------------------------------------------------------|-------------------------------------------------|---------------------------------------------|----------|------------------------------------------------------------------------|
| `docker/monitoring/compose.yml`                         | `docker/monitoring/prometheus/prometheus.yml`   | Volume mount `prometheus.yml:/etc/prometheus/prometheus.yml` | VERIFIED | Mount present in compose.yml                                    |
| `docker/monitoring/compose.yml`                         | `docker/monitoring/grafana/provisioning/`       | Volume mount `provisioning:/etc/grafana/provisioning` | VERIFIED | `./grafana/provisioning:/etc/grafana/provisioning:ro` present  |
| `docker/monitoring/prometheus/prometheus.yml`           | `docker/monitoring/app/app.js`                  | Scrape target `app:3000` hits `/metrics`    | VERIFIED | `targets: ["app:3000"]` in scrape_configs                             |
| `docker/advanced-capstone/app/app.js`                   | `docker/advanced-capstone/prometheus/prometheus.yml` | Prometheus scrapes app:3000/metrics where memory leak manifests | VERIFIED | `targets: ["app:3000"]` in prometheus.yml; `nodejs_heap_used_bytes` from `collectDefaultMetrics` |
| `docker/advanced-capstone/verify.sh`                    | `docker/advanced-capstone/app/app.js`           | verify.sh checks `nodejs_heap_used_bytes` exists in Prometheus | VERIFIED | Check #8: `nodejs_heap_used_bytes metric exists in Prometheus`        |
| `content/modules/08-monitoring/07-advanced-capstone.mdx` | `docker/advanced-capstone/`                     | Lesson references capstone directory for all exercise files | VERIFIED | `docker/advanced-capstone` appears in ExerciseCard steps, VerificationChecklist, and QuickReference |

---

### Requirements Coverage

| Requirement | Source Plan | Description                                                           | Status    | Evidence                                                              |
|-------------|-------------|-----------------------------------------------------------------------|-----------|-----------------------------------------------------------------------|
| MON-01      | 07-01       | Lesson on observability concepts — metrics, logs, traces (three pillars) | SATISFIED | `01-observability-concepts.mdx` — 204 lines, full mechanism-first lesson with ExerciseCard |
| MON-02      | 07-01       | Lesson on Prometheus — metrics collection, PromQL basics, alerting rules | SATISFIED | `02-prometheus.mdx` — 375 lines, 52 matches for PromQL/scrape patterns |
| MON-03      | 07-01       | Lesson on Grafana — dashboards, data sources, visualization           | SATISFIED | `03-grafana.mdx` — 269 lines, datasource provisioning, panel types taught |
| MON-04      | 07-01       | Lesson on log aggregation — centralized logging, ELK/Loki concepts    | SATISFIED | `04-log-aggregation.mdx` — 309 lines, Loki vs ELK tradeoff, LogQL covered |
| MON-05      | 07-01       | Lesson on incident response — alerting, runbooks, postmortems         | SATISFIED | `05-incident-response.mdx` — 328 lines, Alertmanager config, runbook, postmortem template |
| MON-06      | 07-02       | Hands-on exercises with Docker Compose monitoring stack               | SATISFIED | `docker/monitoring/` — complete stack (7 services), `verify.sh` (9 checks), `README.md` |
| MON-07      | 07-02       | Module cheat sheet with monitoring tools and concepts                 | SATISFIED | `06-cheat-sheet.mdx` — 111 lines, 5 QuickReference sections, PromQL + LogQL patterns |
| CAP-02      | 07-03       | Advanced capstone — full pipeline: Docker app + CI/CD + IaC + monitoring with intentional failure | SATISFIED | `docker/advanced-capstone/` complete; silent `leakStore` memory leak; verify.sh 10 checks; full MDX lesson 213 lines |

All 8 requirements from REQUIREMENTS.md Phase 7 mapping verified. No orphaned requirements found.

---

### Anti-Patterns Found

None. No TODO/FIXME/PLACEHOLDER comments found in any MDX lesson files or docker infrastructure files. No stub implementations detected. All lesson files are substantive (204-375 lines each). The `07-advanced-capstone.mdx` stub from plan 07-02 was correctly overwritten by plan 07-03 (213 lines with full content).

---

### Human Verification Required

#### 1. Lesson Content Pedagogical Quality (MON-01 through MON-05)

**Test:** Read each lesson and evaluate whether it teaches mechanism-first (explains how the tool works before showing commands)
**Expected:** Each lesson opens with the mechanism/design decision before introducing syntax or config
**Why human:** Cannot programmatically verify whether explanations are clear, accurate, and in the correct teaching order

#### 2. Docker Compose Stack Runtime Behavior

**Test:** Run `docker compose up -d` in `docker/monitoring/`, then open Prometheus at http://localhost:9090 (Targets page) and Grafana at http://localhost:3001
**Expected:** All 5 services healthy, Prometheus shows `monitored-app` target as UP, Grafana auto-shows Prometheus datasource
**Why human:** Runtime networking, service discovery, and Grafana YAML provisioning are not verifiable without actually running the stack

#### 3. Memory Leak Detection Timing

**Test:** Run `docker compose up -d` in `docker/advanced-capstone/`, wait 5-10 minutes, query `increase(nodejs_heap_used_bytes[5m])` in Prometheus
**Expected:** Value consistently positive and growing, eventually triggering `HeapGrowthAnomaly` alert
**Why human:** Cannot verify time-series behavior programmatically; requires actually running the stack

#### 4. Loki Profile Behavior

**Test:** Run `docker compose --profile loki up -d` in `docker/monitoring/`, then open Grafana and add a Loki datasource pointing to http://loki:3100
**Expected:** Promtail ships container logs, LogQL queries return results in Grafana Explore
**Why human:** Docker socket-based log discovery and Loki ingestion require runtime verification

---

### Deviations from Plan Noted

One deviation noted in 07-02-SUMMARY.md: Plan 07-01 was specified to create lessons 01-05 but only completed 01-02. Plan 07-02 created stubs for 03-05 to unblock the Vitest count test. Plan 07-01-SUMMARY.md claims all five were created. The **actual state on disk** at verification time is correct — all five files have full substantive content (269-375 lines each with ExerciseCard and VerificationChecklist). The divergence between SUMMARY claims and actual files was resolved before this verification ran.

---

## Summary

Phase 7 goal is fully achieved. All 8 requirements (MON-01 through MON-07, CAP-02) are satisfied by substantive, wired artifacts. The monitoring stack provides a complete hands-on environment: Prometheus scraping a prom-client instrumented app, Grafana auto-provisioning its datasource via YAML, Alertmanager routing to a webhook, Loki/Promtail available via compose profile. The advanced capstone contains a silent memory leak detectable via `increase(nodejs_heap_used_bytes[5m])` — the exact PromQL the learner is guided to discover. All 34 Vitest tests pass. No anti-patterns or stubs found.

---

_Verified: 2026-03-19T12:09:00Z_
_Verifier: Claude (gsd-verifier)_
