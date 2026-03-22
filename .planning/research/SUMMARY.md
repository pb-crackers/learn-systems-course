# Project Research Summary

**Project:** learn-systems v1.2 — Multiple-Choice Quiz System
**Domain:** Quiz/assessment retrofit onto an existing MDX-based interactive DevOps course
**Researched:** 2026-03-22
**Confidence:** HIGH

## Executive Summary

v1.2 adds a multiple-choice quiz system to an existing Next.js 16 / React 19 / MDX course platform that already has 56 authored lessons, a localStorage-backed progress system, and hands-on exercises. The core technical finding is that zero new npm packages are required: every capability needed (state management, localStorage persistence, UI primitives, icons, animation, testing) is already installed and verified in the codebase. The entire feature reduces to four internal deliverables — new TypeScript types, three new React components, targeted ProgressProvider extensions, and quiz data authored in MDX named exports.

The recommended architecture is a client-side state machine (`LessonQuiz` orchestrator with `QuizQuestion` and `QuizResult` leaf components) that plugs into the existing `ProgressContext`. Quiz data lives as an `export const quiz = [...]` named export in each lesson's MDX file — co-located with lesson prose, type-checked, and extracted via dynamic import in `lib/mdx.ts` without any change to the MDX build pipeline. Lesson completion is re-routed: quiz pass becomes the only completion trigger, replacing the manual `MarkCompleteButton` for lessons that have quizzes. The no-correct-answer-reveal-on-failure pattern is a deliberate pedagogical choice (KRF-only feedback produces stronger long-term retention than KCRF) and a deliberate departure from Duolingo and Codecademy's defaults.

The highest-effort work item is not code — it is content authoring: 56 lessons × 7–10 questions = 392–560 questions, each requiring a prompt, four options (three plausible distractors), and an explanation. The single largest risk is quality drift across that volume of questions. The second-largest risk is failing to grandfather existing completed lessons, which would silently reset a real learner's 100% progress to 0% on upgrade. Both risks must be addressed at the design-phase decision level before any component is written.

---

## Key Findings

### Recommended Stack

Zero new dependencies. The existing stack already covers every quiz requirement: `useState` for the session state machine, `useLocalStorage<T>` (SSR-safe, already written) for persistence, `ProgressContext` for cross-component quiz-gate checks, `Button`/`Badge`/`Progress` from `@base-ui/react` for UI, `lucide-react` for feedback icons (`CheckCircle2`, `XCircle`, `RotateCcw`), `tw-animate-css` for transitions, and Vitest + Testing Library for unit tests. See [STACK.md](.planning/research/STACK.md) for full verified inventory.

**Core technologies (all existing):**
- `useState` / `useReducer` — quiz session state machine in `LessonQuiz`; no external state library needed
- `useLocalStorage<T>` from `hooks/useLocalStorage.ts` — persist `quizPassed` flag, SSR-safe with `isHydrated` guard
- `ProgressContext` / `ProgressProvider` — central persistence layer; extend with `markQuizPassed` and `isQuizPassed`
- `gray-matter` 4.0.3 + `@next/mdx` — MDX named export extraction; zero pipeline changes required
- `@base-ui/react` 1.3.0 — `Button`, `Badge`, `Progress` for quiz UI; already used throughout the app
- Vitest 4.1.0 + `@testing-library/react` 16.3.2 — state machine unit tests and component integration tests

**What NOT to add:** any quiz library (opinionated DOM, fights existing design system), Zustand/Jotai (quiz session state is component-local; persistence goes through existing `ProgressContext`), Framer Motion (`tw-animate-css` already installed), `react-hook-form` (quiz is a state machine, not a form), `@radix-ui` primitives (project uses `@base-ui/react` exclusively).

### Expected Features

**Must have — v1.2 (table stakes):**
- Multiple-choice question rendering, 7–10 questions per lesson, single selection per question
- Wrong answer: "Incorrect" label only, no correct-answer reveal, full quiz retake from Q1
- Correct answer: explanation paragraph shown, learner confirms to advance to next question
- 100% pass gate — quiz pass is the only path to lesson completion for quizzed lessons
- `quizPassed?: boolean` + `quizAttempts: number` + `quizPassedAt?: string` added to `LessonProgress`
- `MarkCompleteButton` removed from lessons that have a quiz (quiz pass fires `markLessonComplete` internally)
- Quiz data authored for all 56 lessons (7–10 questions each with explanations)
- Quiz positioned below hands-on exercise, above the completion action
- Grandfather rule: lessons already `completed: true` with no `quizPassed` field remain complete after upgrade

