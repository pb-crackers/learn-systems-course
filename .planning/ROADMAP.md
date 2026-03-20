# Roadmap: Learn Systems

## Milestones

- ✅ **v1.0 Learn Systems** — Phases 1-7 (shipped 2026-03-19)
- 🚧 **v1.1 Command Pedagogy** — Phases 8-11 (in progress)

## Phases

<details>
<summary>✅ v1.0 Learn Systems (Phases 1-7) — SHIPPED 2026-03-19</summary>

- [x] Phase 1: App Foundation (4/4 plans) — completed 2026-03-19
- [x] Phase 2: Linux Fundamentals (4/4 plans) — completed 2026-03-19
- [x] Phase 3: Networking Foundations (4/4 plans) — completed 2026-03-19
- [x] Phase 4: Docker & Foundation Capstone (4/4 plans) — completed 2026-03-19
- [x] Phase 5: System Administration & CI/CD (4/4 plans) — completed 2026-03-19
- [x] Phase 6: Infrastructure as Code & Cloud (4/4 plans) — completed 2026-03-19
- [x] Phase 7: Monitoring & Advanced Capstone (3/3 plans) — completed 2026-03-19

Full details: `.planning/milestones/v1.0-ROADMAP.md`

</details>

### 🚧 v1.1 Command Pedagogy (In Progress)

**Milestone Goal:** Transform CLI exercises from copy-paste instructions into active learning experiences — annotated commands for Foundation tier, challenge-mode exercises for Intermediate/Challenge tier, and scenario-contextualized questions throughout. Applied consistently across all 8 modules.

- [x] **Phase 8: Design Lock** — Lock all interface contracts, annotation schema, and content policy before any code is written (completed 2026-03-20)
- [ ] **Phase 9: Component Implementation** — Build all new components and modify ExerciseCard in bottom-up dependency order
- [x] **Phase 10: Linux Fundamentals Prototype** — Migrate one complete module to validate the schema and authoring pattern end-to-end (completed 2026-03-20)
- [ ] **Phase 11: Full Content Migration** — Apply validated patterns across all remaining modules (7 modules, ~42 lessons)

## Phase Details

### Phase 8: Design Lock
**Goal**: All interface contracts, data schemas, and content policies are locked in writing before any code or content is authored
**Depends on**: Phase 7 (v1.0 complete)
**Requirements**: ANNO-02, CHAL-02, CHAL-03, DIFF-03, DIFF-04
**Success Criteria** (what must be TRUE):
  1. The `CommandAnnotation` TypeScript type is defined with field names, types, and character limits documented
  2. The annotation display policy (always-visible, static, never tooltip) is written into a style guide that authors can follow
  3. The challenge content policy is written: goal-only format means no procedural steps, reference sheet capped at 15 items with no sequential ordering language
  4. The Foundation safety-net rule is documented: Foundation exercises are always guided regardless of any global preference toggle
  5. The localStorage key for preference (`'learn-systems-preferences'`) and its shape are specified and separate from the progress key
**Plans:** 2/2 plans complete

Plans:
- [ ] 08-01-PLAN.md — Type contracts, annotation style guide, and preference specification
- [ ] 08-02-PLAN.md — Challenge content policy, Foundation safety-net rule, and content audit

### Phase 9: Component Implementation
**Goal**: All new components compile and the ExerciseCard renders correctly for all three difficulty tiers on a test page
**Depends on**: Phase 8
**Requirements**: ANNO-01, ANNO-03, CHAL-01, CHAL-04, DIFF-01, DIFF-02, SCEN-01, SCEN-02, SCEN-03
**Success Criteria** (what must be TRUE):
  1. A Foundation ExerciseCard step displays a copyable command followed by a visible per-flag annotation panel (no hover required, no clicks to expand)
  2. An Intermediate ExerciseCard step shows its description text but the command is not rendered — the learner must recall or look up the syntax
  3. A Challenge ExerciseCard shows only the goal prompt and a ChallengeReferenceSheet; the numbered step list is not rendered
  4. A global difficulty toggle appears on Challenge-difficulty lessons and persists the learner's preference across page navigations in localStorage
  5. A ScenarioQuestion block renders between command steps with an expandable answer reveal, and its question text explicitly references the exercise's opening scenario
