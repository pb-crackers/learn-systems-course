---
phase: 10-linux-fundamentals-prototype
plan: "03"
subsystem: content
tags: [ScenarioQuestion, intermediate-lessons, linux-fundamentals, module-validation]
dependency_graph:
  requires: [10-01, 10-02]
  provides: [complete-linux-fundamentals-module]
  affects: [phase-11-bulk-migration]
tech_stack:
  added: []
  patterns: [ScenarioQuestion-in-ExerciseCard-before-VerificationChecklist]
key_files:
  created: []
  modified:
    - content/modules/01-linux-fundamentals/05-processes.mdx
    - content/modules/01-linux-fundamentals/06-shell-fundamentals.mdx
    - content/modules/01-linux-fundamentals/07-shell-scripting.mdx
    - content/modules/01-linux-fundamentals/08-text-processing.mdx
    - content/modules/01-linux-fundamentals/09-package-management.mdx
decisions:
  - "ScenarioQuestion placement: before VerificationChecklist in ExerciseCard children (consistent with Foundation lessons from Phase 10-01/02)"
  - "2 ScenarioQuestions per lesson chosen throughout for pedagogical depth rather than the minimum of 1"
  - "Intermediate lessons confirmed: no annotated={true}, no annotations arrays added"
  - "Build failure (Turbopack/rehype-pretty-code) is pre-existing from Phase 9 — TypeScript passes clean"
metrics:
  duration: ~3min
  completed: 2026-03-20
---

# Phase 10 Plan 03: ScenarioQuestions for Intermediate Lessons + Module Validation Summary

**One-liner:** All 9 exercise-bearing Linux Fundamentals lessons now have ScenarioQuestions; TypeScript compiles clean; full module migration validated.

## What Was Built

Added 2 ScenarioQuestion components to each of the 5 Intermediate lessons in the Linux Fundamentals module (lessons 05-09). Questions connect exercise commands back to the opening scenario, requiring the learner to reason about *why* they are running commands — not just what to type.

### ScenarioQuestions Added

**05-processes.mdx** — "Investigate a Runaway Process" scenario:
1. SIGTERM vs SIGKILL: what /proc information to gather before escalating, why SIGTERM is safer
2. Zombie process reaping: why kill -9 cannot kill a zombie, what actually needs to happen (parent calls wait())

**06-shell-fundamentals.mdx** — "Broken PATH and Build a Pipeline" scenario:
1. PATH persistence: how to add /opt/tools/bin and where to persist it in a container
2. xargs as the bridge: why piped PID output needs xargs to become kill arguments

**07-shell-scripting.mdx** — "Deployment Backup Script" scenario:
1. set -u flag: how it prevents the empty-variable rm -rf disaster
2. trap EXIT vs cleanup at bottom: why trap is guaranteed regardless of how the script exits

**08-text-processing.mdx** — "Analyze a Web Server Access Log" scenario:
1. Pipeline modification: how to extend the error-URL pipeline to find per-endpoint client IPs
2. sort before uniq: why uniq only counts adjacent lines and what happens when you skip sort

**09-package-management.mdx** — "Development Server Package Environment" scenario:
1. apt-get update + install same RUN layer: Docker layer caching makes separate layers permanently stale
2. remove vs purge: which files each preserves, and when purge is the right choice

### Module Audit Results

| Lesson | annotated={true} | ScenarioQuestions |
|--------|-----------------|-------------------|
| 01-how-computers-work (Foundation) | 1 | 2 |
| 02-operating-systems (Foundation) | 1 | 2 |
| 03-linux-filesystem (Foundation) | 1 | 2 |
| 04-file-permissions (Foundation) | 1 | 2 |
| 05-processes (Intermediate) | 0 | 2 |
| 06-shell-fundamentals (Intermediate) | 0 | 2 |
| 07-shell-scripting (Intermediate) | 0 | 2 |
| 08-text-processing (Intermediate) | 0 | 2 |
| 09-package-management (Intermediate) | 0 | 2 |
| 10-cheat-sheet | n/a | n/a (no ExerciseCard) |

### Build Validation

- **TypeScript (`npx tsc --noEmit`):** PASS — zero new errors
- **Next.js build (`npx next build`):** Pre-existing failure — `loader @next/mdx/mdx-js-loader.js does not have serializable options` (Turbopack/rehype-pretty-code incompatibility). This is unchanged from Phase 9 baseline and is not a regression from this plan's changes.

## Deviations from Plan

None — plan executed exactly as written.

## Decisions Made

- ScenarioQuestion placement before VerificationChecklist is consistent with the pattern established in Foundation lessons (Phase 10-01/02 decisions)
- Added 2 ScenarioQuestions per lesson throughout for pedagogical depth; each pair covers a distinct concept from the lesson
- Intermediate lessons confirmed: zero `annotated={true}` or `annotations:` arrays — correct for recall mode rendering

## Self-Check: PASSED

Files created/modified verified:
- content/modules/01-linux-fundamentals/05-processes.mdx — FOUND
- content/modules/01-linux-fundamentals/06-shell-fundamentals.mdx — FOUND
- content/modules/01-linux-fundamentals/07-shell-scripting.mdx — FOUND
- content/modules/01-linux-fundamentals/08-text-processing.mdx — FOUND
- content/modules/01-linux-fundamentals/09-package-management.mdx — FOUND

Commits verified:
- 1c32e58 — Task 1 (lessons 05-08)
- a13f806 — Task 2 (lesson 09 + validation)