**Should have — v1.2.x (add after base flow validated):**
- "Continue to Next Lesson" CTA rendered after quiz pass — requires next-lesson lookup from `modules.ts`
- Exercise-completion lock on quiz (`exercisesCompleted.length > 0` heuristic) — enforces "do before quiz"
- Attempt count display in the quiz UI

**Defer — v2+:**
- Spaced repetition review mode (separate scheduling logic, separate review UI)
- Question-level analytics (requires aggregation beyond per-user localStorage)
- Adaptive follow-up questions on first-attempt pass (high authoring and logic overhead)
- Score display, partial credit, timers, question bank randomization (all classified as anti-features)

The no-reveal-on-failure pattern is a deliberate departure from all major competitors and is grounded in retrieval practice research. See [FEATURES.md](.planning/research/FEATURES.md) for competitor analysis and research citations.

### Architecture Approach

The quiz system integrates at the layout level, not the MDX component level. Quiz data flows: MDX named export → `getLessonContent()` in `lib/mdx.ts` → `page.tsx` prop → `LessonLayout` prop → `LessonQuiz` component. `LessonQuiz` owns the state machine (`idle → active → passed | failed`) and is the only new `ProgressContext` consumer. `QuizQuestion` and `QuizResult` are pure prop-driven leaf components with no context reads. The `LessonProgress` type extension uses optional fields, making existing localStorage records valid without a migration script — `undefined` is treated as `false` for `quizPassed`.

**Major components:**

| File | Status | Responsibility |
|------|--------|----------------|
| `types/quiz.ts` | NEW | `QuizQuestion` interface (`id`, `question`, `options[4]`, `correctIndex`, `explanation`), `QuizPhase` type |
| `components/quiz/LessonQuiz.tsx` | NEW | State machine orchestrator; phases: `idle`, `active`, `passed`, `failed` |
| `components/quiz/QuizQuestion.tsx` | NEW | Single question renderer; pure props, no context reads |
| `components/quiz/QuizResult.tsx` | NEW | Pass/fail end screen; pure props |
| `components/progress/ProgressProvider.tsx` | MODIFIED | Adds `markQuizPassed`, `isQuizPassed`; `markLessonComplete` called from within `markQuizPassed` |
| `components/lesson/LessonLayout.tsx` | MODIFIED | Accepts `quiz` prop; renders `LessonQuiz`; gates `MarkCompleteButton` |
| `lib/mdx.ts` | MODIFIED | Extracts `mod.quiz ?? null` from MDX dynamic import |
| `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` | MODIFIED | Passes `quiz` from `getLessonContent` to `LessonLayout` |

**No-touch files (confirmed by inspection):** `next.config.ts`, `mdx-components.tsx`, `hooks/useLocalStorage.ts`, `types/content.ts`, all `components/content/*`, `PrerequisiteBanner`, `lib/modules.ts`, `lib/progress.ts`, `ScrollProgressBar`, `TableOfContents`.

See [ARCHITECTURE.md](.planning/research/ARCHITECTURE.md) for full data flow diagrams and anti-pattern documentation.

### Critical Pitfalls

1. **Gating bypass — `MarkCompleteButton` left active alongside quiz** — Two completion paths means learners skip the quiz by clicking the manual button. Remove `MarkCompleteButton` from `LessonLayout` for lessons that have a quiz. `markLessonComplete` must only be callable via `markQuizPassed`. Lock this rule before any component is written; fixing it after content migration requires auditing all 56 lessons.

2. **Existing progress silently reset to 0%** — Lessons with `completed: true` and no `quizPassed` field (all pre-v1.2 progress records) must be grandfathered as complete. Implement as `completed && (quizPassed !== false)` in `isLessonComplete`. Missing this resets a real learner's full progress on upgrade. Bump `ProgressState.version` to `2` as a forward migration signal.

