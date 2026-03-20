---
phase: 08-design-lock
plan: 01
subsystem: types
tags: [typescript, design-contracts, annotations, preferences, exercises]

# Dependency graph
requires: []
provides:
  - CommandAnnotation TypeScript interface with token, description (120 char max), optional example
  - ExerciseStep interface extended with optional annotations array (no breaking changes)
  - ExerciseCardProps interface with optional mode, annotated, challengePrompt props
  - ExerciseMode union type: guided | recall | compose
  - DIFFICULTY_MODE_DEFAULT mapping Foundation->guided, Intermediate->recall, Challenge->compose
  - PREFERENCES_STORAGE_KEY ('learn-systems-preferences') distinct from PROGRESS_STORAGE_KEY
  - PreferencesState interface and INITIAL_PREFERENCES constant
  - FOUNDATION_SAFETY_NET documented as hard override constant
  - Annotation authoring style guide: display policy, token format, description rules, completeness gate
  - Preference system spec: localStorage key separation, mode resolution chain, Foundation safety net, toggle visibility
affects: [09-components, 10-poc-content, 11-full-migration]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Co-located annotations: annotations array lives inside ExerciseStep, not as parallel top-level array"
    - "Optional-only extension: all new props on ExerciseStep and ExerciseCardProps use ? suffix"
    - "Storage key separation: preferences and progress use distinct localStorage keys"
    - "Three-tier mode resolution: explicit prop > learner preference > difficulty default"
    - "Foundation safety net: hard override in ExerciseCard, not a default in ProgressProvider"
    - "annotated={true} gate: per-exercise opt-in prevents partial annotation coverage from showing empty UI"

key-files:
  created:
    - types/exercises.ts
    - docs/design/annotation-style-guide.md
    - docs/design/preference-spec.md
  modified: []

key-decisions:
  - "Annotation data is co-located in ExerciseStep (not a parallel top-level array) to prevent silent misalignment on step reordering"
  - "All new ExerciseStep and ExerciseCardProps fields are strictly optional — 52 existing MDX files see no breaking change"
  - "Preferences use a separate localStorage key from progress so a progress reset cannot wipe mode preference"
  - "Foundation exercises hard-override to guided regardless of learner preference or explicit mode prop"
  - "DifficultyToggle is shown only on Challenge lessons — Foundation is locked (safety net) and Intermediate is fixed (recall/scaffolding-fading)"
  - "Toggle offers only Guided and Challenge options — Recall is not a learner-selectable preference"
  - "annotated={true} prop is a migration gate to be removed after full coverage, not a permanent feature toggle"
  - "Annotation descriptions: 120 char max, plain prose only (no backticks/curly/angle/unescaped quotes), verb-first, must be self-sufficient"

patterns-established:
  - "Types-first: all interface contracts locked in types/exercises.ts before any component code"
  - "Annotation co-location: annotations?: CommandAnnotation[] lives in ExerciseStep, not at ExerciseCard level"
  - "Plain-prose annotation strings: no special characters that would break MDX parse"
  - "Left-to-right token ordering: annotations appear in command-token order, never reorganized"

requirements-completed: [ANNO-02, DIFF-04]

# Metrics
duration: 4min
completed: 2026-03-20
---

# Phase 8 Plan 1: Design Lock — Interface Contracts and Style Guides Summary

**TypeScript type contracts and authoring policy docs locking CommandAnnotation schema, mode resolution chain, Foundation safety net, and annotation display policy before any component or content work begins.**

## Performance

- **Duration:** ~4 min
- **Started:** 2026-03-20T12:18:50Z
- **Completed:** 2026-03-20T12:22:49Z
- **Tasks:** 2
- **Files modified:** 3 created

## Accomplishments

- Created `types/exercises.ts` with all v1.1 type contracts — CommandAnnotation, ExerciseStep (extended), ExerciseCardProps (extended), ExerciseMode, DIFFICULTY_MODE_DEFAULT, PREFERENCES_STORAGE_KEY, PreferencesState, INITIAL_PREFERENCES, FOUNDATION_SAFETY_NET. All new fields are optional; zero breaking changes to existing 52 MDX files. File compiles with no TypeScript errors.
- Created `docs/design/annotation-style-guide.md` locking annotation display policy (always-visible, static, never tooltip), token format rules (split combined flags, left-to-right ordering), description rules (120 char max, plain prose, verb-first, self-sufficiency standard), and completeness gate (annotated={true} must not be set until all steps in an exercise are fully annotated).
- Created `docs/design/preference-spec.md` locking localStorage key separation, PreferencesState shape, three-tier mode resolution chain (Priority 1: explicit mode prop, Priority 2: learner preferredMode, Priority 3: difficulty default), Foundation safety net as a hard override, DifficultyToggle visibility rules (Challenge lessons only), and toggle option set (Guided/Challenge, no Recall option).

## Task Commits

1. **Task 1: Define v1.1 TypeScript type contracts** - `78485d7` (feat)
2. **Task 2: Write annotation style guide and preference specification** - `68a0a44` (feat)

**Plan metadata:** (final docs commit — see below)

## Files Created/Modified

- `types/exercises.ts` — All v1.1 interface contracts: CommandAnnotation, ExerciseStep, ExerciseCardProps, ExerciseMode, DIFFICULTY_MODE_DEFAULT, PREFERENCES_STORAGE_KEY, PreferencesState, INITIAL_PREFERENCES, FOUNDATION_SAFETY_NET
- `docs/design/annotation-style-guide.md` — Annotation authoring policy: display policy, token format rules, description rules, example field guidance, ordering rules, completeness gate
- `docs/design/preference-spec.md` — Preference system specification: storage, shape, mode resolution chain, Foundation safety net, toggle visibility, toggle options, context API contract

## Decisions Made

- Annotation data is co-located in `ExerciseStep` (not a parallel top-level array indexed by step number) to prevent silent misalignment when steps are reordered.
- All new fields on `ExerciseStep` and `ExerciseCardProps` use `?:` to ensure zero breaking changes across 52 existing MDX files.
- Preferences stored under `'learn-systems-preferences'` (separate key from `'learn-systems-progress'`) so a progress reset cannot wipe mode preference.
- Foundation safety net is a hard override in `ExerciseCard` — applies regardless of learner preference or explicit `mode` prop.
- `DifficultyToggle` visible only on Challenge lessons (Foundation is locked by safety net; Intermediate has fixed recall purpose).
- Toggle exposes only Guided and Challenge modes — Recall is not a learner-selectable option.
- `annotated={true}` is a migration gate to be removed after full annotation coverage, not a permanent feature flag.

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

Phase 9 (component implementation) is unblocked:
- `types/exercises.ts` provides all type contracts Phase 9 components must implement
- `docs/design/preference-spec.md` specifies the ProgressProvider context API extension and DifficultyToggle behavior
- `docs/design/annotation-style-guide.md` specifies the AnnotatedCommand rendering contract (always-visible, static annotation panel)
- All new ExerciseCard props are optional — Phase 9 can modify ExerciseCard without breaking any existing MDX files

No blockers. All eight critical pitfalls from research SUMMARY.md that are Phase 1 preventions are addressed by the type contracts and policy documents in this plan.

---
*Phase: 08-design-lock*
*Completed: 2026-03-20*
