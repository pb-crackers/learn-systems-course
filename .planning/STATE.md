---
gsd_state_version: 1.0
milestone: v1.2
milestone_name: Enhanced Questions
status: planning
stopped_at: Completed 15-04-PLAN.md
last_updated: "2026-03-22T21:26:25.637Z"
last_activity: 2026-03-22 — v1.2 roadmap created, phases 12-15 defined
progress:
  total_phases: 4
  completed_phases: 4
  total_plans: 11
  completed_plans: 11
  percent: 0
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-03-22)

**Core value:** Every lesson must be hands-on and interactive with thorough explanations — the learner practices real skills and understands how machines actually work. Delivered as a modern, production-ready Next.js web application.
**Current focus:** Phase 12 — Schema and Progress Foundation (v1.2)

## Current Position

Phase: 12 of 15 (Schema and Progress Foundation)
Plan: — (not yet planned)
Status: Ready to plan
Last activity: 2026-03-22 — v1.2 roadmap created, phases 12-15 defined

Progress: [░░░░░░░░░░] 0% (v1.2 milestone)

## Performance Metrics

**Velocity (v1.1 baseline):**
- Total plans completed: 15 (v1.1)
- Average duration: ~6min
- Total execution time: ~1.5 hours

**v1.1 Plans:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| Phase 08-design-lock P01 | 4 | 2 tasks | 3 files |
| Phase 08-design-lock P08-02 | 8min | 2 tasks | 3 files |
| Phase 09-component-implementation P02 | 2min | 2 tasks | 2 files |
| Phase 09-component-implementation P01 | 2min | 2 tasks | 2 files |
| Phase 09-component-implementation P09-03 | 3 | 3 tasks | 4 files |
| Phase 10-linux-fundamentals-prototype P01 | 5min | 2 tasks | 2 files |
| Phase 10-linux-fundamentals-prototype P02 | 6min | 2 tasks | 2 files |
| Phase 10-linux-fundamentals-prototype P03 | 3min | 2 tasks | 5 files |
| Phase 11-full-content-migration P11-01 | 4min | 2 tasks | 5 files |
| Phase 11-full-content-migration P06 | 6min | 2 tasks | 6 files |
| Phase 11-full-content-migration P05 | 20min | 2 tasks | 8 files |
| Phase 11-full-content-migration P11-04 | 7min | 2 tasks | 4 files |
| Phase 11-full-content-migration P07 | 9min | 2 tasks | 7 files |

**Recent Trend:**
- v1.1 final plans: 6min, 20min, 7min, 9min
- Trend: Stable

*Updated after each plan completion*
| Phase 12-schema-and-progress-foundation P01 | 2min | 2 tasks | 5 files |
| Phase 13-quiz-component-build P01 | 3min | 2 tasks | 2 files |
| Phase 14-layout-integration-and-gating P01 | 10min | 3 tasks | 5 files |
| Phase 15-content-authoring P06 | 4min | 2 tasks | 5 files |
| Phase 15-content-authoring P05 | 4min | 2 tasks | 5 files |
| Phase 15-content-authoring P07 | 5min | 2 tasks | 6 files |
| Phase 15-content-authoring P08 | 5min | 2 tasks | 7 files |
| Phase 15-content-authoring P02 | 6min | 2 tasks | 8 files |
| Phase 15-content-authoring P15-01 | 7min | 2 tasks | 10 files |
| Phase 15-content-authoring P03 | 12min | 2 tasks | 9 files |

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting v1.2 work:

