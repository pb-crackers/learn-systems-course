# Advanced Capstone: Full-Stack Monitoring Pipeline

## The Challenge

You are the new DevOps engineer at a startup. They have a Node.js API that is
"working fine" — but users have been reporting occasional slowness that nobody
can reproduce. Your job:

1. **Connect the monitoring pipeline** — the app, Prometheus, Grafana, and
   Alertmanager are provided but need to be running together
2. **Build a Grafana dashboard** — show the four golden signals (latency,
   traffic, errors, saturation)
3. **Diagnose the failure** — there is an intentional problem in the app that
   manifests in the metrics. Find it using PromQL and your dashboard.
4. **Document the incident** — write a postmortem following the template from
   the Incident Response lesson

## What You Have

- `app/` — Node.js API instrumented with prom-client
- `prometheus/` — Prometheus config with scrape targets and alert rules
- `grafana/` — Grafana with auto-provisioned Prometheus datasource
- `alertmanager/` — Alert routing config
- `iac/` — OpenTofu config to provision Prometheus via Docker provider
- `.github/workflows/ci.yml` — CI pipeline (lint + build)
- `compose.yml` — Docker Compose stack

## Steps

1. Start the stack: `docker compose up -d`
2. Verify all services are running: `docker compose ps`
3. Open Prometheus at http://localhost:9090 — check Targets page
4. Open Grafana at http://localhost:3001 — verify Prometheus datasource
5. Build a dashboard with panels for: request rate, P95 latency, error rate,
   memory usage
6. Let the app run for 5-10 minutes. Watch the metrics.
7. Something is wrong. Find it with PromQL.
8. Write the diagnostic PromQL query that proves the issue.
9. Identify the root cause in the source code.
10. Write a postmortem document.

## Verification

Run `bash verify.sh` from the project root to check your progress.

## Hints (only if stuck)

<details>
<summary>Hint 1: What to look for</summary>
Watch memory-related metrics. Is anything growing without bound?
</details>

<details>
<summary>Hint 2: The PromQL query</summary>
Try: increase(nodejs_heap_used_bytes[5m])
</details>

<details>
<summary>Hint 3: The root cause</summary>
Look at app.js for a module-scope array that never gets cleaned up.
</details>

## Difficulty: Challenge

This is the course's final assessment. No step-by-step guidance — use
everything you have learned across all 8 modules.