3. **Wrong-answer UX reveals the correct answer** — Every quiz tutorial and quiz library defaults to showing the correct answer on failure. The requirement is the opposite: show only "Incorrect" with no hint. Write the quiz state machine spec (three states: `wrong` — retake only; `correct-partial` — explanation shown; `all-passed` — lesson unlocked) before implementing any feedback UI and review the rendered component against it.

4. **`isHydrated` guard missing in new progress-reading components** — Every component that renders UI conditioned on progress state must check `isHydrated` before evaluating locked/unlocked status. Missing this causes a "all lessons unlocked" flash on page load. The existing `MarkCompleteButton` is the pattern to replicate in all new quiz-gating components.

5. **Quiz content quality drift across 56 lessons** — 400–560 questions authored sequentially will be strong at the start and weak at the end without a written standard and module-by-module review checkpoints. Write a 4–5 rule authoring guide (specific prompts, plausible distractors, mechanism-explaining explanations, consistent code formatting) before authoring any questions. Work module-by-module: complete all questions for module 1, review, then move to module 2.

See [PITFALLS.md](.planning/research/PITFALLS.md) for full pitfall inventory, recovery strategies, and the "looks done but isn't" checklist.

---

## Implications for Roadmap

### Phase 1: Foundation — Types, Schema, and Progress Extension

**Rationale:** All quiz components have hard TypeScript dependencies on `types/quiz.ts` and the extended `LessonProgress`. The `LessonProgress` schema change and the grandfather rule are the load-bearing decisions that all other phases build on. Getting them wrong cascades rework across 56 lesson files. This phase has zero UI — it is pure type system and context work, fully validatable with `tsc --noEmit` before any component is written. All nine pitfalls from PITFALLS.md that are classified as "design phase" preventions live here.

**Delivers:**
- `types/quiz.ts`: `QuizQuestion` (id, question, options[4], correctIndex, explanation), `QuizPhase`
- `types/progress.ts` extended: `quizPassed?: boolean`, `quizPassedAt?: string`, `quizAttempts: number` added to `LessonProgress`
- `ProgressState.version` bumped from `1` to `2`
- `markQuizPassed(lessonId)` and `isQuizPassed(lessonId)` added to `ProgressProvider` and `ProgressContextValue`
- Grandfather rule implemented in `isLessonComplete`: `completed && (quizPassed !== false)`
- Quiz state machine spec written (three result states; wrong-answer-no-reveal locked in writing)

**Avoids:** Pitfalls 1 (bypass), 2 (progress reset), 3 (answer reveal), 5 (type mismatch), 7 (grandfather).

### Phase 2: Quiz Component Build

**Rationale:** With types and context locked, the three new quiz components can be built and tested in isolation before any MDX data exists. Leaf components (`QuizQuestion`, `QuizResult`) have no context reads and can be developed with mock props and Vitest unit tests. `LessonQuiz` can be tested against a static fixture question array. The `isHydrated` guard pattern on all progress-reading UI must be applied here — it is easier to enforce before the component ships than to audit afterward.

**Delivers:**
- `components/quiz/QuizQuestion.tsx` — four-option single-selection renderer; explanation-on-correct; no correct-answer reveal on wrong
- `components/quiz/QuizResult.tsx` — pass screen (lesson unlocked message) and fail screen (retake prompt only; no score breakdown)
- `components/quiz/LessonQuiz.tsx` — state machine orchestrator: `idle → active → passed | failed`; calls `markQuizPassed` on 100%; calls `markLessonComplete` via `markQuizPassed` internally
- Vitest unit tests for state machine logic; Testing Library integration tests for click-through flow
- `isHydrated` guard verified on all progress-reading UI in quiz components

**Uses:** `@base-ui/react` Button/Badge/Progress, `lucide-react` `CheckCircle2`/`XCircle`/`RotateCcw`, `tw-animate-css` for state transitions.
**Avoids:** Pitfalls 3 (answer reveal — wrong-answer branch has no correct-answer string), 4 (randomization — fixed order, no `Math.random()` during render), 9 (hydration guard).

### Phase 3: Layout Integration and Data Pipeline

**Rationale:** Integrating the quiz into `LessonLayout` and wiring the MDX named export pipeline requires modifying four existing files — the highest-risk code changes in the milestone. Doing this after components are built and tested means integration work is plumbing with known-good components. The critical gate: validate the full pipeline end-to-end on one lesson before bulk authoring begins. Discovering a data extraction problem after 400+ questions are authored requires reworking all of them.

