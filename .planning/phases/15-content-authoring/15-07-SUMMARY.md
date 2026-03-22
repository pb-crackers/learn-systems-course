---
phase: 15-content-authoring
plan: "07"
subsystem: content
tags: [quiz, cloud-fundamentals, mdx, content-authoring]
dependency_graph:
  requires: [Phase 14 - getLessonContent quiz extraction, types/quiz.ts]
  provides: [Module 07 complete quiz coverage]
  affects: [quiz component rendering for all 07-cloud lessons]
tech_stack:
  added: []
  patterns: [export const quiz named export appended after last JSX closing tag]
key_files:
  created: []
  modified:
    - content/modules/07-cloud/01-cloud-concepts.mdx
    - content/modules/07-cloud/02-compute.mdx
    - content/modules/07-cloud/03-cloud-networking.mdx
    - content/modules/07-cloud/04-cloud-storage.mdx
    - content/modules/07-cloud/05-iam.mdx
    - content/modules/07-cloud/06-cheat-sheet.mdx
decisions:
  - Foundation lessons (01, 02, 06) use recall questions (What does X do, which service is Y)
  - Intermediate lessons (03, 04, 05) use application questions (given situation X, what breaks/works)
  - 9 questions in networking and IAM, 8 in all others — all within 7-10 bound
  - Double-quoted strings throughout, no apostrophes inside string literals
metrics:
  duration: "5 minutes"
  completed: "2026-03-22"
  tasks_completed: 2
  files_modified: 6
---

# Phase 15 Plan 07: Cloud Fundamentals Quizzes Summary

**One-liner:** 50 multiple-choice quiz questions across 6 Cloud Fundamentals lessons covering cloud concepts, compute tiers, VPC networking, storage types, and IAM.

## What Was Built

All 6 lessons in Module 07: Cloud Fundamentals received `export const quiz = [...]` blocks appended after the final JSX closing tag. Question counts and difficulty distribution:

| File | Questions | Difficulty | Topics Covered |
|------|-----------|------------|----------------|
| 01-cloud-concepts.mdx | 8 | Foundation | IaaS/PaaS/SaaS, regions, AZs, providers, IaC parity |
| 02-compute.mdx | 8 | Foundation | VM vs container, compute tiers, serverless fit, service names |
| 03-cloud-networking.mdx | 9 | Intermediate | VPC, public/private subnets, load balancers, security groups, DNS |
| 04-cloud-storage.mdx | 8 | Intermediate | Block/object/file, single-mount limitation, HTTP access model |
| 05-iam.mdx | 9 | Intermediate | Users/groups, policies, roles, least privilege, explicit Deny |
| 06-cheat-sheet.mdx | 8 | Foundation | Cross-module service mapping recall |

**Total: 50 questions**

## Verification Results

- `grep -rl "export const quiz" content/modules/07-cloud/ | wc -l` → 6
- `npx tsc --noEmit` → 0 non-test TypeScript errors
- `npx vitest run` → 55/55 tests passing

## Commits

| Task | Description | Commit |
|------|-------------|--------|
| 1 | Author quizzes for all 6 Cloud Fundamentals lessons | 88a0514 |
| 2 | Verify quiz integrity (tsc + vitest) | — (verification only, no new files) |

## Deviations from Plan

None — plan executed exactly as written.
