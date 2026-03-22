# Roadmap: Learn Systems

## Milestones

- ✅ **v1.0 Learn Systems** — Phases 1-7 (shipped 2026-03-19)
- ✅ **v1.1 Command Pedagogy** — Phases 8-11 (shipped 2026-03-20)
- 🚧 **v1.2 Enhanced Questions** — Phases 12-15 (in progress)

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

<details>
<summary>✅ v1.1 Command Pedagogy (Phases 8-11) — SHIPPED 2026-03-20</summary>

- [x] Phase 8: Design Lock (2/2 plans) — completed 2026-03-20
- [x] Phase 9: Component Implementation (3/3 plans) — completed 2026-03-20
- [x] Phase 10: Linux Fundamentals Prototype (3/3 plans) — completed 2026-03-20
- [x] Phase 11: Full Content Migration (7/7 plans) — completed 2026-03-20

Full details: `.planning/milestones/v1.1-ROADMAP.md`

</details>

### 🚧 v1.2 Enhanced Questions (In Progress)

**Milestone Goal:** Add multiple-choice knowledge quizzes to every lesson that gate progression and reinforce learning through retrieval practice.

## Phases (v1.2)

- [x] **Phase 12: Schema and Progress Foundation** - Lock quiz types, extend LessonProgress, implement grandfather rule (completed 2026-03-22)
- [x] **Phase 13: Quiz Component Build** - Build LessonQuiz state machine and leaf components with full test coverage (completed 2026-03-22)
- [ ] **Phase 14: Layout Integration and Gating** - Wire quiz into LessonLayout, retire MarkCompleteButton, validate end-to-end on one lesson
- [ ] **Phase 15: Content Authoring** - Author 7-10 quiz questions for all 56 lessons

## Phase Details

### Phase 12: Schema and Progress Foundation
**Goal**: Types, schema, and progress extension are locked so all quiz components have stable contracts to build against
**Depends on**: Phase 11 (v1.1 complete)
**Requirements**: DATA-01, DATA-02, GATE-02, GATE-03
**Success Criteria** (what must be TRUE):
  1. `types/quiz.ts` exports `QuizQuestion` (id, question, options[4], correctIndex, explanation) and `QuizPhase` — `tsc --noEmit` passes with zero errors
  2. `LessonProgress` has three new optional fields (`quizPassed?: boolean`, `quizPassedAt?: string`, `quizAttempts: number`) and `ProgressState.version` is bumped to `2`
  3. `isLessonComplete` returns `true` for any lesson record with `completed: true` and no `quizPassed` field — no pre-v1.2 progress is silently reset
  4. Lessons without quiz data (`quiz === null`) retain their existing completion behavior — `MarkCompleteButton` still works for them
  5. `markQuizPassed` and `isQuizPassed` are present on `ProgressContextValue` and the TypeScript interface compiles cleanly
**Plans**: 1 plan

Plans:
- [ ] 12-01-PLAN.md — Create quiz types, extend progress schema, add context methods

### Phase 13: Quiz Component Build
**Goal**: Users can interact with a fully working quiz — selecting answers, receiving feedback, retaking on failure, and seeing a pass screen — using fixture data
**Depends on**: Phase 12
**Requirements**: QUIZ-01, QUIZ-02, QUIZ-03, QUIZ-04, QUIZ-05, QUIZ-06
**Success Criteria** (what must be TRUE):
  1. Selecting a wrong answer shows "Incorrect" feedback with no correct answer revealed and the quiz resets to question 1 on retake
  2. Selecting the correct answer shows an explanation paragraph and the learner can advance to the next question
  3. The attempt counter increments and is visible in the UI each time the learner retakes the quiz
  4. After answering all questions correctly, the user sees a pass screen and a "Continue to Next Lesson" button
  5. All state machine transitions (idle, active, passed, failed) are covered by Vitest unit tests with no failures
**Plans**: 1 plan

Plans:
- [ ] 13-01-PLAN.md — Quiz reducer (TDD) + component UI with integration tests

### Phase 14: Layout Integration and Gating
**Goal**: The quiz is live in every lesson page, completion requires passing the quiz, and the manual complete button is gone for quizzed lessons
**Depends on**: Phase 13
**Requirements**: LAYOUT-01, LAYOUT-02, GATE-01
**Success Criteria** (what must be TRUE):
  1. The quiz renders below the hands-on exercise on any lesson page whose MDX exports a `quiz` named export — placement is consistent across all lessons
  2. Quiz data flows from MDX named export through `getLessonContent` and `page.tsx` props into `LessonLayout` without any change to the MDX build pipeline
  3. `MarkCompleteButton` is absent from any lesson that has quiz data — the only way to mark those lessons complete is to pass the quiz
  4. On a single end-to-end test lesson, passing the quiz fires `markLessonComplete` and the lesson appears complete in the progress sidebar
**Plans**: 1 plan

Plans:
- [ ] 14-01-PLAN.md — Wire quiz into layout pipeline, gate MarkCompleteButton, add test lesson quiz data

### Phase 15: Content Authoring
**Goal**: Every lesson in all 8 modules has a valid, high-quality quiz so the gating system is fully operational across the entire course
**Depends on**: Phase 14
**Requirements**: DATA-03
**Success Criteria** (what must be TRUE):
  1. All 56 lesson MDX files export a `quiz` array with 7-10 questions and every question has a prompt, four options, correct index, and explanation
  2. Every quiz question passes TypeScript type-checking — `tsc --noEmit` has zero errors after full authoring
  3. A learner can navigate to any lesson in any module and take a complete quiz — no lesson is missing quiz data
  4. Each module's quiz questions are reviewed for quality (plausible distractors, mechanism-explaining explanations, accurate correct answers) before moving to the next module
**Plans**: TBD

Plans:
- [ ] 15-01: TBD

## Progress

**Execution Order:** 12 → 13 → 14 → 15

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. App Foundation | v1.0 | 4/4 | Complete | 2026-03-19 |
| 2. Linux Fundamentals | v1.0 | 4/4 | Complete | 2026-03-19 |
| 3. Networking Foundations | v1.0 | 4/4 | Complete | 2026-03-19 |
| 4. Docker & Foundation Capstone | v1.0 | 4/4 | Complete | 2026-03-19 |
| 5. System Administration & CI/CD | v1.0 | 4/4 | Complete | 2026-03-19 |
| 6. Infrastructure as Code & Cloud | v1.0 | 4/4 | Complete | 2026-03-19 |
| 7. Monitoring & Advanced Capstone | v1.0 | 3/3 | Complete | 2026-03-19 |
| 8. Design Lock | v1.1 | 2/2 | Complete | 2026-03-20 |
| 9. Component Implementation | v1.1 | 3/3 | Complete | 2026-03-20 |
| 10. Linux Fundamentals Prototype | v1.1 | 3/3 | Complete | 2026-03-20 |
| 11. Full Content Migration | v1.1 | 7/7 | Complete | 2026-03-20 |
| 12. Schema and Progress Foundation | 1/1 | Complete    | 2026-03-22 | - |
| 13. Quiz Component Build | 1/1 | Complete    | 2026-03-22 | - |
| 14. Layout Integration and Gating | v1.2 | 0/1 | Not started | - |
| 15. Content Authoring | v1.2 | 0/? | Not started | - |

---
*Roadmap created: 2026-03-18*
*v1.0 shipped: 2026-03-19 — 7 phases, 27 plans, 80 requirements*
*v1.1 shipped: 2026-03-20 — 4 phases, 15 plans, 20 requirements*
*v1.2 roadmap added: 2026-03-22 — 4 phases (12-15), 14 requirements*
