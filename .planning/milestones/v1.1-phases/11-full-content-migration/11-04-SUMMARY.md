---
phase: 11-full-content-migration
plan: "04"
subsystem: content
tags: [iac, terraform, opentofu, mdx, annotations, scenario-questions, command-pedagogy]

requires:
  - phase: 10-linux-fundamentals-prototype
    provides: Validated annotation schema and ScenarioQuestion placement pattern from Phase 10 prototype

provides:
  - 06-iac Foundation lessons (01-iac-concepts, 02-hcl-basics) fully annotated with annotated={true}
  - 14 command steps annotated across 2 Foundation lessons (5 in 01, 9 in 02)
  - ScenarioQuestions added to all 4 IaC lessons (2 per lesson)
  - Terraform subcommand annotation pattern established (tofu, init/plan/apply/destroy annotated separately)

affects:
  - 11-full-content-migration (remaining module plans follow same pattern)

tech-stack:
  added: []
  patterns:
    - "Terraform CLI annotation pattern: annotate tofu base command, then subcommand (init/plan/apply/destroy) as separate tokens"
    - "Comment-line commands annotated for meaningful tokens only (docker stop, tofu plan within # comment strings)"
    - "ScenarioQuestions placed before VerificationChecklist in all ExerciseCard children"

key-files:
  created: []
  modified:
    - content/modules/06-iac/01-iac-concepts.mdx
    - content/modules/06-iac/02-hcl-basics.mdx
    - content/modules/06-iac/03-terraform-state.mdx
    - content/modules/06-iac/04-modules.mdx

key-decisions:
  - "Terraform CLI annotation pattern: tofu is the base command token, subcommands (init, plan, apply, destroy) are annotated separately as distinct subcommand tokens"
  - "Comment-prefixed commands in 01-iac-concepts annotated for meaningful CLI tokens embedded in the comment string"

patterns-established:
  - "IaC subcommand annotation: same pattern as docker subcommands — base command first, subcommand second, each with their own description"

requirements-completed: [MIGR-01, MIGR-02, MIGR-04, MIGR-05]

duration: 7min
completed: 2026-03-20
---

# Phase 11 Plan 04: IaC Module (06-iac) Migration Summary

**Terraform/OpenTofu command pedagogy applied to all 4 IaC lessons: 14 Foundation command steps annotated with tofu/docker token breakdowns and 8 ScenarioQuestions connecting CLI commands to infrastructure drift and module composition scenarios**

## Performance

- **Duration:** 7 min
- **Started:** 2026-03-20T13:34:04Z
- **Completed:** 2026-03-20T13:41:00Z
- **Tasks:** 2 completed
- **Files modified:** 4

## Accomplishments

- Annotated all 14 Foundation command steps across 01-iac-concepts (5 steps) and 02-hcl-basics (9 steps) with left-to-right token annotations
- Added `annotated={true}` gate to both Foundation ExerciseCards
- Added 2 ScenarioQuestions to each of all 4 IaC lessons (8 total), placed before VerificationChecklist
- Established Terraform CLI annotation pattern: `tofu` base command + `init/plan/apply/destroy` subcommand as separate tokens

## Task Commits

Each task was committed atomically:

1. **Task 1: Annotate Foundation lessons 01-02 and add ScenarioQuestions** - `172f4bd` (feat)
2. **Task 2: Add ScenarioQuestions to Intermediate lessons and validate module build** - `cdf3242` (feat)

## Files Created/Modified

- `content/modules/06-iac/01-iac-concepts.mdx` - Added `annotated={true}`, per-token annotations for 5 command steps, 2 ScenarioQuestions before VerificationChecklist
- `content/modules/06-iac/02-hcl-basics.mdx` - Added `annotated={true}`, per-token annotations for 9 command steps, 2 ScenarioQuestions before VerificationChecklist
- `content/modules/06-iac/03-terraform-state.mdx` - Added 2 ScenarioQuestions before VerificationChecklist; no annotations (Intermediate)
- `content/modules/06-iac/04-modules.mdx` - Added 2 ScenarioQuestions before VerificationChecklist; no annotations (Intermediate)

## Decisions Made

- **Terraform CLI annotation pattern:** `tofu` is annotated as the base command, and each subcommand (`init`, `plan`, `apply`, `destroy`) is a separate token annotation — same convention as `docker` + `run`/`ps`/`stop` used in Phase 10.
- **Comment-line commands:** Steps in 01-iac-concepts use conceptual `#` comment commands (not real executable commands). Annotated the meaningful CLI tokens embedded in the comment strings (e.g., `docker stop`, `tofu plan`) following the Phase 10 pattern where all command fields require annotations.

## Deviations from Plan

None — plan executed exactly as written. TypeScript errors found in test files (`hooks/__tests__/`, `lib/__tests__/`) are pre-existing issues unrelated to 06-iac changes (missing `@types/jest`); no 06-iac-related TypeScript errors.

## Issues Encountered

The project linter reverted `01-iac-concepts.mdx` once during a Write operation. Resolved by using the Edit tool for targeted insertions, which the linter preserved correctly.

## Next Phase Readiness

- 06-iac module fully migrated with annotation pattern and ScenarioQuestions established
- Remaining Phase 11 plans (05+) can follow the same Terraform/OpenTofu annotation pattern
- Pre-existing test TypeScript errors (missing `@types/jest`) are out of scope for migration plans

---
*Phase: 11-full-content-migration*
*Completed: 2026-03-20*
