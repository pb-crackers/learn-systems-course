---
gsd_state_version: 1.0
milestone: v1.1
milestone_name: Command Pedagogy
status: active
stopped_at: null
last_updated: "2026-03-20T12:00:00.000Z"
last_activity: "2026-03-20 — v1.1 roadmap created (4 phases, 20 requirements)"
progress:
  total_phases: 4
  completed_phases: 0
  total_plans: 0
  completed_plans: 0
  percent: 0
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-03-20)

**Core value:** Every lesson must be hands-on and interactive with thorough explanations — the learner practices real skills and understands how machines actually work. Delivered as a modern, production-ready Next.js web application.
**Current focus:** Phase 8 — Design Lock

## Current Position

Phase: 8 of 11 (Design Lock)
Plan: — of — in current phase
Status: Ready to plan
Last activity: 2026-03-20 — v1.1 roadmap created; ready to plan Phase 8

Progress: [░░░░░░░░░░] 0% (v1.1 milestone)

## Performance Metrics

**Velocity (v1.0 baseline):**
- Total plans completed: 27 (v1.0)
- Average duration: ~7min
- Total execution time: ~3.2 hours

**v1.1 Plans:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| — | — | — | — |

**Recent Trend:**
- v1.0 final plans: 5min, 12min, 5min
- Trend: Stable baseline

*Updated after each plan completion*

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting v1.1 work:

- [v1.1 Roadmap]: Design lock phase (Phase 8) is mandatory before any code — 8 critical pitfalls from research are all Phase 1 preventions; annotation co-location, MDX prop pattern, challenge verification policy, and localStorage key must be locked in writing first
- [v1.1 Roadmap]: Bottom-up component build order is non-negotiable (context/types → leaf components → ExerciseCard → LessonLayout) — ExerciseCard is consumed in 52/56 lessons, all new props must be optional
- [v1.1 Roadmap]: Linux Fundamentals migrated first as prototype (Phase 10) before bulk migration (Phase 11) — validates annotation schema and MDX serialization against the actual Next.js 16.2 + @next/mdx 3.1.1 config
- [v1.1 Roadmap]: SCEN requirements introduce ScenarioQuestion as a new component pattern — "I am running this command to answer THIS question" with expandable reveal; distinct from AnnotatedCommand and ChallengeReferenceSheet
- [v1.1 Roadmap]: `next build` runs per module after migration, never in batch — MDX prop serialization errors caught early

### Pending Todos

None yet.

### Blockers/Concerns

- Phase 8 must enumerate exact Foundation command field count (~200 estimate) and frontmatter/ExerciseCard difficulty mismatch list before Phase 9 begins — these gaps are flagged in research SUMMARY.md
- MDX inline prop parse behavior with complex objects is unvalidated in the specific Next.js 16.2 + @next/mdx 3.1.1 config — Phase 10 prototype must validate import-from-.ts pattern before Phase 11 commits to it

## Session Continuity

Last session: 2026-03-20T12:00:00Z
Stopped at: v1.1 roadmap created — Phase 8 ready to plan
Resume file: None