**Plans:** 2/3 plans executed

Plans:
- [ ] 09-01-PLAN.md — Preferences context extension and AnnotatedCommand component
- [ ] 09-02-PLAN.md — ScenarioQuestion and ChallengeReferenceSheet components
- [ ] 09-03-PLAN.md — ExerciseCard mode-aware rendering, DifficultyToggle, LessonLayout integration, MDX registration

### Phase 10: Linux Fundamentals Prototype
**Goal**: The Linux Fundamentals module (module 02) is fully migrated and every difficulty tier works correctly end-to-end in the live application
**Depends on**: Phase 9
**Requirements**: MIGR-06
**Success Criteria** (what must be TRUE):
  1. Every Foundation exercise in Linux Fundamentals has per-flag annotations visible below each command — no command block is unannotated
  2. Every Intermediate exercise in Linux Fundamentals shows step descriptions without commands, and every Challenge exercise shows goal-only with a reference sheet
  3. Every exercise in Linux Fundamentals has at least one ScenarioQuestion that connects the command to the opening scenario's context
  4. `next build` completes with zero errors and zero TypeScript type errors after the Linux Fundamentals migration
**Plans:** 3/3 plans complete

Plans:
- [ ] 10-01-PLAN.md — Annotate Foundation lessons 01-02 (hardware + OS) with command annotations and ScenarioQuestions
- [ ] 10-02-PLAN.md — Annotate Foundation lessons 03-04 (filesystem + permissions) with command annotations and ScenarioQuestions
- [ ] 10-03-PLAN.md — Add ScenarioQuestions to all 5 Intermediate lessons and validate full module build

### Phase 11: Full Content Migration
**Goal**: All 8 modules have consistent command pedagogy — annotated Foundation commands, recall-driven Intermediate steps, goal-only Challenge prompts, and scenario questions throughout
**Depends on**: Phase 10
**Requirements**: MIGR-01, MIGR-02, MIGR-03, MIGR-04, MIGR-05
**Success Criteria** (what must be TRUE):
  1. Every Foundation lesson across all 8 modules (~22 lessons) has per-flag annotations co-located in each step's object — no Foundation command block is unannotated
  2. Every Intermediate lesson across all 8 modules (~20 lessons) has step descriptions that are actionable without seeing the command — no command is rendered for Intermediate steps
  3. Every Challenge and capstone exercise has a scoped reference sheet (max 15 items) and at least 3 verification items with runnable commands and expected output in the hint field
  4. Every exercise across all modules includes at least one ScenarioQuestion linking command execution back to the opening scenario
  5. `next build` passes for each module after its migration is complete — no batch build, no deferred errors
**Plans**: TBD

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. App Foundation | v1.0 | 4/4 | Complete | 2026-03-19 |
| 2. Linux Fundamentals | v1.0 | 4/4 | Complete | 2026-03-19 |
| 3. Networking Foundations | v1.0 | 4/4 | Complete | 2026-03-19 |
| 4. Docker & Foundation Capstone | v1.0 | 4/4 | Complete | 2026-03-19 |
| 5. System Administration & CI/CD | v1.0 | 4/4 | Complete | 2026-03-19 |
| 6. Infrastructure as Code & Cloud | v1.0 | 4/4 | Complete | 2026-03-19 |
| 7. Monitoring & Advanced Capstone | v1.0 | 3/3 | Complete | 2026-03-19 |
| 8. Design Lock | 2/2 | Complete   | 2026-03-20 | - |
| 9. Component Implementation | 2/3 | In Progress|  | - |
| 10. Linux Fundamentals Prototype | 3/3 | Complete   | 2026-03-20 | - |
| 11. Full Content Migration | v1.1 | 0/TBD | Not started | - |

---
*Roadmap created: 2026-03-18*
*v1.0 shipped: 2026-03-19 — 7 phases, 27 plans, 80 requirements*
*v1.1 roadmap added: 2026-03-20 — 4 phases (8-11), 20 requirements*