**Delivers:**
- `lib/mdx.ts` modified: `quiz: mod.quiz ?? null` extracted from MDX dynamic import
- `page.tsx` modified: `quiz` passed as prop to `LessonLayout`
- `LessonLayout` modified: `LessonQuiz` rendered below `MDXContent` when `quiz !== null`; `MarkCompleteButton` removed for quizzed lessons (kept for lessons pending quiz authoring via `quiz === null` path)
- One complete lesson validated end-to-end: MDX named export → component → quiz pass → `markLessonComplete` triggered

**Implements:** MDX Named Export pattern (not frontmatter, not separate files); layout-level quiz positioning.
**Avoids:** Pitfalls 1 (button bypass — removed here), 6 (inline JSX quiz data), anti-patterns from ARCHITECTURE.md.

### Phase 4: Content Authoring — All 56 Lessons

**Rationale:** Content authoring is the highest-volume, highest-effort phase and is intentionally last so the data format is fully validated on one lesson before bulk authoring begins. Module-by-module discipline with per-module review prevents quality drift. The authoring guide must be written as part of Phase 1 planning, not improvised during authoring.

**Delivers:**
- `export const quiz = [...]` in all 56 lesson MDX files; 7–10 questions per lesson
- Each question: specific unambiguous prompt, four options (three plausible distractors), correct index, mechanism-explaining explanation
- Per-module review pass before moving to the next module
- End-to-end testing of all 56 lessons after authoring completes

**Avoids:** Pitfall 8 (quality drift — module-by-module authoring + review); Pitfall 6 (inline JSX — questions as named exports, not JSX props); batch migration pitfall (one module at a time, not all 56 at once).

### Phase 5: v1.2.x Polish (Post-Validation)

**Rationale:** These features add value but depend on the base quiz flow being stable and working across all 56 lessons. Shipping them as a follow-up prevents scope creep from delaying the core milestone.

**Delivers:**
- "Continue to Next Lesson" CTA after quiz pass (uses existing `lib/modules.ts` next-lesson lookup)
- Exercise-completion lock on quiz (`exercisesCompleted.length > 0` check — after confirming consistent population across all modules)
- Attempt count display in quiz UI

### Phase Ordering Rationale

- Types before components: `types/quiz.ts` and extended `LessonProgress` are the contracts that all quiz components depend on. TypeScript enforces this — components will not compile without the types.
- Components before layout integration: `LessonQuiz`, `QuizQuestion`, and `QuizResult` must exist before `LessonLayout` can render them.
- One-lesson validation before bulk authoring: validates the MDX named export data pipeline before committing to 400–560 questions. A data extraction bug discovered after full authoring requires reworking all 56 files.
- `MarkCompleteButton` removal happens in Phase 3 (layout integration), not Phase 2 (component build): the button should only be removed once the quiz completion path is verified working in the actual layout — not before.
- Phase 5 is explicitly post-validation: the "Continue to Next Lesson" CTA and exercise lock need the base quiz working correctly across all lessons before adding dependencies on adjacent system behavior.

### Research Flags

Phases with standard, well-documented patterns (research-phase not needed):
- **Phase 1 (Types/Schema):** TypeScript optional field extension and localStorage backward compatibility are established patterns; the grandfather rule is fully specified in PITFALLS.md.
- **Phase 2 (Component Build):** Client-side `useState` state machine with existing UI primitives; all component patterns already present in the codebase (`ScenarioQuestion.tsx` is the direct precedent for inline interactive components).
- **Phase 3 (Layout Integration):** MDX named export extraction is documented in ARCHITECTURE.md with exact code; the `lib/mdx.ts` dynamic import pattern is already established.

