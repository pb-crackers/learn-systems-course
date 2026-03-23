---
phase: 15-content-authoring
plan: 01
subsystem: content/quiz
tags: [quiz, content, mdx, module-01, linux-fundamentals]
dependency_graph:
  requires: [14-01]
  provides: [quiz-data-module-01]
  affects: [app/lesson/[moduleSlug]/[lessonSlug]]
tech_stack:
  added: []
  patterns: [mdx-named-exports, quiz-array-format]
key_files:
  created: []
  modified:
    - content/modules/01-linux-fundamentals/01-how-computers-work.mdx
    - content/modules/01-linux-fundamentals/02-operating-systems.mdx
    - content/modules/01-linux-fundamentals/03-linux-filesystem.mdx
    - content/modules/01-linux-fundamentals/04-file-permissions.mdx
    - content/modules/01-linux-fundamentals/05-processes.mdx
    - content/modules/01-linux-fundamentals/06-shell-fundamentals.mdx
    - content/modules/01-linux-fundamentals/07-shell-scripting.mdx
    - content/modules/01-linux-fundamentals/08-text-processing.mdx
    - content/modules/01-linux-fundamentals/09-package-management.mdx
    - content/modules/01-linux-fundamentals/10-cheat-sheet.mdx
decisions:
  - "Foundation lessons (01-04, 10) use recall questions (what does X do, which command); Intermediate lessons (05-09) use application questions (given situation X, what happens)"
  - "hw-q1 through hw-q3 IDs reused in new quiz for consistency — they now refer to entirely new questions replacing placeholders"
metrics:
  duration: 7min
  completed: 2026-03-22
  tasks_completed: 2
  files_modified: 10
---

# Phase 15 Plan 01: Module 01 Linux Fundamentals Quiz Authoring Summary

**One-liner:** 82 quiz questions authored for all 10 Linux Fundamentals lessons, replacing 3 placeholders with full content-accurate quizzes using MDX named exports.

## What Was Built

Authored 8-9 multiple-choice quiz questions for each of the 10 lessons in Module 01: Linux Fundamentals. Total: 82 questions across 10 files.

Each question has:
- A unique ID with the lesson's prefix (hw, os, fs, perm, proc, shell, script, text, pkg, linux-ref)
- Exactly 4 answer options as a 4-tuple
- A valid `correctIndex` (0-3)
- A 2-3 sentence explanation that explains WHY the correct answer is right, not just restates the fact
- Double-quoted strings throughout (no apostrophes inside quoted strings)

**Lesson 01 (01-how-computers-work.mdx):** 3 placeholder questions replaced with 9 full questions covering fetch-decode-execute cycle, ALU, memory hierarchy, virtual memory, HDDs vs SSDs, DMA, and I/O diagnosis.

**Lessons 02-10:** Quiz blocks appended after the closing `/>` of the last JSX component in each file.

## Quality Standards Applied

- Foundation lessons (01-04, 10): Questions test recall — "Which command does X?", "What does Y store?"
- Intermediate lessons (05-09): Questions test application — "Given situation X, what happens?", "Which approach achieves Y?"
- Distractors are plausible adjacent concepts, not obviously absurd options
- Every correct answer is findable in the specific lesson's content

## Verification Results

- `grep -rl "export const quiz" content/modules/01-linux-fundamentals/ | wc -l` → 10
- `npx tsc --noEmit` → 0 non-test errors
- `npx vitest run` → 55/55 tests passed

## Tasks Completed

| Task | Description | Commit | Files |
|------|-------------|--------|-------|
| 1 | Author quizzes for all 10 lessons | 62fddd2 | 10 modified |
| 2 | Verify Module 01 quiz integrity | (verification only) | 0 |

## Deviations from Plan

None — plan executed exactly as written.

## Self-Check: PASSED

- All 10 quiz files verified to exist and contain `export const quiz`
- Commit 62fddd2 confirmed in git log
- 0 TypeScript errors, 55/55 tests passing