- [v1.2 Roadmap]: Wrong-answer UX shows "Incorrect" only — no correct answer reveal (KRF-only; deliberate departure from Duolingo/Codecademy defaults)
- [v1.2 Roadmap]: Grandfather rule — `completed && (quizPassed !== false)` — pre-v1.2 progress records must not silently reset to 0%
- [v1.2 Roadmap]: Quiz data as MDX named exports (`export const quiz = [...]`), not separate files or frontmatter
- [v1.2 Roadmap]: `MarkCompleteButton` kept for `quiz === null` lessons — removed only for lessons with quiz data (Phase 14)
- [v1.2 Roadmap]: One-lesson end-to-end validation in Phase 14 before bulk authoring in Phase 15
- [Phase 12-schema-and-progress-foundation]: isLessonComplete uses !== false for quizPassed so undefined (pre-v1.2 records) is treated as passing — grandfather rule preserves existing completed lessons
- [Phase 12-schema-and-progress-foundation]: QuizQuestion.options typed as 4-tuple [string,string,string,string] — compile-time enforcement of exactly 4 options
- [Phase 12-schema-and-progress-foundation]: markQuizPassed sets completed:true in one operation — quiz pass IS lesson completion for quiz-enabled lessons
- [Phase 13-quiz-component-build]: quizReducer, QuizMachineState, QuizAction exported for testability
- [Phase 13-quiz-component-build]: correctIndex never rendered in failed/incorrect path — fixed Incorrect banner text only (QUIZ-02)
- [Phase 13-quiz-component-build]: markQuizPassed called via useEffect on passed phase — runs once per completion
- [Phase 14-layout-integration-and-gating]: QuizSection 'use client' wrapper bridges RSC serialization boundary — LessonLayout stays as Server Component
- [Phase 14-layout-integration-and-gating]: Array.isArray(mod.quiz) guard safely extracts optional MDX named export from getLessonContent
- [Phase 14-layout-integration-and-gating]: MarkCompleteButton renders only when quiz is null — empty quiz array does not show the button
- [Phase 15-content-authoring]: Foundation/Intermediate question style distinction maintained: lessons 01, 02, 05 test recall; lessons 03, 04 test application
- [Phase 15-content-authoring]: Questions scoped strictly to lesson content in Module 06 IaC: no cross-lesson knowledge required to answer correctly
- [Phase 15-content-authoring]: Foundation lessons (01, 02, 06) test recall; Intermediate lessons (03, 04, 05) test application — 50 questions total across Module 07
- [Phase 15-content-authoring]: Foundation lessons (01, 02, 06) use recall questions; Intermediate lessons (03, 04, 05) use application questions with Docker/network scenarios; Challenge lesson (07) uses synthesis questions connecting metrics to source-code root causes
- [Phase 15-02]: Foundation lessons (01-04, 08) use recall questions; Intermediate lessons (05-07) use application/scenario questions matching lesson difficulty tags
- [Phase 15-content-authoring]: Foundation lessons test recall; Intermediate lessons test application — quiz difficulty tier matches lesson difficulty tier
- [Phase 15-content-authoring]: Capstone (09) questions focus on multi-symptom root-cause diagnosis spanning preceding lessons — tests synthesis not recall

### Pending Todos

None yet.

### Blockers/Concerns

- [Phase 15]: 392-560 questions across 56 lessons — module-by-module review cadence is mandatory to prevent quality drift; authoring guide must be produced as Phase 12 planning artifact before any authoring starts
- [Phase 15 prereq]: `exercisesCompleted` field consistency across all 56 lessons must be audited before exercise-lock feature (deferred to v1.2.x, not blocking v1.2)

### Quick Tasks Completed

| # | Description | Date | Commit | Directory |
|---|-------------|------|--------|-----------|
| 260320-9il | Fix lesson page readability: improve header/metadata area and heading styles | 2026-03-20 | c726a5b | [260320-9il](./quick/260320-9il-fix-lesson-page-readability-improve-head/) |
| 260320-9oq | Fix build error (Callout type="info") and visible frontmatter (remark-frontmatter) | 2026-03-20 | da73b54 | [260320-9oq](./quick/260320-9oq-fix-build-error-and-visible-frontmatter-/) |
| 260320-k09 | Fix MDX escaped double quotes in 19 files | 2026-03-20 | fc86a7e | [260320-k09](./quick/260320-k09-fix-mdx-escaped-double-quotes-in-19-file/) |

## Session Continuity

Last session: 2026-03-22T21:26:25.635Z
Stopped at: Completed 15-04-PLAN.md
Resume file: None
