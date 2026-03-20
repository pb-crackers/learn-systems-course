---
phase: 11
plan: "03"
subsystem: content-migration
tags: [monitoring, observability, annotations, scenario-questions, challenge-mode, promql, prometheus, grafana]
dependency_graph:
  requires: [types/exercises.ts, components/content/ChallengeReferenceSheet.tsx, components/content/ScenarioQuestion.tsx]
  provides: [08-monitoring module fully migrated with Foundation annotations, Intermediate ScenarioQuestions, Challenge capstone]
  affects: [content/modules/08-monitoring]
tech_stack:
  added: []
  patterns: [CommandAnnotation co-location, annotated={true} gate, ScenarioQuestion paragraph-length answers, challengePrompt goal-only format, ChallengeReferenceSheet 15-item cap with distractors]
key_files:
  created: [.planning/phases/11-full-content-migration/11-03-SUMMARY.md]
  modified:
    - content/modules/08-monitoring/01-observability-concepts.mdx
    - content/modules/08-monitoring/02-prometheus.mdx
    - content/modules/08-monitoring/03-grafana.mdx
    - content/modules/08-monitoring/04-log-aggregation.mdx
    - content/modules/08-monitoring/05-incident-response.mdx
    - content/modules/08-monitoring/07-advanced-capstone.mdx
decisions:
  - "ScenarioQuestions for 08-monitoring reference the opening scenario context (startup DevOps engineer, distributed Node.js app with missing observability)"
  - "01-observability-concepts annotations use abbreviated quoted-string tokens for echo commands since the full string is too long for a token field"
  - "07-advanced-capstone ChallengeReferenceSheet includes 15 items (4 container management, 5 PromQL queries, 3 Grafana, 3 IaC/verification) with tofu init/apply as potential distractors for learners who do not attempt the optional IaC step"
  - "TypeScript test file errors (missing @types/jest) are pre-existing infrastructure issues unrelated to this migration — all application code compiles clean"
metrics:
  duration: "~8 minutes"
  completed: "2026-03-20"
  tasks_completed: 2
  files_modified: 6
---

# Phase 11 Plan 03: 08-monitoring Module Migration Summary

**One-liner:** Foundation annotation + ScenarioQuestions for observability/Prometheus lessons, Intermediate ScenarioQuestions for Grafana/Loki/incident-response, Challenge capstone with challengePrompt + ChallengeReferenceSheet using the memory-leak scenario.

## What Was Built

Migrated all 6 active lessons in the `08-monitoring` module following the validated Phase 10 pattern established in linux-fundamentals.

**Task 1 — Foundation annotations (01-observability-concepts.mdx, 02-prometheus.mdx):**

- `01-observability-concepts.mdx`: Annotated all 4 command steps (all are `echo` commands displaying analysis text). Added `annotated={true}`. Added 2 ScenarioQuestions covering the metrics-first debugging sequence and the cost model argument for starting with metrics over logs.
- `02-prometheus.mdx`: Annotated all 10 command steps including multi-token chains (`cd && docker compose up -d`, `sleep && open`, `curl | python3`, `for...done` loop). Added `annotated={true}`. Added 2 ScenarioQuestions covering the `up` metric semantics vs actual health, and the zero-value counter debug pattern.

**Task 2 — Intermediate ScenarioQuestions and Challenge capstone:**

- `03-grafana.mdx`: Added 2 ScenarioQuestions — provisioned vs manual datasource semantics, and Time Series vs Stat panel type choice rationale.
- `04-log-aggregation.mdx`: Added 2 ScenarioQuestions — Loki label-first query model diagnosis, and Loki vs Elasticsearch trade-off for a Kubernetes environment.
- `05-incident-response.mdx`: Added 2 ScenarioQuestions — `for` duration mechanics for a 1m45s spike, and blameless postmortem root cause reframing.
- `07-advanced-capstone.mdx` (Challenge difficulty):
  - Added `challengePrompt` prop describing the goal without procedural language
  - Added `ChallengeReferenceSheet` with 15 items across 4 sections (Container Management, Prometheus Queries, Grafana Operations, IaC and Verification)
  - Added 1 ScenarioQuestion connecting the memory metric discrepancy pattern to heap leak diagnosis
  - Existing 6-item VerificationChecklist with runnable commands already met the 3-item minimum

## Deviations from Plan

None — plan executed exactly as written.

## Verification

```
annotated={true} count per Foundation file: 1 each (2 total)
ScenarioQuestion count per Intermediate file: 2 each (6 total)
challengePrompt on advanced capstone: 1
ChallengeReferenceSheet on advanced capstone: 1 (15 items, no sequential language)
VerificationChecklist items in capstone: 6 (minimum 3 required)
TypeScript errors in application code: 0
```

## Self-Check

**Files exist:**
- content/modules/08-monitoring/01-observability-concepts.mdx — FOUND (modified)
- content/modules/08-monitoring/02-prometheus.mdx — FOUND (modified)
- content/modules/08-monitoring/03-grafana.mdx — FOUND (modified)
- content/modules/08-monitoring/04-log-aggregation.mdx — FOUND (modified)
- content/modules/08-monitoring/05-incident-response.mdx — FOUND (modified)
- content/modules/08-monitoring/07-advanced-capstone.mdx — FOUND (modified)

**Commits exist:**
- 467c7ff — feat(11-03): annotate Foundation lessons 01-02 and add ScenarioQuestions
- ec5c263 — feat(11-03): add ScenarioQuestions to Intermediate lessons and migrate advanced capstone to Challenge mode

## Self-Check: PASSED
