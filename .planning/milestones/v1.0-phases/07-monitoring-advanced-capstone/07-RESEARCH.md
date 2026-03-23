# Phase 7: Monitoring & Advanced Capstone - Research

**Researched:** 2026-03-19
**Domain:** Prometheus, Grafana, prom-client Node.js instrumentation, Loki log aggregation, Alertmanager, advanced capstone design
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Monitoring & Observability Approach**
- Docker Compose stack with Prometheus + Grafana + the progressive Node.js app — learner instruments, scrapes, and dashboards locally
- Log aggregation: conceptual (ELK/Loki patterns) with a simple Docker Compose Loki example — not full ELK deployment
- Real Prometheus alerting rules + Alertmanager config in YAML — learner writes rules that fire against the instrumented app
- Incident response: practical runbook patterns, postmortem templates, on-call basics — conceptual with real templates

**Advanced Capstone Design**
- Full pipeline: Dockerized app + CI/CD workflow + IaC (OpenTofu Docker provider) + Prometheus/Grafana monitoring + intentional failure scenario to diagnose
- Application-level failure: memory leak or cascading timeout that manifests in Prometheus metrics, requires Grafana dashboard + alerting to detect and diagnose
- Substantial starter code provided: base app, Docker infrastructure, monitoring configs — challenge is connecting everything and diagnosing the failure
- Difficulty: Challenge (highest tier) — course's final assessment

**Content Organization**
- Single module: 08-monitoring
- Difficulty: MON-01–02 Foundation, MON-03–05 Intermediate, Capstone: Challenge
- Module accent color: red/rose (matches "alerting" theme)

### Claude's Discretion
- Exact Prometheus scrape configuration and alert rules
- Grafana dashboard JSON/provisioning approach
- Specific failure scenario implementation details
- How to structure the capstone verification
- Loki example depth and configuration
- Postmortem and runbook template formats

### Deferred Ideas (OUT OF SCOPE)
- Distributed tracing (Jaeger/Zipkin) — v2
- Custom Prometheus exporters — v2
- SLO/SLA management tooling — v2
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| MON-01 | Lesson on observability concepts — metrics, logs, traces (three pillars) | Three pillars well-documented; bridge from Phase 5 SYS-06 (top/htop/vmstat) to Prometheus/Grafana; traces are conceptual-only (deferred per CONTEXT.md) |
| MON-02 | Lesson on Prometheus — metrics collection, PromQL basics, alerting rules | prom/prometheus:v3.10.0 current; prom-client 15.1.3 for Node.js instrumentation; PromQL patterns verified from prometheus.io/docs; alert rule YAML format verified from official docs |
| MON-03 | Lesson on Grafana — dashboards, data sources, visualization | grafana/grafana:12.4.1 current; provisioning via YAML datasource config is the correct approach for Docker Compose; provisioned datasources auto-load on startup |
| MON-04 | Lesson on log aggregation — centralized logging, ELK/Loki concepts | grafana/loki:3.6.0 and grafana/promtail:3.6.0 current; Docker Compose Loki example viable; Loki log driver for Docker containers sends logs directly without Promtail |
| MON-05 | Lesson on incident response — alerting, runbooks, postmortems | Alertmanager routing config YAML verified; postmortem template format is well-understood domain; practical runbook pattern includes symptom/action/escalation sections |
| MON-06 | Hands-on exercises with Docker Compose monitoring stack | 5-service stack (app + prometheus + grafana + alertmanager + loki) in docker/monitoring/; macOS: node-exporter does NOT work on macOS — use cAdvisor for container metrics instead |
| MON-07 | Module cheat sheet with monitoring tools and concepts | One QuickReference component per lesson topic (5 components for MON-01–05) follows established pattern; monitoring accentColor 'monitoring' already in validColors test |
| CAP-02 | Advanced capstone — full pipeline: Docker app + CI/CD + IaC + monitoring with intentional failure scenario | Memory leak via setInterval accumulating objects; visible in `nodejs_heap_used_bytes` metric climbing steadily; verify.sh checks Prometheus target health, Grafana API, Alertmanager rules, and leak symptom in metrics |
</phase_requirements>

---

## Summary

Phase 7 is a content-authoring phase with one new toolchain addition: the monitoring Docker Compose stack (`docker/monitoring/`). No new npm dependencies are required — the Next.js platform, MDX pipeline, and all content components are fully operational. The work is writing five MDX lessons for module `08-monitoring`, the monitoring Compose lab, the Loki mini-example, the cheat sheet, and the advanced capstone project.

