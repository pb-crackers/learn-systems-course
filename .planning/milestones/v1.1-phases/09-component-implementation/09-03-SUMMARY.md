---
phase: 09-component-implementation
plan: "03"
subsystem: ui
tags: [react, typescript, nextjs, mdx, exercise-card, difficulty-toggle, mode-resolution]

# Dependency graph
requires:
  - phase: 09-component-implementation
    provides: AnnotatedCommand, ScenarioQuestion, ChallengeReferenceSheet (Plans 01 and 02)
  - phase: 08-design-lock
    provides: preference-spec.md, foundation-safety-net.md, challenge-content-policy.md design decisions
provides:
  - DifficultyToggle client component (Guided/Challenge toggle for Challenge lessons)
  - Mode-aware ExerciseCard with resolveMode (Foundation safety net, three-tier resolution chain)
  - DifficultyToggle integrated into LessonLayout header (Challenge lessons only)
  - AnnotatedCommand, ScenarioQuestion, ChallengeReferenceSheet registered in mdx-components.tsx
affects:
  - phase-10-linux-fundamentals-migration (uses ExerciseCard with annotated prop and challengePrompt)
  - phase-11-bulk-migration (all 52 existing MDX lessons use ExerciseCard; backward compat confirmed)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "resolveMode() — three-tier chain: Foundation hard-override → mode prop → preferredMode → difficulty default"
    - "Challenge button sets setPreferredMode(null) not 'compose' — null means use difficulty default, avoids Intermediate compose regression"
    - "Server component (LessonLayout) renders client component (DifficultyToggle) — no 'use client' added to LessonLayout"
    - "annotated prop as migration gate — prevents partial annotation coverage from showing empty UI"

key-files:
  created:
    - components/lesson/DifficultyToggle.tsx
  modified:
    - components/content/ExerciseCard.tsx
    - components/lesson/LessonLayout.tsx
    - mdx-components.tsx

key-decisions:
  - "Challenge button in DifficultyToggle calls setPreferredMode(null) not setPreferredMode('compose') — null falls back to difficulty default, so navigating to Intermediate after Challenge correctly uses recall instead of compose"
  - "resolveMode() Foundation check is line 1 — no prop or preference can override it"
  - "Compose fallback to guided steps when challengePrompt is absent maintains backward compat for all existing Challenge exercises"

patterns-established:
  - "ExerciseCard is the single mode control point for all three difficulty tiers"
  - "LessonLayout gates toggle visibility on difficulty — server component reads frontmatter, client component handles interaction"

requirements-completed: [DIFF-01, DIFF-02, CHAL-01]

# Metrics
duration: 3min
completed: 2026-03-20
---

# Phase 09 Plan 03: Component Integration Summary

**DifficultyToggle + mode-aware ExerciseCard wired together: three-tier resolveMode chain, Foundation hard override, Challenge/Guided toggle in lesson header, all new components registered in MDX**

## Performance

- **Duration:** ~3 min
- **Started:** 2026-03-20T13:09:58Z
- **Completed:** 2026-03-20T13:12:16Z
- **Tasks:** 3
- **Files modified:** 4

## Accomplishments

- Created DifficultyToggle client component with Guided/Challenge toggle; Challenge sets null (not 'compose') for correct Intermediate fallback
- Rewrote ExerciseCard: resolveMode() implements Foundation safety net as first check, then three-tier fallback; guided/recall/compose branches; annotated prop gates AnnotatedCommand rendering
- Integrated DifficultyToggle into LessonLayout header (Challenge-only gate); registered AnnotatedCommand, ScenarioQuestion, ChallengeReferenceSheet in mdx-components.tsx

## Task Commits

Each task was committed atomically:

1. **Task 1: Create DifficultyToggle component** - `be78049` (feat)
2. **Task 2: Rewrite ExerciseCard with mode-aware rendering** - `c72f201` (feat)
3. **Task 3: Integrate DifficultyToggle into LessonLayout and register MDX components** - `e959a94` (feat)

**Plan metadata:** (pending)

## Files Created/Modified

- `components/lesson/DifficultyToggle.tsx` - Guided/Challenge toggle; reads/writes preferredMode via useProgress(); Challenge sets null not 'compose'
- `components/content/ExerciseCard.tsx` - Full mode-aware rewrite with resolveMode(); imports from types/exercises; guided/recall/compose branches; backward compatible
- `components/lesson/LessonLayout.tsx` - Import and conditional render of DifficultyToggle for Challenge lessons; remains server component
- `mdx-components.tsx` - Registration of AnnotatedCommand, ScenarioQuestion, ChallengeReferenceSheet

## Decisions Made

- DifficultyToggle "Challenge" button calls `setPreferredMode(null)` not `setPreferredMode('compose')`. When `preferredMode` is null, Intermediate lessons resolve to 'recall' (their default), not 'compose'. This avoids the regression where a learner switches to Challenge on a Challenge lesson, then navigates to an Intermediate lesson and sees compose mode (which is not valid for Intermediate).
- ExerciseCard compose branch falls back to full guided step display when `challengePrompt` is absent. This ensures backward compatibility with all 52 existing Challenge exercises that don't yet have `challengePrompt` authored.

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

- `next build` fails with a pre-existing Turbopack + rehype-pretty-code incompatibility (`Error: loader ... does not have serializable options`). This is documented in `next.config.ts` comments and in STATE.md as a known v1.1 blocker. Not caused by this plan's changes. `tsc --noEmit` passes clean (excluding pre-existing test file type errors from missing `@types/jest`).

## Next Phase Readiness

- All Phase 09 components are complete: AnnotatedCommand, ScenarioQuestion, ChallengeReferenceSheet, DifficultyToggle, mode-aware ExerciseCard
- DifficultyToggle wired into LessonLayout; preference system (ProgressProvider) already extended in Plan 01
- Phase 10 (Linux Fundamentals migration) can now begin — ExerciseCard accepts `annotated`, `challengePrompt`, and step-level `annotations`
- The `next build` Turbopack issue must be resolved before Phase 10 validates the MDX serialization pipeline

---
*Phase: 09-component-implementation*
*Completed: 2026-03-20*

## Self-Check: PASSED

- FOUND: components/lesson/DifficultyToggle.tsx
- FOUND: components/content/ExerciseCard.tsx
- FOUND: .planning/phases/09-component-implementation/09-03-SUMMARY.md
- FOUND commit be78049: feat(09-03): create DifficultyToggle component
- FOUND commit c72f201: feat(09-03): rewrite ExerciseCard with mode-aware rendering
- FOUND commit e959a94: feat(09-03): integrate DifficultyToggle into LessonLayout and register MDX components
