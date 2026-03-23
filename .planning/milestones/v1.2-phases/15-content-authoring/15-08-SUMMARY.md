---
phase: 15-content-authoring
plan: "08"
subsystem: quiz-content
tags: [quiz, monitoring, observability, prometheus, grafana, loki, incident-response]
dependency_graph:
  requires: [14-01]
  provides: [DATA-03]
  affects: [content/modules/08-monitoring]
tech_stack:
  added: []
  patterns: [export-const-quiz-named-export, foundation-recall-intermediate-application-challenge-synthesis]
key_files:
  created: []
  modified:
    - content/modules/08-monitoring/01-observability-concepts.mdx
    - content/modules/08-monitoring/02-prometheus.mdx
    - content/modules/08-monitoring/03-grafana.mdx
    - content/modules/08-monitoring/04-log-aggregation.mdx
    - content/modules/08-monitoring/05-incident-response.mdx
    - content/modules/08-monitoring/06-cheat-sheet.mdx
    - content/modules/08-monitoring/07-advanced-capstone.mdx
decisions:
  - "Foundation lessons (01, 02, 06) use recall questions testing metric types, PromQL syntax, and pillar definitions"
  - "Intermediate lessons (03, 04, 05) use application questions with realistic Docker/network scenarios"
  - "Challenge lesson (07) uses synthesis questions requiring learners to connect metrics to source-code root causes"
metrics:
  duration: "5 minutes"
  completed_date: "2026-03-22"
  tasks_completed: 2
  files_modified: 7
---

# Phase 15 Plan 08: Module 08 Monitoring and Observability Quiz Authoring Summary

**One-liner:** 60 multiple-choice quiz questions authored across 7 Monitoring and Observability lessons — 9 Foundation recall, 10 Foundation recall (Prometheus), 8 Intermediate application (Grafana), 8 Intermediate application (Loki), 8 Intermediate application (Incident Response), 8 Foundation recall (cheat sheet), 9 Challenge synthesis (Capstone).

## Tasks Completed

| # | Name | Commit | Files |
|---|------|--------|-------|
| 1 | Author quizzes for all 7 Monitoring and Observability lessons | 20241d0 | 7 MDX files |
| 2 | Verify Module 08 quiz integrity | 0675115 | — (verification only) |

## What Was Built

Appended `export const quiz = [...]` blocks to all 7 MDX files in `content/modules/08-monitoring/`:

- **01-observability-concepts.mdx** (Foundation): 9 questions on the three pillars, metric types, debugging sequence, and monitoring vs observability distinction. ID prefix: `obs`
- **02-prometheus.mdx** (Foundation): 10 questions on the pull model, counter vs gauge vs histogram usage, PromQL patterns (rate, histogram_quantile, by clause), alert lifecycle, and node-exporter macOS limitation. ID prefix: `prom`
- **03-grafana.mdx** (Intermediate): 8 questions on Docker DNS for datasource URLs, panel type selection, provisioning vs manual config, the four golden signals, and anonymous access. ID prefix: `graf`
- **04-log-aggregation.mdx** (Intermediate): 8 questions on Loki vs Elasticsearch trade-offs, LogQL query model, Docker socket discovery, Promtail pipeline stages, and when to choose each stack. ID prefix: `logagg`
- **05-incident-response.mdx** (Intermediate): 8 questions on PENDING vs FIRING semantics, Alertmanager grouping, blameless postmortems, runbook decision-tree structure, repeat_interval, and escalation protocols. ID prefix: `ir`
- **06-cheat-sheet.mdx** (Foundation): 8 questions covering all module topics as a recall reference — pillar sequence, PromQL rate(), Grafana panel types, MTTD, LogQL syntax, alert states, and anonymous access. ID prefix: `mon-ref`
- **07-advanced-capstone.mdx** (Challenge): 9 synthesis questions requiring learners to connect heap metrics to source code root causes, explain GC pause patterns, diagnose network failures from Docker DNS rules, and evaluate postmortem quality. ID prefix: `advcap`

## Verification Results

- `grep -rl "export const quiz" content/modules/08-monitoring/ | wc -l` → **7**
- `npx tsc --noEmit` non-test errors → **0**
- `npx vitest run` → **55 tests passed, 6 test files**

## Deviations from Plan

None — plan executed exactly as written.

## Self-Check: PASSED

- SUMMARY.md: FOUND at .planning/phases/15-content-authoring/15-08-SUMMARY.md
- Commit 20241d0 (feat): FOUND
- Commit 0675115 (chore): FOUND
- All 7 MDX files verified to contain export const quiz