The monitoring stack uses prom/prometheus:v3.10.0, grafana/grafana:12.4.1, and grafana/grafana-oss is deprecated as of 12.4.0 (use `grafana/grafana` directly). The progressive Node.js app at `docker/app/app.js` is instrumented with prom-client 15.1.3 to expose a `/metrics` endpoint — this is the scrape target Prometheus hits. Grafana is provisioned via YAML files mounted at container startup so the learner immediately sees a working datasource without manual UI configuration. Alertmanager is included for alerting rule demonstrations.

The advanced capstone (CAP-02) integrates all prior modules: the learner starts with a provided codebase, connects the CI/CD pipeline, provisions monitoring with OpenTofu, and then diagnoses an intentional memory leak that manifests as steadily rising `nodejs_heap_used_bytes`. The failure is subtle enough to require Prometheus + Grafana to detect but unambiguous once the right PromQL query is written. The verify.sh script checks all infrastructure components plus the metric symptom.

**Critical macOS pitfall:** `prom/node-exporter` does not work on macOS (it reads Linux `/proc` and `/sys` filesystems that don't exist on macOS). Use `gcr.io/cadvisor/cadvisor:latest` for container-level metrics instead of node-exporter in the monitoring lab. Document this clearly for learners.

**Primary recommendation:** Structure as three plans: (1) MON-01–05 MDX lessons, (2) monitoring Docker Compose stack + Loki mini-example + cheat sheet, (3) advanced capstone project with memory leak failure scenario.

---

## Standard Stack

### Core (no new npm dependencies — all tooling external to the Next.js app)

| Tool | Version | Purpose | Why This |
|------|---------|---------|----------|
| prom/prometheus | v3.10.0 | Time-series metrics collection and PromQL | Latest stable (Feb 24, 2026); v3.x has breaking changes vs v2 — use v3.x, it's current |
| grafana/grafana | 12.4.1 | Metrics visualization and dashboards | Latest stable (Mar 9, 2026); grafana/grafana-oss deprecated as of 12.4.0 — use grafana/grafana |
| prom/alertmanager | v0.28.1 | Alert routing and notification management | Standard Alertmanager image; works with Prometheus rule groups |
| grafana/loki | 3.6.0 | Log aggregation (Loki mini-example) | Official image; current stable per Grafana docs March 2026 |
| grafana/promtail | 3.6.0 | Log shipper to Loki | Matches Loki version; same image family |
| gcr.io/cadvisor/cadvisor | latest | Container-level metrics on macOS | Replacement for node-exporter on macOS; provides container CPU/memory/network metrics |
| prom-client (npm) | 15.1.3 | Prometheus client for Node.js instrumentation | Current stable; installs into the progressive app at docker/app/ |

### prom-client Installation (into the monitoring exercise app)
```bash
cd docker/monitoring/app
npm install prom-client@15.1.3
```

### Supporting Tools (pre-existing in project)
| Tool | Version | Purpose |
|------|---------|---------|
| Docker Desktop | existing | Required for Compose stack; provides /var/run/docker.sock |
| OpenTofu | 1.11.5 | Capstone IaC integration (Phase 6 tool, reused) |
| Vitest | 4.1.0 | Module count assertions — needs new assertion for `08-monitoring` |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| prom/prometheus:v3.10.0 | v2.53.5 (LTS) | v2.x is in maintenance; v3.x is current development; teach v3.x since it's what learners will encounter in 2026+ |
| gcr.io/cadvisor/cadvisor | prom/node-exporter | node-exporter reads Linux /proc and /sys — does not work on macOS; cAdvisor works cross-platform via Docker API |
| grafana/grafana | grafana/grafana-oss | grafana-oss repo deprecated as of Grafana 12.4.0 — use grafana/grafana |
| Loki + Promtail | ELK stack (Elasticsearch + Logstash + Kibana) | ELK requires 3+ GB RAM; Loki is lightweight; CONTEXT.md locks Loki for the lab example |
| GF_AUTH_ANONYMOUS_ENABLED=true | Password auth | Anonymous access removes the login barrier for local learner labs — standard practice in Docker dev setups |

---

## Architecture Patterns

### Module Directory Structure

```
content/modules/
├── 08-monitoring/
│   ├── 01-observability-concepts.mdx     # MON-01 — Foundation
│   ├── 02-prometheus.mdx                  # MON-02 — Foundation
│   ├── 03-grafana.mdx                     # MON-03 — Intermediate
│   ├── 04-log-aggregation.mdx             # MON-04 — Intermediate
│   ├── 05-incident-response.mdx           # MON-05 — Intermediate
│   ├── 06-cheat-sheet.mdx                 # MON-07
│   └── 07-advanced-capstone.mdx           # CAP-02
docker/
├── monitoring/
│   ├── app/
│   │   ├── app.js                          # Instrumented Node.js app (prom-client)
│   │   ├── package.json
│   │   └── Dockerfile
│   ├── prometheus/
│   │   ├── prometheus.yml                  # Scrape config + alertmanager target
│   │   └── rules/
│   │       └── alerts.yml                  # Alert rules (MON-02 exercise)
│   ├── alertmanager/
│   │   └── alertmanager.yml                # Routing + receiver config
│   ├── grafana/
│   │   └── provisioning/
│   │       ├── datasources/
│   │       │   └── prometheus.yml          # Auto-provisions Prometheus datasource
│   │       └── dashboards/
│   │           └── dashboards.yml          # Dashboard provider config
│   ├── loki/
│   │   └── loki-config.yml                 # Simple local Loki config
│   ├── promtail/
│   │   └── promtail-config.yml             # Promtail config pointing to Loki
│   ├── compose.yml                          # Full monitoring stack
│   └── verify.sh                           # Verifies stack and PromQL exercise
├── advanced-capstone/
│   ├── app/
│   │   ├── app.js                          # App with intentional memory leak
│   │   ├── package.json
│   │   └── Dockerfile
│   ├── prometheus/
│   │   ├── prometheus.yml
│   │   └── rules/
│   │       └── alerts.yml
│   ├── grafana/
│   │   └── provisioning/
│   │       └── datasources/
│   │           └── prometheus.yml
│   ├── iac/
│   │   ├── main.tf                         # OpenTofu provisions monitoring stack
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── .github/
│   │   └── workflows/
│   │       └── ci.yml                      # CI/CD pipeline (GitHub Actions)
│   ├── compose.yml                          # Full capstone stack
│   ├── verify.sh                           # Capstone verification (all checks)
│   └── README.md                           # Capstone brief with failure scenario
```

### Pattern 1: MDX Frontmatter for Monitoring Lessons
```mdx
---
title: "Prometheus: How Metrics Collection Actually Works"
description: "From counters and gauges to PromQL queries — how Prometheus scrapes, stores, and queries time-series metrics"
module: "Monitoring & Observability"
moduleSlug: "08-monitoring"
lessonSlug: "02-prometheus"
order: 2
difficulty: "Foundation"
estimatedMinutes: 30
prerequisites: ["08-monitoring/01-observability-concepts"]
tags: ["prometheus", "promql", "metrics", "counter", "gauge", "histogram", "alerting"]
---
```

### Pattern 2: Instrumented Node.js App (prom-client)
```javascript
// docker/monitoring/app/app.js
const express = require('express')
const client = require('prom-client')

const app = express()
const PORT = process.env.PORT || 3000

// Enable default metrics (process CPU, memory, event loop lag, etc.)
const register = new client.Registry()
client.collectDefaultMetrics({ register })

// Custom counter: total HTTP requests by method and route
const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
  registers: [register],
})

// Custom histogram: request duration
const httpRequestDurationSeconds = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route'],
  buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
  registers: [register],
})

// Custom gauge: active connections
const activeConnections = new client.Gauge({
  name: 'active_connections',
  help: 'Number of active connections',
  registers: [register],
})

// Middleware to record request metrics
app.use((req, res, next) => {
  const end = httpRequestDurationSeconds.startTimer({ method: req.method, route: req.path })
  activeConnections.inc()
  res.on('finish', () => {
    httpRequestsTotal.labels(req.method, req.path, res.statusCode).inc()
    end()
    activeConnections.dec()
  })
  next()
})

// Metrics endpoint — Prometheus scrapes this
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType)
  res.end(await register.metrics())
})

app.get('/', (req, res) => {
  res.json({ message: 'Monitored app', version: '1.0.0' })
})

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', uptime: process.uptime() })
})

app.listen(PORT, () => console.log(`Server on port ${PORT}, metrics at /metrics`))
```

### Pattern 3: Prometheus Configuration
```yaml
# docker/monitoring/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager:9093

rule_files:
  - "rules/*.yml"

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "monitored-app"
    static_configs:
      - targets: ["app:3000"]

  - job_name: "cadvisor"
    static_configs:
      - targets: ["cadvisor:8080"]
```

### Pattern 4: Prometheus Alert Rules
```yaml
# docker/monitoring/prometheus/rules/alerts.yml
# Source: prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
groups:
  - name: app-alerts
    rules:
      - alert: AppDown
        expr: up{job="monitored-app"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "App {{ $labels.instance }} is down"
          description: "{{ $labels.instance }} has been unreachable for more than 1 minute"

      - alert: HighRequestLatency
        expr: histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, route)) > 0.5
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "High latency on {{ $labels.route }}"
          description: "P95 latency is {{ $value | humanizeDuration }} on route {{ $labels.route }}"

      - alert: HighErrorRate
        expr: rate(http_requests_total{status_code=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value | humanizePercentage }} over last 5 minutes"
```

### Pattern 5: Alertmanager Configuration
```yaml
# docker/monitoring/alertmanager/alertmanager.yml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname', 'severity']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'webhook-log'

receivers:
  - name: 'webhook-log'
    webhook_configs:
      - url: 'http://app:3000/alert-webhook'
        send_resolved: true
```

**Note:** For learning purposes, webhook receiver pointing to the app itself creates a visible notification path without requiring Slack/PagerDuty credentials. The app can log the received alert body.

### Pattern 6: Grafana Datasource Provisioning
```yaml
# docker/monitoring/grafana/provisioning/datasources/prometheus.yml
# Source: grafana.com/docs/grafana/latest/administration/provisioning/
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
    jsonData:
      httpMethod: POST
    version: 1
```

### Pattern 7: Monitoring Docker Compose Stack
```yaml
# docker/monitoring/compose.yml
services:
  app:
    build: ./app
    ports:
      - "3000:3000"
    networks:
      - monitoring

  prometheus:
    image: prom/prometheus:v3.10.0
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - ./prometheus/rules:/etc/prometheus/rules:ro
      - prometheus-data:/prometheus
    command:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.path=/prometheus"
      - "--web.enable-lifecycle"
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:12.4.1
    ports:
      - "3001:3000"
    environment:
      - GF_AUTH_ANONYMOUS_ENABLED=true
      - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
      - GF_AUTH_DISABLE_LOGIN_FORM=true
    volumes:
      - ./grafana/provisioning:/etc/grafana/provisioning:ro
      - grafana-data:/var/lib/grafana
    networks:
      - monitoring

  alertmanager:
    image: prom/alertmanager:v0.28.1
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml:ro
    networks:
      - monitoring

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    networks:
      - monitoring

networks:
  monitoring:
    driver: bridge

volumes:
  prometheus-data:
  grafana-data:
```

### Pattern 8: Memory Leak Implementation (Capstone Failure Scenario)
```javascript
// docker/advanced-capstone/app/app.js — intentional leak for diagnosis exercise
// The leak: a setInterval accumulates objects in a module-scope array
// Visible as steadily rising process_resident_memory_bytes and nodejs_heap_used_bytes
// Does NOT crash immediately — takes ~10-15 minutes to become noticeable in metrics

const leakStore = []  // Module-scope — never garbage collected

function simulateLeak() {
  // Accumulate 100KB per second — visible in Prometheus within a few minutes
  for (let i = 0; i < 100; i++) {
    leakStore.push({
      id: Math.random(),
      data: Buffer.alloc(1024).toString('hex'),  // 2KB per entry
      timestamp: new Date().toISOString(),
    })
  }
}

// Start leaking silently — no logs, no errors
setInterval(simulateLeak, 1000)
```

**Diagnostic PromQL query the learner must find:**
```promql
# Heap growing without bound
increase(nodejs_heap_used_bytes[5m])

# Or: rate of growth
rate(nodejs_heap_used_bytes[5m])
```

### Anti-Patterns to Avoid

- **Using `prom/node-exporter` on macOS:** node-exporter reads Linux `/proc` and `/sys` filesystems. It produces no useful metrics on macOS and may fail to start. Use `gcr.io/cadvisor/cadvisor` for container-level metrics in the monitoring lab.
- **Using `grafana/grafana-oss` image:** Deprecated as of Grafana 12.4.0. Docker Hub page will no longer be updated. Use `grafana/grafana` directly.
- **Hardcoding Prometheus target as `localhost:9090` in Grafana datasource:** Inside the Docker network, Grafana must reach Prometheus by service name `prometheus:9090`, not `localhost`.
- **Teaching `up` metric without explaining scrape semantics:** `up{job="monitored-app"} == 1` only means Prometheus successfully scraped the `/metrics` endpoint in the last scrape interval — the app could still be returning errors. Teach the distinction.
- **Skipping `--web.enable-lifecycle` flag in Prometheus command:** This flag enables the `/-/reload` endpoint, which lets the learner reload config without restarting the container. Essential for the alerting rules exercise.
- **Using `latest` tag for Prometheus or Grafana:** Version drift between lab sessions causes inconsistent experiences. Pin all image versions.
- **Capstone memory leak too aggressive:** A leak that OOM-kills the container in 2 minutes doesn't give learners time to write PromQL queries. Scale leak rate to require 10+ minutes of runtime to become diagnose-worthy.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Metrics collection from Node.js | Custom /metrics endpoint with string formatting | prom-client 15.1.3 | prom-client handles Prometheus text format spec, OpenMetrics format, default process metrics, registry management, counter resets on process restart |
| Alerting state management | Custom threshold checking in app code | Prometheus alert rules + Alertmanager | Prometheus handles `for` duration (pending → firing state), deduplication, grouping, silence windows, inhibition rules — hand-rolling misses all of these |
| Grafana datasource config | Manual UI configuration tutorial | YAML provisioning files | Provisioned datasources load automatically at container startup — learner sees working Grafana immediately; manual config is fragile (UI changes between versions) |
| Log collection | Custom log shipping script | Promtail + Loki | Promtail handles log tailing, label injection, backpressure, retries; Loki handles retention, LogQL queries — hand-rolling log collection is a production antipattern |
| Dashboard JSON | Building from scratch in lesson | Provide starter JSON in provisioning/ | Grafana dashboard JSON is 100–500 lines; spend lesson time on PromQL and panel configuration concepts, not JSON structure |

**Key insight:** The monitoring stack value is in the query language and observability culture, not the YAML configuration. Exercises should spend maximum time on PromQL, alert rule logic, and incident response — not debugging YAML indentation.

---

## Common Pitfalls

### Pitfall 1: node-exporter Does Not Work on macOS
**What goes wrong:** Learner adds `prom/node-exporter` to Compose stack; it either fails to start or produces no useful metrics on macOS
**Why it happens:** node-exporter reads `/proc/stat`, `/proc/meminfo`, `/sys/block/` etc. — Linux kernel interfaces not present on macOS
**How to avoid:** Use `gcr.io/cadvisor/cadvisor` for container-level metrics. Document this in MON-02 lesson with a `<Callout type="warning">` explaining why. cAdvisor uses Docker API (socket mount), not OS filesystem, and works on macOS.
**Warning signs:** `docker logs monitoring-node-exporter` shows "open /proc/stat: no such file or directory"

### Pitfall 2: Port Conflicts in Monitoring Stack
**What goes wrong:** Grafana defaults to port 3000, which conflicts with the monitored Node.js app also on port 3000
**Why it happens:** Both use their respective default ports; Docker Compose publishes both to host
**How to avoid:** Map Grafana host port to 3001 (`"3001:3000"`) so app stays at 3000 and Grafana is at 3001. Document the port map clearly in the lesson.
**Warning signs:** `docker compose up` exits with "bind: address already in use" on port 3000

### Pitfall 3: Prometheus Config Changes Don't Auto-Reload
**What goes wrong:** Learner edits `prometheus.yml` or adds a new rules file; changes don't take effect
**Why it happens:** Prometheus only reloads config on SIGHUP or HTTP POST to `/-/reload` — it does NOT watch for file changes
**How to avoid:** Include `--web.enable-lifecycle` in Prometheus container command. Document the reload workflow: `curl -X POST http://localhost:9090/-/reload` after editing config.
**Warning signs:** Learner edits alert rules but no new alerts appear in Prometheus UI

### Pitfall 4: Grafana Anonymous Access Required for Local Dev
**What goes wrong:** Learner opens Grafana at localhost:3001 and sees a login form with no credentials documented
**Why it happens:** Default Grafana requires login; no password was set in Compose environment vars
**How to avoid:** Set `GF_AUTH_ANONYMOUS_ENABLED=true` and `GF_AUTH_ANONYMOUS_ORG_ROLE=Admin` in Grafana environment. Document this is a dev-only setting — never production.
**Warning signs:** "Please sign in" page with no hint about credentials

### Pitfall 5: Vitest Module Count Assertion Missing for 08-monitoring
**What goes wrong:** `lib/__tests__/modules.test.ts` has no assertion for the `08-monitoring` lesson count. All tests pass even if wrong number of MDX files are created.
**Why it happens:** Same pattern as Phases 5–6 — new modules need explicit count assertions added.
**How to avoid:** After writing MDX files, add to modules.test.ts:
- `'monitoring module has 7 lessons'` (01–05 lessons + 06 cheat-sheet + 07 advanced-capstone)
**Warning signs:** All tests pass but a missing or miscounted MDX file would go undetected.

### Pitfall 6: Capstone Memory Leak Too Fast (OOM Before Diagnosis)
**What goes wrong:** Memory leak accumulates too fast, container OOM-killed before learner can write PromQL queries and build a dashboard
**Why it happens:** Aggressive leak rate (e.g., 10MB/second) exceeds Docker's default memory limit quickly
**How to avoid:** Calibrate leak rate to 200–400KB/second — visible in Prometheus metrics within 2–3 minutes but stable for 20+ minutes. Set `mem_limit: 256m` on the capstone app container to make OOM threshold predictable and documentable. Learner should be able to complete the exercise before OOM.
**Warning signs:** `docker compose ps` shows app container as "exited (137)" — OOM killed

### Pitfall 7: cAdvisor Privileged Mounts on macOS Docker Desktop
**What goes wrong:** cAdvisor mounts `/var/lib/docker/` which may be empty or inaccessible in Docker Desktop VM on macOS
**Why it happens:** Docker Desktop runs a Linux VM; container filesystems are inside the VM, not at the macOS path `/var/lib/docker/`
**How to avoid:** cAdvisor still provides useful container CPU/memory metrics via the Docker socket mount (`/var/run/docker.sock`). The `/var/lib/docker/` mount may show "0 bytes" for disk — document this as expected on macOS in a `<Callout type="tip">`. The exercise still works for the metrics that matter.
**Warning signs:** cAdvisor starts but `container_fs_usage_bytes` always shows 0 on macOS

---

## Code Examples

Verified patterns from official sources:

### Essential PromQL Patterns (MON-02 Lesson)
```promql
# Source: prometheus.io/docs/prometheus/latest/querying/

# 1. Instant vector — current value of all time series matching a metric
http_requests_total

# 2. Filtering with label matchers
http_requests_total{job="monitored-app", status_code="200"}

# 3. Rate of increase over 5m window (use with counters, not gauges)
rate(http_requests_total[5m])

# 4. Aggregate across all instances, keeping route label
sum(rate(http_requests_total[5m])) by (route)

# 5. P95 request latency (canonical histogram_quantile pattern)
histogram_quantile(0.95,
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le, route)
)

# 6. Is the app up?
up{job="monitored-app"}

# 7. Memory usage
process_resident_memory_bytes{job="monitored-app"}

# 8. Heap growth (key query for capstone memory leak diagnosis)
increase(nodejs_heap_used_bytes[5m])
```

### Loki Mini-Example Config (MON-04 Lesson)
```yaml
# docker/monitoring/compose.yml additions for Loki
  loki:
    image: grafana/loki:3.6.0
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/loki-config.yml
    volumes:
      - ./loki/loki-config.yml:/etc/loki/loki-config.yml:ro
    networks:
      - monitoring

  promtail:
    image: grafana/promtail:3.6.0
    volumes:
      - /var/log:/var/log:ro
      - /var/run/docker.sock:/var/run/docker.sock
      - ./promtail/promtail-config.yml:/etc/promtail/promtail-config.yml:ro
    command: -config.file=/etc/promtail/promtail-config.yml
    networks:
      - monitoring
```

```yaml
# docker/monitoring/loki/loki-config.yml
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1

schema_config:
  configs:
    - from: 2024-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

storage_config:
  tsdb_shipper:
    active_index_directory: /loki/tsdb-index
    cache_location: /loki/tsdb-cache
  filesystem:
    directory: /loki/chunks

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h
```

### Grafana Dashboard Provider Config
```yaml
# docker/monitoring/grafana/provisioning/dashboards/dashboards.yml
apiVersion: 1

providers:
  - name: default
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    options:
      path: /etc/grafana/provisioning/dashboards
      foldersFromFilesStructure: true
```

### Capstone verify.sh Structure
```bash
#!/usr/bin/env bash
# docker/advanced-capstone/verify.sh
set -euo pipefail
PASS=0; FAIL=0
COMPOSE_FILE="docker/advanced-capstone/compose.yml"

check() {
  local desc="$1" result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"; PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"; FAIL=$((FAIL + 1))
  fi
}

echo "=== Advanced Capstone Verification ==="

# 1. App service running
# 2. Prometheus service running
# 3. Grafana service running
# 4. Alertmanager service running
# 5. Prometheus can reach app /metrics target (up == 1)
PROM_UP=$(curl -sf "http://localhost:9090/api/v1/query?query=up{job='app'}" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); v=d['data']['result']; print(v[0]['value'][1] if v else '0')" 2>/dev/null || echo "0")
check "Prometheus scrapes app /metrics (up==1)" "$([ "$PROM_UP" = "1" ] && echo pass || echo fail)"

# 6. Grafana API accessible
GRAFANA_STATUS=$(curl -sf "http://localhost:3001/api/health" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('database','unknown'))" 2>/dev/null || echo "fail")
check "Grafana API healthy (database=ok)" "$([ "$GRAFANA_STATUS" = "ok" ] && echo pass || echo fail)"

# 7. Alert rules loaded in Prometheus
RULES_COUNT=$(curl -sf "http://localhost:9090/api/v1/rules" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); groups=d['data']['groups']; print(sum(len(g['rules']) for g in groups))" 2>/dev/null || echo "0")
check "At least 1 alert rule loaded in Prometheus" "$([ "$RULES_COUNT" -ge 1 ] && echo pass || echo fail)"

# 8. Memory leak is detectable — heap_used_bytes metric exists
HEAP_EXISTS=$(curl -sf "http://localhost:9090/api/v1/query?query=nodejs_heap_used_bytes" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print('yes' if d['data']['result'] else 'no')" 2>/dev/null || echo "no")
check "nodejs_heap_used_bytes metric exists in Prometheus" "$([ "$HEAP_EXISTS" = "yes" ] && echo pass || echo fail)"

# 9. OpenTofu state file exists
check "OpenTofu state file (advanced-capstone/iac/terraform.tfstate) exists" \
  "$([ -f docker/advanced-capstone/iac/terraform.tfstate ] && echo pass || echo fail)"

# 10. CI workflow file exists
check "GitHub Actions CI workflow file exists (.github/workflows/ci.yml)" \
  "$([ -f docker/advanced-capstone/.github/workflows/ci.yml ] && echo pass || echo fail)"

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed. Advanced Capstone complete!\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"; exit 1
fi
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Prometheus v2.x | Prometheus v3.x (v3.10.0 current) | v3.0 released Nov 2024 | v3 has breaking changes vs v2: new OTLP ingestion, UTF-8 metric names, deprecated staleness handling — teach v3 since it's current |
| `grafana/grafana-oss` Docker image | `grafana/grafana` Docker image | Grafana 12.4.0 (Mar 2026) | `grafana-oss` Docker Hub repo no longer updated as of v12.4.0; use `grafana/grafana` |
| Grafana 9.x anonymous access | Grafana 12.x anonymous access (`GF_AUTH_ANONYMOUS_ENABLED=true`) | Still same env var pattern | Pattern unchanged; still the correct approach for local dev stacks |
| Promtail for log collection | Grafana Alloy (new collector) | Alloy released 2024 as Promtail replacement | Promtail still works and is simpler to teach; Alloy is the future direction but adds complexity; use Promtail for Phase 7 learning lab per CONTEXT.md decision |
| `prom-client` v14.x | `prom-client` v15.x (15.1.3 current) | 2024 | v15 added OpenMetrics support; default metrics and metric types are unchanged; no breaking changes for basic usage |

**Deprecated/outdated:**
- `prom/node-exporter` on macOS: Does not work. Use cAdvisor.
- `docker_container_memory_usage_bytes` (old cAdvisor metric): Renamed to `container_memory_usage_bytes` in recent cAdvisor versions. Use `container_memory_usage_bytes`.
- ELK stack for local learning labs: Resource-heavy (Elasticsearch requires 2+ GB heap). Loki is the lightweight, Grafana-native alternative for teaching log aggregation concepts.

---

## Open Questions

1. **Alertmanager version — prom/alertmanager:v0.28.1**
   - What we know: v0.28.1 was listed in search results as recent; the Alertmanager repo follows Prometheus releases but with different versioning
   - What's unclear: Whether v0.28.x is the current stable or if a newer version exists as of March 2026
   - Recommendation: Use `prom/alertmanager:v0.28.1` — if version is slightly stale, the alerting YAML format has been stable for years. Planner should verify at `github.com/prometheus/alertmanager/releases` during task execution.

2. **cAdvisor image tag — `gcr.io/cadvisor/cadvisor:latest`**
   - What we know: cAdvisor uses `latest` tag in most documentation; specific version tags exist but aren't widely documented
   - What's unclear: Whether a specific version should be pinned for reproducibility
   - Recommendation: Use `latest` for the learning lab (simplicity > reproducibility for this tool); document the tag choice with a note. If a specific tag is desired, check `github.com/google/cadvisor/releases`.

3. **Capstone CI workflow — reuse Phase 5 pattern or write minimal new workflow**
   - What we know: Phase 5 CI/CD covers GitHub Actions with build/test/push workflow using `checkout@v6`, `setup-buildx@v4`, `login-action@v4`, `build-push-action@v7`
   - What's unclear: Should the capstone CI workflow be a full build+test+push pipeline or a minimal lint+test workflow to keep capstone scope on monitoring/diagnosis
   - Recommendation: Minimal CI workflow (lint + build) — the capstone challenge is the monitoring/diagnosis, not the CI/CD pipeline. Learner connects existing knowledge; the pipeline itself is straightforward boilerplate from Phase 5.

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.0 |
| Config file | vitest.config.ts |
| Quick run command | `npx vitest run` |
| Full suite command | `npx vitest run --reporter=verbose` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| MON-01 | MDX frontmatter parses without error for 08-monitoring lessons | unit | `npx vitest run lib/__tests__/mdx.test.ts` | ✅ |
| MON-02 | 08-monitoring module has 7 lessons in filesystem scan | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ (needs count assertion) |
| MON-07 | accentColor 'monitoring' is valid in module registry | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ already in validColors |
| MON-06 | verify.sh exits 0 after compose stack is running and PromQL exercises completed | manual-only | `bash docker/monitoring/verify.sh` | ❌ Wave 0 |
| CAP-02 | Capstone verify.sh exits 0 after full pipeline + failure diagnosis | manual-only | `bash docker/advanced-capstone/verify.sh` | ❌ Wave 0 |

**Manual-only justification:** Monitoring verify scripts require a running Docker Compose stack (Prometheus, Grafana, app) and cannot be automated in Vitest.

### Sampling Rate
- **Per task commit:** `npx vitest run`
- **Per wave merge:** `npx vitest run --reporter=verbose`
- **Phase gate:** Full suite green before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `lib/__tests__/modules.test.ts` — add `'monitoring module has 7 lessons'` assertion (01–05 lessons + 06 cheat-sheet + 07 advanced-capstone)
- [ ] `docker/monitoring/verify.sh` — verifies monitoring stack running, app metrics scraped, alert rules loaded
- [ ] `docker/advanced-capstone/verify.sh` — verifies all capstone components (app, prometheus, grafana, alertmanager, IaC state, CI config, heap metric)

---

## Sources

### Primary (HIGH confidence)
- [github.com/prometheus/prometheus/releases](https://github.com/prometheus/prometheus/releases) — v3.10.0 confirmed latest stable (Feb 24, 2026)
- [github.com/grafana/grafana/releases](https://github.com/grafana/grafana/releases) — v12.4.1 confirmed latest stable (Mar 9, 2026)
- [prometheus.io/docs/prometheus/latest/configuration/alerting_rules/](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) — alerting rule YAML format, template variables, keep_firing_for field
- [grafana.com/docs/grafana/latest/administration/provisioning/](https://grafana.com/docs/grafana/latest/administration/provisioning/) — datasource and dashboard provisioning YAML format
- [grafana.com/docs/loki/latest/setup/install/docker/](https://grafana.com/docs/loki/latest/setup/install/docker/) — Loki 3.6.0, Promtail 3.6.0 confirmed current versions
- Project codebase: `content/modules/index.ts` — confirmed `08-monitoring` slug, `monitoring` accentColor registered
- Project codebase: `app/globals.css` line 39 — confirmed `--color-module-monitoring: oklch(0.65 0.15 350)` CSS variable exists
- Project codebase: `lib/__tests__/modules.test.ts` — confirmed `validColors` already includes `'monitoring'`; `'returns modules in correct order'` already expects `modules[7].slug === '08-monitoring'`
- npm registry: `prom-client@15.1.3` verified current via `npm view prom-client version`

### Secondary (MEDIUM confidence)
- [betterstack.com/community/guides/scaling-nodejs/nodejs-prometheus/](https://betterstack.com/community/guides/scaling-nodejs/nodejs-prometheus/) — prom-client Counter/Gauge/Histogram/startTimer patterns; cross-referenced with prom-client npm README
- [hub.docker.com/r/prom/prometheus](https://hub.docker.com/r/prom/prometheus) — Prometheus v3 now current; WebSearch confirms v3.10.0 is on `latest` tag
- WebSearch: macOS node-exporter incompatibility — multiple sources agree (reads Linux /proc/sys), cAdvisor recommended as alternative

### Tertiary (LOW confidence, flagged)
- prom/alertmanager v0.28.1 — referenced in WebSearch results but not directly verified against GitHub releases; planner should verify during task execution
- cAdvisor `latest` tag — widely used in community examples but specific version not pinned or verified; acceptable for learning lab

---

## Metadata

**Confidence breakdown:**
- Standard stack (prom-client 15.1.3, Prometheus v3.10.0, Grafana 12.4.1, Loki 3.6.0): HIGH — directly verified from GitHub releases and npm registry March 2026
- Architecture (MDX file naming, verify.sh pattern, provisioning structure): HIGH — directly inspected from existing phases 2–6
- PromQL patterns and alert rule format: HIGH — verified from prometheus.io official docs
- Grafana provisioning YAML: HIGH — verified from grafana.com official docs
- macOS node-exporter pitfall: HIGH — multiple independent sources agree
- Alertmanager version (v0.28.1): MEDIUM — from WebSearch, not directly verified from GitHub releases
- cAdvisor version pinning: LOW — using `latest` tag based on community practice; no specific version verified

**Research date:** 2026-03-19
**Valid until:** 2026-04-19 (Grafana and Prometheus release frequently; pin all image versions in exercise files to prevent drift)
