---
gsd_state_version: 1.0
milestone: v1.1
milestone_name: Command Pedagogy
status: planning
stopped_at: Completed 09-03-PLAN.md
last_updated: "2026-03-20T12:57:44.630Z"
last_activity: 2026-03-20 — v1.1 roadmap created; ready to plan Phase 8
progress:
  total_phases: 4
  completed_phases: 2
  total_plans: 5
  completed_plans: 5
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
| Phase 08-design-lock P01 | 4 | 2 tasks | 3 files |
| Phase 08-design-lock P08-02 | 8min | 2 tasks | 3 files |
| Phase 09-component-implementation P02 | 2min | 2 tasks | 2 files |
| Phase 09-component-implementation P01 | 2min | 2 tasks | 2 files |
| Phase 09-component-implementation P09-03 | 3 | 3 tasks | 4 files |

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting v1.1 work:

- [v1.1 Roadmap]: Design lock phase (Phase 8) is mandatory before any code — 8 critical pitfalls from research are all Phase 1 preventions; annotation co-location, MDX prop pattern, challenge verification policy, and localStorage key must be locked in writing first
- [v1.1 Roadmap]: Bottom-up component build order is non-negotiable (context/types → leaf components → ExerciseCard → LessonLayout) — ExerciseCard is consumed in 52/56 lessons, all new props must be optional
- [v1.1 Roadmap]: Linux Fundamentals migrated first as prototype (Phase 10) before bulk migration (Phase 11) — validates annotation schema and MDX serialization against the actual Next.js 16.2 + @next/mdx 3.1.1 config
- [v1.1 Roadmap]: SCEN requirements introduce ScenarioQuestion as a new component pattern — "I am running this command to answer THIS question" with expandable reveal; distinct from AnnotatedCommand and ChallengeReferenceSheet
- [v1.1 Roadmap]: `next build` runs per module after migration, never in batch — MDX prop serialization errors caught early
- [Phase 08-design-lock]: Annotation co-location: annotations array lives in ExerciseStep (not parallel top-level array) to prevent silent misalignment on step reordering
- [Phase 08-design-lock]: Foundation safety net is a hard override in ExerciseCard — applies regardless of learner preferredMode or explicit mode prop
- [Phase 08-design-lock]: Preferences stored under 'learn-systems-preferences' (separate from 'learn-systems-progress') — progress reset cannot wipe mode preference
- [Phase 08-design-lock]: annotated={true} is a migration gate on ExerciseCard — prevents partial annotation coverage from showing empty UI; removed after full coverage
- [Phase 08-design-lock]: Challenge exercises author the full steps array for guided fallback but challengePrompt-only displays in compose mode
- [Phase 08-design-lock]: Foundation safety-net is a hard code override — difficulty===Foundation returns guided immediately, skipping all prop and preference checks
- [Phase 08-design-lock]: Foundation command field count is 160 (not ~200 estimate) — 22 lessons with ExerciseCard content across 8 modules; research over-estimated 20%
- [Phase 08-design-lock]: Only 1 difficulty mismatch found (05-cicd/05-cheat-sheet.mdx); must be resolved before Phase 11 migrates 05-cicd module
- [Phase 09-component-implementation]: ScenarioQuestion uses violet-500 left border accent to distinguish from Callout types (green/amber/blue)
- [Phase 09-component-implementation]: ChallengeReferenceSheet does not enforce 15-item cap at runtime — policy enforcement is a content authoring concern, not a component concern
- [Phase 09-component-implementation]: ChallengeReferenceSheet passes className='my-0' to QuickReference to suppress default my-8 margin inside the wrapper container
- [Phase 09-01]: AnnotatedCommand implemented as server component (no use client) — zero interactive state required; works inside use client ExerciseCard via Next.js composition model
- [Phase 09-component-implementation]: DifficultyToggle Challenge button calls setPreferredMode(null) not 'compose' — avoids Intermediate compose regression when navigating between lesson difficulties
- [Phase 09-component-implementation]: ExerciseCard compose branch falls back to guided steps when challengePrompt absent — backward compat for all 52 existing exercises

### Pending Todos

None yet.

### Blockers/Concerns

- Phase 8 must enumerate exact Foundation command field count (~200 estimate) and frontmatter/ExerciseCard difficulty mismatch list before Phase 9 begins — these gaps are flagged in research SUMMARY.md
- MDX inline prop parse behavior with complex objects is unvalidated in the specific Next.js 16.2 + @next/mdx 3.1.1 config — Phase 10 prototype must validate import-from-.ts pattern before Phase 11 commits to it

## Session Continuity

Last session: 2026-03-20T12:53:38.502Z
Stopped at: Completed 09-03-PLAN.md
Resume file: None
