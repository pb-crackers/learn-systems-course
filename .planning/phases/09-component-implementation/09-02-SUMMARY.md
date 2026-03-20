---
phase: 09-component-implementation
plan: "02"
subsystem: ui
tags: [react, nextjs, tailwind, lucide-react, mdx]

# Dependency graph
requires:
  - phase: 09-component-implementation
    provides: QuickReference component and ReferenceSection/ReferenceItem types
  - phase: 08-design-lock
    provides: Challenge content policy, color scheme decisions, component architecture decisions
provides:
  - ScenarioQuestion component with expandable answer reveal and violet accent
  - ChallengeReferenceSheet component wrapping QuickReference with red challenge styling
affects:
  - 09-component-implementation (ExerciseCard integration in later plans)
  - 10-linux-fundamentals-migration (MDX registration of ScenarioQuestion and ChallengeReferenceSheet)
  - 11-bulk-migration (all Challenge exercises using ChallengeReferenceSheet)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Expandable reveal: useState + ChevronDown rotate-180 transition (mirrors VerificationChecklist hints)"
    - "Thin wrapper pattern: ChallengeReferenceSheet delegates rendering entirely to QuickReference"
    - "Color token discipline: violet for ScenarioQuestion, red for ChallengeReferenceSheet — avoid collision with Callout green/amber/blue"

key-files:
  created:
    - components/content/ScenarioQuestion.tsx
    - components/content/ChallengeReferenceSheet.tsx
  modified: []

key-decisions:
  - "ScenarioQuestion uses violet-500 left border accent to distinguish from Callout types (green/amber/blue) — prevents visual ambiguity in lesson flow"
  - "ChallengeReferenceSheet does not enforce 15-item cap at runtime — policy enforcement is a content authoring concern, not a component concern"
  - "ChallengeReferenceSheet passes className='my-0' to QuickReference to suppress default my-8 margin inside the wrapper container"

patterns-established:
  - "Expandable reveal pattern: useState boolean + ChevronDown with rotate-180 transition"
  - "Thin wrapper pattern for challenge-specific styling: wrapper handles visual frame, delegates content rendering to existing component"

requirements-completed: [SCEN-01, SCEN-02, SCEN-03, CHAL-04]

# Metrics
duration: 2min
completed: 2026-03-20
---

# Phase 9 Plan 02: ScenarioQuestion and ChallengeReferenceSheet leaf components

**ScenarioQuestion client component with violet accent and expandable answer reveal; ChallengeReferenceSheet server wrapper over QuickReference with red challenge styling**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-20T12:46:10Z
- **Completed:** 2026-03-20T12:47:30Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments

- ScenarioQuestion renders question text under a "Think About It" header with violet-500 left border accent and HelpCircle icon — distinct from Callout's green/amber/blue palette
- Expandable answer reveal uses ChevronDown rotate-180 pattern and "Show Answer" / "Hide Answer" toggle — consistent with VerificationChecklist hint pattern
- ChallengeReferenceSheet wraps QuickReference with red-tinted border/background matching the Challenge difficulty badge color scheme from ExerciseCard's DIFFICULTY_CONFIG
- Both components return null on empty/falsy input as guard against missing MDX props

## Task Commits

Each task was committed atomically:

1. **Task 1: Create ScenarioQuestion component** - `3543ef4` (feat)
2. **Task 2: Create ChallengeReferenceSheet component** - `460ee52` (feat)

**Plan metadata:** (docs commit follows)

## Files Created/Modified

- `components/content/ScenarioQuestion.tsx` - Client component; question with expandable answer reveal; violet left border accent; "Think About It" header with HelpCircle icon
- `components/content/ChallengeReferenceSheet.tsx` - Server component; thin wrapper over QuickReference; red challenge visual treatment; "Command Reference" header

## Decisions Made

- ScenarioQuestion uses `border-l-violet-500/60` — chosen to avoid collision with all three Callout variants (green tip, amber warning, blue deep-dive)
- ChallengeReferenceSheet runtime does not enforce the 15-item cap — that is an authoring policy enforced during content review (Phase 10/11), not in component code
- `className="my-0"` passed to QuickReference to suppress the component's default `my-8` margin since ChallengeReferenceSheet's wrapper provides its own `my-4` spacing

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

Pre-existing TypeScript errors in `hooks/__tests__/useLocalStorage.test.ts`, `lib/__tests__/mdx.test.ts`, and related test files (missing `@types/jest` / `@types/mocha`) were present before this plan and are out of scope. No new errors were introduced by the two new components.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- ScenarioQuestion and ChallengeReferenceSheet are ready for MDX registration and ExerciseCard integration in subsequent Phase 9 plans
- Both components are standalone leaf components with no context dependencies — safe to use immediately in MDX
- ChallengeReferenceSheet correctly imports and re-exports ReferenceSection from QuickReference for MDX authoring ergonomics

---
*Phase: 09-component-implementation*
*Completed: 2026-03-20*
