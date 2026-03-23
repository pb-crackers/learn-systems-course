# Phase 7: Monitoring & Advanced Capstone - Context

**Gathered:** 2026-03-19
**Status:** Ready for planning

<domain>
## Phase Boundary

Write all Monitoring & Observability lessons (MON-01 through MON-05), build monitoring Docker Compose lab environments (MON-06), create the monitoring cheat sheet (MON-07), and build the Advanced Capstone project (CAP-02). This is the final content phase — the capstone integrates all prior modules into one comprehensive project.

</domain>

<decisions>
## Implementation Decisions

### Monitoring & Observability Approach
- Docker Compose stack with Prometheus + Grafana + the progressive Node.js app — learner instruments, scrapes, and dashboards locally
- Log aggregation: conceptual (ELK/Loki patterns) with a simple Docker Compose Loki example — not full ELK deployment
- Real Prometheus alerting rules + Alertmanager config in YAML — learner writes rules that fire against the instrumented app
- Incident response: practical runbook patterns, postmortem templates, on-call basics — conceptual with real templates

### Advanced Capstone Design
- Full pipeline: Dockerized app + CI/CD workflow + IaC (OpenTofu Docker provider) + Prometheus/Grafana monitoring + intentional failure scenario to diagnose
- Application-level failure: memory leak or cascading timeout that manifests in Prometheus metrics, requires Grafana dashboard + alerting to detect and diagnose
- Substantial starter code provided: base app, Docker infrastructure, monitoring configs — challenge is connecting everything and diagnosing the failure
- Difficulty: Challenge (highest tier) — course's final assessment

### Content Organization
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

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- All content components, MDX pipeline, progress tracking, search
- Progressive Node.js app at docker/app/ — reused as the instrumented application
- Phase 3-5 Docker Compose patterns for multi-service labs
- Capstone pattern from Phase 4 (open-ended brief, verify.sh, starter code)

### Integration Points
- New MDX files in content/modules/08-monitoring/
- Module index needs monitoring entry
- Monitoring Compose stack in docker/monitoring/ directory
- Advanced capstone in docker/advanced-capstone/ directory
- Capstone verify.sh must check Prometheus, Grafana, alerting, and failure diagnosis

</code_context>

<specifics>
## Specific Ideas

- Monitoring lessons bridge from Phase 5's system monitoring (top/htop/vmstat) to Prometheus/Grafana
- Advanced Capstone is the course finale — must feel like a real-world ops challenge
- Intentional failure should be subtle enough to require actual monitoring to detect
- This is where everything comes together: Linux + networking + Docker + CI/CD + IaC + monitoring

</specifics>

<deferred>
## Deferred Ideas

- Distributed tracing (Jaeger/Zipkin) — v2
- Custom Prometheus exporters — v2
- SLO/SLA management tooling — v2

</deferred>

---

*Phase: 07-monitoring-advanced-capstone*
*Context gathered: 2026-03-19*