Phases that benefit from explicit planning artifacts (not code research):
- **Phase 4 (Content Authoring):** The authoring guide (4–5 concrete rules: prompt specificity, distractor plausibility, explanation depth, code formatting convention, learner knowledge assumption) must be written as a planning artifact before authoring begins. The module-by-module review cadence should be explicit roadmap tasks, not implied.
- **Phase 5 (v1.2.x):** The exercise-lock heuristic (`exercisesCompleted.length > 0`) needs validation that this field is populated consistently across all 56 lessons before the feature is surfaced. Do a quick audit before Phase 5 planning.

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All package versions confirmed by direct `package.json` inspection; all API surfaces verified against live source files; zero external library evaluation needed |
| Features | HIGH (core mechanics), MEDIUM (UX patterns) | Completion gating, wrong-answer behavior, and persistence verified against live codebase; competitor UX patterns and retrieval-practice research are peer-reviewed but secondary sources |
| Architecture | HIGH | All integration points verified by reading the actual source files (listed in ARCHITECTURE.md Sources); data flow diagrams grounded in live code, not inference |
| Pitfalls | HIGH | Pitfalls derived from direct inspection of the existing progress/completion system; the grandfather rule, hydration guard, and bypass pitfall are confirmed issues from v1.1 patterns |

**Overall confidence:** HIGH

### Gaps to Address

- **Quiz authoring guide:** Research recommends the guide but does not write it. It must be produced as a planning artifact in Phase 1 before any authoring begins. Four to five concrete rules, not a treatise.
- **Exercise completion consistency:** Before shipping the exercise-lock feature (Phase 5), audit that `exercisesCompleted` is populated for exercises across all 56 lessons. FEATURES.md recommends `exercisesCompleted.length > 0` as a heuristic precisely because per-exercise-ID coverage has not been audited.
- **"Continue to Next Lesson" UX:** Whether the CTA replaces or supplements the retake prompt after quiz pass is a UX decision not resolved in research. Decide during Phase 5 planning.

---

## Sources

### Primary (HIGH confidence — direct codebase inspection)

- `package.json` — all installed package versions confirmed
- `hooks/useLocalStorage.ts` — SSR-safe hook with `isHydrated` guard pattern
- `components/progress/ProgressProvider.tsx` — `ProgressContextValue` interface, existing action pattern
- `types/progress.ts` — `LessonProgress`, `ProgressState`, `version: 1`, `PROGRESS_STORAGE_KEY`
- `types/content.ts` — `LessonFrontmatter`
- `components/lesson/LessonLayout.tsx` — `QuizCard` insertion point, existing color tokens
- `components/lesson/MarkCompleteButton.tsx` — `isHydrated` guard pattern
- `components/content/ScenarioQuestion.tsx` — `useState` expand/collapse pattern for inline interactive components
- `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` — server component rendering pattern
- `lib/mdx.ts` — `getLessonContent`, dynamic import pattern
- `content/modules/01-linux-fundamentals/01-how-computers-work.mdx` — representative lesson structure
- `.planning/PROJECT.md` — v1.2 requirements (100% score gate, wrong-answer no-reveal, quiz-gated completion)

### Secondary (MEDIUM confidence — pedagogy and UX research)

- [Frontiers in Psychology — Effects of Different Feedback Types on Quiz Learning](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2021.665144/full) — KRF vs. KCRF feedback comparison
- [PMC — Retrieval practice and wrong-answer feedback](https://pmc.ncbi.nlm.nih.gov/articles/PMC10060135/) — deferred feedback preserves desirable difficulty
- [PMC — Mastery Learning review](https://pmc.ncbi.nlm.nih.gov/articles/PMC10159400/) — 100% mastery gate rationale
- [Improving Teaching — Questioning for retrieval: five mistakes to avoid](https://improvingteaching.co.uk/2023/04/23/questioning-for-retrieval-five-mistakes-to-avoid/) — multiple-choice anti-patterns
- [Max Maier, Medium — Finding the best pattern for quiz feedback](https://medium.com/@maxmaier/finding-the-best-pattern-for-quiz-feedback-9e174b8fd6b8)
- [TrueLearn — Retaking practice questions and memory retention](https://truelearn.com/resource-library/retaking-practice-questions-is-key-to-better-memory-retention-in-healthcare-education/)
- [IES REL Southeast — CBE Mastery Framework, 2025](https://ies.ed.gov/rel-southeast/2025/01/cbe-mastery-framework)
- [React docs — `Math.random()` key warning](https://react.dev/learn/rendering-lists#keeping-list-items-in-order-with-key) — shuffle-during-render anti-pattern

---
*Research completed: 2026-03-22*
*Ready for roadmap: yes*
