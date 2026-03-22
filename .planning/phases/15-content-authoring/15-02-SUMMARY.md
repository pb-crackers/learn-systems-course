---
phase: 15-content-authoring
plan: "02"
subsystem: content
tags: [quiz, mdx, networking, content-authoring]
dependency_graph:
  requires: [14-01]
  provides: [Module 02 quiz coverage]
  affects: [quiz component, lesson gating, progress tracking]
tech_stack:
  added: []
  patterns: [MDX named exports, QuizQuestion 4-tuple options, correctIndex 0-3]
key_files:
  modified:
    - content/modules/02-networking/01-how-networks-work.mdx
    - content/modules/02-networking/02-tcp-ip-stack.mdx
    - content/modules/02-networking/03-dns.mdx
    - content/modules/02-networking/04-http-https.mdx
    - content/modules/02-networking/05-ssh.mdx
    - content/modules/02-networking/06-firewalls.mdx
    - content/modules/02-networking/07-troubleshooting.mdx
    - content/modules/02-networking/08-cheat-sheet.mdx
decisions:
  - Foundation lessons (01-04, 08) use recall questions; Intermediate lessons (05-07) use application/scenario questions
  - Quiz IDs use per-lesson prefixes: net, tcp, dns, http, ssh, fw, netdbg, net-ref
metrics:
  duration: "~6 minutes"
  completed_date: "2026-03-22"
  tasks_completed: 2
  files_modified: 8
---

# Phase 15 Plan 02: Networking Foundations Quizzes Summary

Module 02 quiz blocks authored and appended to all 8 MDX lessons — 74 questions total across the networking module, fully typed, zero TypeScript errors, all existing tests passing.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Author quizzes for all 8 Networking Foundations lessons | 88a165a | 8 MDX files |
| 2 | Verify Module 02 quiz integrity | (verification only) | — |

## What Was Built

All 8 lessons in `content/modules/02-networking/` now have an `export const quiz = [...]` block appended after the last JSX closing tag. The quiz data follows the `QuizQuestion` type defined in `types/quiz.ts` exactly — `options` is typed as a 4-tuple `[string, string, string, string]`, `correctIndex` is `0 | 1 | 2 | 3`, and all string values use double quotes to avoid apostrophe issues in JSX.

**Question counts by file:**

| File | Questions | Difficulty Level |
|------|-----------|-----------------|
| 01-how-networks-work.mdx | 10 | Foundation (recall) |
| 02-tcp-ip-stack.mdx | 10 | Foundation (recall) |
| 03-dns.mdx | 10 | Foundation (recall) |
| 04-http-https.mdx | 10 | Foundation (recall) |
| 05-ssh.mdx | 8 | Intermediate (application) |
| 06-firewalls.mdx | 8 | Intermediate (application) |
| 07-troubleshooting.mdx | 8 | Intermediate (application) |
| 08-cheat-sheet.mdx | 8 | Foundation (recall) |
| **Total** | **74** | |

**Quality standards applied:**
- Foundation lessons test recall: "What does X do?", "Which protocol handles Y?"
- Intermediate lessons test application: scenario-based questions requiring learners to reason about what happens in a given situation
- All distractors are plausible (common misconceptions or adjacent concepts)
- Explanations are 2-3 sentences explaining the mechanism, not just restating the answer
- Every question is scoped to only the content in that lesson

## Verification Results

- `grep -rl "export const quiz" content/modules/02-networking/ | wc -l` → **8** (expected 8)
- `npx tsc --noEmit` non-test errors → **0**
- `npx vitest run` → **55 passed** (all existing tests)

## Deviations from Plan

None — plan executed exactly as written.

## Self-Check: PASSED

All 8 quiz exports verified present. Commit 88a165a confirmed in git log. TypeScript clean. Tests passing.
