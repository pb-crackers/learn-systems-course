---
phase: 08-design-lock
plan: "02"
subsystem: content-policy
tags: [challenge-mode, foundation-safety-net, content-policy, audit, ExerciseCard, mdx]

requires:
  - phase: 08-design-lock/08-01
    provides: ExerciseCard interface contracts, CommandAnnotation schema, MDX prop pattern decision

provides:
  - "Challenge-mode goal-only format rule: challengePrompt-only display in compose mode, steps hidden"
  - "Reference sheet content policy: max 15 items, no sequential language, items do not name solution"
  - "Verification standard: min 3 items, each hint has runnable command and expected output"
  - "Foundation safety-net: hard override to guided mode — skip all mode prop and preference checks"
  - "Intermediate tier behavior: recall default, respects preferredMode, no DifficultyToggle rendered"
  - "Foundation command field count: 160 exact (22 lessons with ExerciseCard content)"
  - "Difficulty mismatch enumeration: 1 mismatch (05-cicd/05-cheat-sheet.mdx)"
affects:
  - "phase-09: ExerciseCard mode resolution implementation must match Foundation safety-net contract exactly"
  - "phase-10: prototype module authoring uses challenge-content-policy.md as template"
  - "phase-11: 160 command fields to annotate; module migration order recommended lightest-to-heaviest"

tech-stack:
  added: []
  patterns:
    - "Foundation exercises always resolve to guided mode — hard override at ExerciseCard level before any other check"
    - "DifficultyToggle rendered only on Challenge lessons (frontmatter.difficulty === Challenge)"
    - "ChallengeReferenceSheet: max 15 ReferenceItem entries, ReferenceSection groups, no sequential language"
    - "Verification hints: runnable command + expected output, minimum 3 per challenge exercise"

key-files:
  created:
    - docs/design/challenge-content-policy.md
    - docs/design/foundation-safety-net.md
    - docs/design/audit-results.md
  modified: []

key-decisions:
  - "Challenge exercises display challengePrompt (goal) only in compose mode — the steps array is authored for guided fallback but hidden in challenge rendering"
  - "Reference sheet hard cap is 15 items, not a soft guideline — enforces challenge integrity by requiring curatorial decisions"
  - "Foundation safety-net is a hard code override, not a preference default — difficulty === Foundation skips all prop and preference checks and returns guided immediately"
  - "Intermediate exercises use recall mode by default and DO respect preferredMode, but DifficultyToggle is Challenge-only"
  - "Foundation command field count is 160 (not ~200) — research over-estimated by 20%; Phase 11 scope is smaller than expected"
  - "Only 1 difficulty mismatch found (05-cicd/05-cheat-sheet.mdx) — research estimate of 5-10 was significantly over"

patterns-established:
  - "Goal-only format: challengePrompt describes observable outcome, not sequence of steps"
  - "No sequential language in reference sheets: forbidden words include First, Then, After, Before, Next, Finally"
  - "Verification items test end state, not process — observable outcomes only"
  - "Mode resolution priority: Foundation hard-override → explicit mode prop → learner preferredMode → difficulty default"

requirements-completed: [CHAL-02, CHAL-03, DIFF-03]

duration: 8min
completed: 2026-03-20
---

# Phase 8 Plan 02: Design Lock — Content Policy and Audit Summary

**Challenge content policy (goal-only format, 15-item reference cap, min-3 verification hints) and Foundation always-guided safety-net locked as authoring rules; Foundation command field count revised from ~200 to 160 across 22 lessons, 1 difficulty mismatch identified.**

## Performance

- **Duration:** 8 min
- **Started:** 2026-03-20T12:18:37Z
- **Completed:** 2026-03-20T12:26:19Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments

- Challenge content policy locked: goal-only format (challengePrompt-only in compose mode), reference sheet max 15 items with no sequential ordering language, verification standard of min 3 items each with runnable command and expected output
- Foundation safety-net rule locked: hard override to guided mode at ExerciseCard level, Implementation Contract for Phase 9 mode resolution logic included, DifficultyToggle NOT rendered on Foundation or Intermediate lessons
- Audit results: 160 Foundation command fields (exact grep, not estimate) across 22 lessons in 8 modules; research over-estimated by 20%; only 1 frontmatter/ExerciseCard difficulty mismatch found (05-cicd/05-cheat-sheet.mdx, frontmatter=Foundation, ExerciseCard=Intermediate)

## Task Commits

1. **Task 1: Challenge content policy and Foundation safety-net rule** - `0b9fc53` (docs)
2. **Task 2: Audit Foundation command counts and difficulty mismatches** - `b8cd375` (docs)

## Files Created/Modified

- `docs/design/challenge-content-policy.md` — Goal-only format rules, 15-item reference sheet cap, verification hint standards with ReferenceItem type reference
- `docs/design/foundation-safety-net.md` — Foundation hard-override rule with rationale, mode resolution implementation contract, DifficultyToggle gate behavior, Intermediate tier behavior
- `docs/design/audit-results.md` — 160 Foundation command fields (per-module breakdown table), 1 difficulty mismatch enumerated, Phase 11 module migration order recommended

## Decisions Made

- Challenge exercises author the full `steps` array even for challenge mode — provides guided fallback when learner toggles preferredMode to guided; the steps are hidden in compose mode but not omitted from MDX
- Reference sheet items must include some distractors (commands learner will not use) — removing this requirement would let the reference sheet become a solution hint list
- Foundation safety-net is a code-level override, not a preference config — this distinction is load-bearing for Phase 9 implementation: the check happens at the top of mode resolution, before any prop or preference lookup
- `'compose'` mode is not valid for Intermediate — if preferredMode is `'compose'` (set on a Challenge lesson) and the learner navigates to Intermediate, the resolved mode falls back to `'recall'`
- Audit excluded `00-template.mdx` (the lesson authoring template for 01-linux-fundamentals) from real lesson counts; it has 2 command fields but is not production content

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- `docs/design/challenge-content-policy.md` is ready for Phase 10 prototype content authoring reference
- `docs/design/foundation-safety-net.md` provides the exact Implementation Contract for Phase 9 ExerciseCard mode resolution
- `docs/design/audit-results.md` gives Phase 11 the exact command field count (160) and recommended module migration order (cloud → cicd → monitoring → iac → docker → sysadmin → networking → linux-fundamentals)
- The one mismatch (`05-cicd/05-cheat-sheet.mdx`) must be resolved before Phase 11 migrates the 05-cicd module

---
*Phase: 08-design-lock*
*Completed: 2026-03-20*
