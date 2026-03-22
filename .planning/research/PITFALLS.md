# Pitfalls Research

**Domain:** Quiz/Assessment System Retrofit — Multiple-Choice Knowledge Quizzes for Existing MDX Course Platform
**Researched:** 2026-03-22
**Confidence:** HIGH (grounded in direct codebase inspection of all relevant files + instructional design literature; supplemented by web research on localStorage/SSR patterns)

---

## Critical Pitfalls

### Pitfall 1: The ProgressState Gating Race Condition — Marking Lesson Complete Before Quiz Passes

**What goes wrong:**
The current `MarkCompleteButton` calls `markLessonComplete(lessonId)` on click, and `ProgressState.lessons[lessonId].completed` is the single source of truth for whether a lesson is done. If the quiz is added as a separate component that also calls `markLessonComplete` on quiz pass, there are now two code paths that can mark a lesson complete — the button (which has no quiz gate) and the quiz (which does). Any developer who forgets to gate the button behind quiz completion will let learners bypass the quiz entirely by clicking "Mark as Complete."

More subtly: localStorage reads are async after hydration. If the quiz-passed state is stored separately and the `isHydrated` guard returns `false` briefly on page load, a client-side redirect that gates lesson N+1 on lesson N's completion will use stale progress data for a render cycle, briefly showing N+1 as unlocked before snapping to locked. The learner sees a flash and wonders if they found a bug.

**Why it happens:**
The existing `MarkCompleteButton` is wired directly to `markLessonComplete` with no preconditions — it was designed for a world where the button is the only completion mechanism. Adding a quiz requirement means this button's behavior must change, but it is used in `LessonLayout` which renders for all 56 lessons. It is easy to add quiz state in isolation and forget to update the button's gate logic.

**How to avoid:**
- Remove `MarkCompleteButton` as a standalone completion mechanism. Quiz pass is the only completion trigger. The button either becomes "Submit Quiz" or is removed entirely.
- The `markLessonComplete` function in `ProgressProvider` must only be callable after `quizPassed(lessonId) === true`. Enforce this inside the function or in the quiz component, not as a UI gate that can be bypassed.
- Extend `LessonProgress` in `types/progress.ts` to include `quizPassed?: boolean` before writing any quiz UI. The schema change is the contract.
- The `isHydrated` guard already exists in `ProgressProvider` — any component rendering lesson-unlock state must gate on `isHydrated` before evaluating locked/unlocked status.

**Warning signs:**
- `MarkCompleteButton` still renders in lesson pages that also have a quiz
- `markLessonComplete` can be called without checking quiz state
- Lesson N+1 shows a brief "unlocked" flash before settling to "locked" on page load

**Phase to address:**
Design phase. The `LessonProgress` schema extension and the rule "quiz pass is the only completion trigger" must be locked before any component is written. The existing `MarkCompleteButton` must be explicitly retired or repurposed as part of this decision.

---

### Pitfall 2: Wrong-Answer UX Reveals the Correct Answer — Destroying Retrieval Practice Value

**What goes wrong:**
The quiz requirement is: "Wrong answers show no correct answer — learner retakes entire quiz." This is a deliberate instructional design choice rooted in retrieval practice research: showing the correct answer after a wrong answer short-circuits the desirable difficulty that makes retrieval practice effective. If the implementation instead shows "Incorrect! The correct answer was X" (the default pattern in most quiz UI libraries and tutorials), the quiz becomes a flashcard viewer rather than a retrieval test. The learner reads their way to 100% instead of recalling.

**Why it happens:**
Every quiz tutorial, every quiz component library, and every quiz UX pattern online shows correct-answer feedback on wrong answers. It is the default expectation. A developer implementing the quiz component without re-reading the requirement will almost certainly add correct-answer feedback because it feels helpful and is everywhere in examples.

**How to avoid:**
- Write the feedback specification in the component's JSDoc before implementing: "On wrong answer: show 'Incorrect — retake the quiz' with no indication of which answer was right. On correct answer: show explanation. On quiz completion (100%): show full summary with all explanations."
- The quiz state machine has three result states: `wrong` (retake, no info), `correct-partial` (answer accepted, explanation shown), `all-passed` (lesson unlocked). There is no `correct-with-hint` or `wrong-with-answer` state.
- Review the rendered component against this spec before migrating it to any lesson.

**Warning signs:**
- Any string in the component that reads "The correct answer is..." or "Correct answer:" in a wrong-answer branch
- The wrong-answer UI has more than two elements: the "Incorrect" indicator and a retake CTA
- A learner can determine the correct answer by process of elimination after seeing "incorrect" on each wrong option

**Phase to address:**
Design phase. The state machine for quiz feedback is a content-policy decision (not a UI decision) — it must be locked in writing before the quiz component is built.

---

### Pitfall 3: Quiz State Stored Per-Session (useState Only) — Progress Lost on Refresh

**What goes wrong:**
If quiz attempt state (current question index, selected answers, pass/fail result) lives only in React component state (`useState`), a page refresh during a 10-question quiz wipes all progress and forces a full restart. For the existing lesson exercises this is fine — the exercises are not timed or sequential. But a quiz where the learner is mid-attempt and accidentally refreshes gets reset to question 1. With 7–10 questions, this is a significant frustration multiplier, especially under the 100% pass requirement which already creates pressure.

**Why it happens:**
`useState` is the natural first choice for quiz state. It is local, it is fast, it is what every quiz tutorial uses. Persisting quiz state to localStorage is an extra step that developers add only when they experience the bug themselves.

**How to avoid:**
- Store quiz attempt state in localStorage under a dedicated key (`'learn-systems-quiz-attempts'` or scoped per lesson). At minimum, persist: `{ lessonId, currentQuestionIndex, answers: Record<questionId, choiceId>, passed: boolean }`.
- On component mount, check localStorage for an in-progress attempt for the current lessonId and resume from where the learner left off.
- On quiz pass, write `quizPassed: true` into the existing `LessonProgress` record (the canonical source) and clear the per-attempt transient state.
- Use the existing `useLocalStorage` hook pattern from `hooks/useLocalStorage.ts` — it already handles SSR safety with the `isHydrated` guard.

**Warning signs:**
- Quiz component uses only `useState` for current question index and selected answers
- No `useEffect` reads from localStorage on mount to restore in-progress attempt
- Refreshing the page mid-quiz resets to question 1 during development testing

**Phase to address:**
Design phase. Decide the quiz attempt persistence model (localStorage key name, schema, what gets cleared on pass vs. abandoned) before building the quiz component. This is a storage schema decision, not a UI decision.

---

### Pitfall 4: Question Randomization Creates Unrestorable State on Refresh

**What goes wrong:**
If questions are shuffled on component mount using `Math.random()`, and quiz attempt state is persisted to localStorage (see Pitfall 3), the question order stored in localStorage on page-exit will not match the question order generated on page-re-entry. The learner resumes at question 3 but "question 3" is now a different question — their stored answer may be attached to the wrong question. This is silent data corruption that is hard to detect until a learner reports that their passed answer was re-marked wrong.

More broadly: `Math.random()` in component rendering is dangerous in React — it generates different values on server render vs. client hydration, causing hydration mismatches that Next.js App Router will surface as console errors or client exceptions.

**Why it happens:**
Shuffling an array with `Math.random()` is the first pattern every developer reaches for. The interaction with localStorage persistence and SSR is non-obvious.

**How to avoid:**
- Do not randomize question order in v1.2. The requirement says "question randomization" is a consideration but it is not required. Defer it. Randomization without a seeded, deterministic, persisted shuffle adds complexity that interacts badly with persistence and SSR.
- If randomization is required: generate the shuffled order once on first quiz start, store the shuffled order (as an array of question indices) in localStorage alongside the attempt state, and restore that exact order on resume. Never re-shuffle on mount.
- All shuffling must happen inside `useEffect` (client-only), never during render, to avoid SSR hydration mismatches.

**Warning signs:**
- `Math.random()` called during component render (not inside `useEffect`)
- Shuffled question order is not stored in the quiz attempt localStorage record
- Resuming a quiz after refresh shows a different question than expected

**Phase to address:**
Design phase. Decide: randomize or not? If yes, the shuffle persistence model must be part of the quiz attempt schema from day one.

---

### Pitfall 5: Progress Type Mismatch — `LessonProgress` Not Extended Before Components Read It

**What goes wrong:**
`LessonProgress` in `types/progress.ts` currently has: `{ completed, completedAt?, exercisesCompleted }`. The quiz system needs at minimum `quizPassed?: boolean`. If the quiz component reads `progress.lessons[lessonId].quizPassed` before the type is updated, TypeScript will flag it as an error — or worse, if the type is updated but `INITIAL_PROGRESS` is not updated, the field will be `undefined` on first read and components that do `if (progress.lessons[lessonId].quizPassed)` will have falsy undefined instead of a typed boolean.

The deeper version of this pitfall: the existing `ProgressState` has a `version: number` field (currently `1`) but no migration logic. If the shape of `LessonProgress` changes and an existing learner's localStorage has the old shape, `JSON.parse(item)` in `useLocalStorage` returns the old shape with no `quizPassed` field — and the component silently reads `undefined`. There is no schema migration.

**Why it happens:**
TypeScript catches missing required fields but not missing optional fields. `quizPassed?: boolean` is optional and TypeScript will not complain about its absence. The `version` field exists but nothing reads it. The gap between "TypeScript says it's fine" and "runtime behavior is wrong" is widest for optional fields on existing records.

**How to avoid:**
- Add `quizPassed?: boolean` to `LessonProgress` in `types/progress.ts` as the first change in the design phase — before any component is written.
- Add `markQuizPassed(lessonId: LessonId)` to `ProgressContextValue` alongside `markLessonComplete`. The two actions are now always paired: `markQuizPassed` fires first, then `markLessonComplete`.
- Treat `undefined` and `false` as equivalent for `quizPassed` — both mean "quiz not yet passed." Do not add migration logic for v1.2; existing learners will re-take quizzes (the course is single-user and progress is local anyway).
- Update `version` from `1` to `2` so future migrations have a baseline.

**Warning signs:**
- `quizPassed` is read in a component before it is added to `LessonProgress`
- `markLessonComplete` is called without a paired `markQuizPassed` call
- `progress.lessons[lessonId]?.quizPassed` returns `undefined` and the UI treats it as "never attempted" when it should be "not yet passed"

**Phase to address:**
Design phase. Types first, components second. The `LessonProgress` schema extension is the load-bearing change that all quiz components depend on.

---

### Pitfall 6: MDX-Embedded Quiz Data — 400–560 Questions as Inline JSX Props

**What goes wrong:**
If quiz questions are authored as inline JSX props directly inside each MDX lesson file, the same MDX serialization fragility from v1.1 applies but at 10x the scale. A single wrong quote, unescaped brace, or angle bracket in a question or answer choice string will break the entire lesson's MDX compilation. With 7–10 questions per lesson across 56 lessons, that is 400–560 questions as inline JSX props — 400–560 individual chances for a parse error that blocks the lesson from rendering.

The cognitive overhead of writing well-formed JSX inline in MDX for 400+ questions also produces quality drift: early questions are carefully written, later questions are rushed and vague.

**Why it happens:**
Inline MDX props feel natural — the quiz lives with its lesson content. The failure mode is not obvious until you're mid-migration and encountering parse errors that are hard to locate.

**How to avoid:**
- Quiz questions must live in co-located TypeScript data files, not as inline JSX props in MDX. Pattern: `content/modules/01-linux-fundamentals/01-how-computers-work.quiz.ts` exports a `QuizQuestion[]` array. The MDX file imports it: `import { questions } from './01-how-computers-work.quiz'` and passes it as a single prop: `<LessonQuiz questions={questions} lessonId="..." />`.
- This gives TypeScript type-checking on all 400–560 questions, makes MDX files clean, enables grep/lint across all quiz content, and eliminates MDX parse errors for quiz data entirely.
- Define the `QuizQuestion` type (with `id`, `prompt`, `choices`, `correctId`, `explanation`) in `types/quiz.ts` before authoring any questions. Every question file imports and conforms to this type.

**Warning signs:**
- Questions are authored as inline JSX array props in MDX files
- `next build` errors during quiz content migration are MDX parse errors, not TypeScript errors
- Questions files have no TypeScript type annotation

**Phase to address:**
Design phase. The "co-located `.quiz.ts` data files imported into MDX" pattern must be locked and validated on one lesson before any bulk authoring starts.

---

### Pitfall 7: The Lesson-Complete Definition Change Breaks Existing Progress

**What goes wrong:**
Before v1.2, `lessons[id].completed === true` means the learner clicked "Mark as Complete." After v1.2, `completed === true` means the learner passed the quiz. These are not the same thing. A learner who has already completed all 56 lessons before v1.2 ships will have `completed: true` for all lessons with no `quizPassed` field. When v1.2 deploys and the course now requires quiz pass for completion, every already-completed lesson appears "incomplete" because `quizPassed` is undefined.

This is not a data corruption bug — the data is correct, the definition changed. But the learner sees their 100% progress reset to 0% and will think something is broken.

**Why it happens:**
Progress schema changes in single-user local apps are easy to dismiss ("just reset progress, it's local"). But this codebase has a real learner (the user) who has completed v1.1's 56 lessons. Silently invalidating their progress on update is a terrible experience.

**How to avoid:**
- Define the completion rule explicitly: for lessons completed before v1.2 was installed, `completed === true` with no `quizPassed` field counts as complete (grandfather existing completions). For new completions after v1.2, `quizPassed === true` is required.
- Implementation: the function that evaluates "is this lesson complete?" checks `completed && (quizPassed !== false)` — existing records with `completed: true` and no `quizPassed` field pass because `undefined !== false`.
- Document this rule in a code comment in `lib/progress.ts` so it is not accidentally removed.
- Bump `ProgressState.version` to `2` as a signal that new records have the v1.2 schema, old records are v1 grandfathered.

**Warning signs:**
- The "is lesson complete?" check requires `quizPassed === true` without a grandfather condition
- Testing shows a learner who has completed all 56 lessons has 0% progress after adding the quiz feature
- No comment in progress.ts explains the grandfather rule

**Phase to address:**
Design phase. The grandfather rule must be in the spec and in the `isLessonComplete` utility function before any component reads lesson completion state.

---

### Pitfall 8: Quiz Content Quality Drift Across 56 Lessons — No Authoring Standard

**What goes wrong:**
At 7–10 questions per lesson across 56 lessons, a single author writing all 400–560 questions sequentially will produce strong questions for the first 2–3 modules and increasingly weaker questions for the remaining modules. Quality drift manifests as: vague prompts ("Which command lists files?"), trivially obvious correct answers, answer choices that are obviously wrong (not plausible distractors), explanations that just restate the question, and inconsistent formatting (some questions end with "?", some with ".", some use `code formatting` for commands, others use plain text).

**Why it happens:**
Writing quiz questions is more cognitively demanding than it appears. Good multiple-choice questions require: a specific, unambiguous prompt; a correct answer with a non-obvious explanation; 3 plausible distractors (wrong answers that a learner who half-understands the material would consider). Across 400+ questions, quality inevitably slips without a written standard and a mid-migration review checkpoint.

**How to avoid:**
- Write a question authoring guide (4–5 rules, not a treatise) before authoring any questions: (1) every prompt tests exactly one concept, (2) distractors must be plausible — not random wrong commands, (3) explanations must explain *why* the correct answer is correct, not just restate it, (4) command names always use inline code format in prompts, (5) a knowledgeable learner who missed this lesson should get this question wrong.
- Author questions module-by-module, not lesson-by-lesson in sequence across all modules. Complete module 1 fully (all questions + review), then module 2. This makes quality drift visible per module rather than per lesson.
- Do a per-module quality review pass before moving to the next module: read all questions cold, check distractor plausibility, flag any question where the correct answer is obvious without knowing the lesson content.

**Warning signs:**
- More than one question in a lesson has "which command" as the full prompt
- Any distractor choice is clearly nonsensical (e.g., `rm -rf /etc/hosts` as a wrong answer to "how do you list DNS resolvers")
- Explanation text starts with "Because..." and then just restates the question prompt
- Questions for modules 5–8 look noticeably shorter/simpler than questions for modules 1–2

**Phase to address:**
Design phase (authoring guide), then enforced during content authoring. The module-by-module authoring + review rhythm must be in the roadmap plan, not improvised.

---

### Pitfall 9: The `isHydrated` Guard Missing in Quiz Gating Components

**What goes wrong:**
The existing `MarkCompleteButton` returns `null` when `!isHydrated` to prevent hydration flash — this is correct. Any new component that reads quiz state to gate behavior (e.g., "next lesson" buttons, "lesson complete" indicators in the module nav, prerequisite banners) must apply the same guard. If a "next lesson" link renders immediately as unlocked (because localStorage hasn't hydrated yet) and then snaps to locked after hydration, the learner sees a broken UI. Worse: if a learner clicks the "next" link during that brief window, they navigate to a lesson they haven't unlocked.

**Why it happens:**
The hydration guard pattern is established in `MarkCompleteButton` and `ProgressProvider`, but it must be applied in every component that renders UI conditioned on progress state. New quiz-related components written by someone who doesn't read the existing components carefully will miss it.

**How to avoid:**
- The rule: any component that renders different UI based on `progress.lessons[id]` must check `isHydrated` first. If `!isHydrated`, render a neutral state (not "locked," not "unlocked" — a loading skeleton or `null`).
- This applies to: quiz completion badges, "next lesson" unlocked indicators, module completion percentages that now factor in quiz state, and any prerequisite banner that evaluates quiz-gated completion.
- Add this rule to the `ProgressProvider` JSDoc and to a comment in `useProgress.ts`.

**Warning signs:**
- A new component reads `progress.lessons[id].quizPassed` without checking `isHydrated`
- The module nav briefly shows all lessons as complete on page load then snaps to partial
- A "next lesson" button is clickable for a few hundred milliseconds on hard refresh before locking

**Phase to address:**
Component implementation phase. Every new component that consumes progress state must have `isHydrated` guard reviewed before it ships. Treat it as a checklist item on component completion, not a "fix if we notice."

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Store quiz questions inline as JSX props in MDX files | No extra `.quiz.ts` files | 400–560 inline JSX props; parse errors from special chars; no TypeScript validation on questions; impossible to grep/lint | Never |
| Use `useState` only for quiz attempt state (no localStorage persistence) | Simple implementation | Refresh mid-quiz loses all progress; frustrating under 100% pass requirement | Never — the failure case is too predictable |
| Keep `MarkCompleteButton` alongside quiz pass as dual completion paths | Zero changes to existing button | Learners bypass quiz by clicking the button; 100% pass requirement is meaningless | Never |
| Skip the grandfather rule for existing completed lessons | Simpler "is complete" logic | Learner's 56 completed lessons read as 0% progress after upgrade | Never |
| Author questions for all 56 lessons before testing any | Maximizes batch efficiency | Quality drift across 400+ questions; no validation of question type until end | Never — author and test module-by-module |
| Skip question IDs (use array index as identifier) | Less schema to write | Reordering questions breaks localStorage answer records; shuffling is impossible to add later | Acceptable only if randomization is permanently deferred and no shuffling is planned |
| Add quiz UI as a separate scrollable section below `MarkCompleteButton` | Fastest render path | Learner can "complete" lesson without reaching quiz (not visible without scrolling) | Never — quiz must be the completion gate, not an optional appendix |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| `ProgressProvider` + quiz state | Adding a second `useLocalStorage` call inside the quiz component directly | Add `markQuizPassed` and `quizPassed(lessonId)` to `ProgressContextValue`; all quiz-progress writes go through the provider |
| `LessonLayout` + quiz component | Rendering `<LessonQuiz>` after `<MarkCompleteButton>` without removing the button | Remove `MarkCompleteButton` from `LessonLayout`; `LessonQuiz` is the new terminal action |
| `.quiz.ts` files imported in MDX | Using `import` from an absolute path (`@/content/...`) inside MDX | Use relative imports inside MDX files (`./01-lesson-slug.quiz`) — absolute path resolution behavior in MDX can differ from `.tsx` files depending on `@next/mdx` config |
| `LessonProgress` schema change + existing localStorage | New `quizPassed` field read on old records where it doesn't exist | Always use optional chaining: `progress.lessons[id]?.quizPassed` and treat `undefined` as "not passed" |
| `mdx-components.tsx` registration | Forgetting to register `LessonQuiz` in `useMDXComponents` | Any component used directly in MDX must be in `mdx-components.tsx`; import failure is a runtime error, not a build error |
| Quiz attempt state + question order | Storing question order as question objects in localStorage | Store only question IDs (or indices) in localStorage — full question objects live in the `.quiz.ts` data file |

---

## Performance Traps

This is a local single-user app; traditional scale performance is not the concern. The relevant traps are build-time and authoring-time.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| 56 `.quiz.ts` import files in MDX | `next build` time increases because each MDX file now imports a companion data file | Keep quiz data files as plain TypeScript constant exports (no complex re-exports or barrel files); static data, not modules with side effects | Not a real concern at 56 files, but keep files simple |
| Large quiz state object in localStorage | LocalStorage writes on every answer selection get slow if the entire quiz state is serialized; unlikely at 7–10 questions | Serialize only what changes (current answer map, not full question objects) | Not a real concern at 10 questions per quiz |
| Quiz component re-render on every answer | If quiz state is in Context (not local component state), each answer selection re-renders all progress-consuming components | Keep in-progress quiz attempt state local to the quiz component; only write to Context/localStorage on quiz pass | Every answer click |

---

## UX Pitfalls

| Pitfall | Learner Impact | Better Approach |
|---------|----------------|-----------------|
| Showing "X/10 correct" on quiz fail without indicating which questions were wrong | Learner doesn't know which concepts to review; 100% retake is less useful | On fail: show only "Incorrect — review the lesson and try again." No question-level breakdown. The retake forces full re-engagement. |
| Resetting to question 1 on wrong answer without confirmation | Learner clicks wrong answer accidentally and loses 9 correct answers | Show "Incorrect — retake quiz?" as a confirmation before wiping the attempt; or make wrong-answer restart deliberate (a button) not automatic |
| Quiz appearing in a collapsed/hidden section below the fold | Learner scrolls past the quiz thinking the lesson is done | Quiz must render fully visible, not collapsed; position below exercise section but above any footer nav |
| "Next lesson" link visible even when quiz not passed | Learner clicks next expecting to continue, gets a prerequisite block; confusing flow | Either hide "next lesson" link until quiz passes, or show it as disabled with tooltip "Complete quiz to continue" |
| Explanation text shown for wrong answers ("The correct answer was...") | Undermines retrieval practice; learner reads to 100% | Explanation text only shown when the correct answer is selected; zero info on wrong answer |
| "Try again" restarts quiz from question 1 with the same question order | Learner memorizes answer positions rather than learning the concept | Not a concern if no randomization; if randomization is added, shuffle on each new attempt |
| 100% pass with no progress indicator ("Question 3 of 10") | Learner doesn't know how many questions remain; anxiety-inducing | Show question progress indicator (e.g., "3 / 10") throughout the quiz |

---

## "Looks Done But Isn't" Checklist

- [ ] **Quiz gating:** `MarkCompleteButton` is removed from `LessonLayout` or disabled until quiz passes — verify no lesson can be marked complete without quiz pass
- [ ] **Grandfather rule:** Lessons with `completed: true` and no `quizPassed` field still read as complete — verify a pre-v1.2 progress object gives 100% completion, not 0%
- [ ] **Wrong-answer feedback:** Wrong answer shows no correct answer and no explanation — verify by selecting each wrong option in one quiz and confirming no hint about the correct choice appears
- [ ] **localStorage persistence:** Refreshing mid-quiz restores current question and previous answers — verify by answering 5 questions, refreshing, and confirming question 6 loads with questions 1–5 answers retained
- [ ] **Hydration guard:** All quiz-gating UI (next lesson buttons, completion badges) renders `null` or a neutral loading state until `isHydrated === true` — verify with React DevTools by simulating slow hydration
- [ ] **Quiz data TypeScript types:** All `.quiz.ts` files pass TypeScript compile — verify with `tsc --noEmit` after authoring 10 questions
- [ ] **MDX import pattern:** A `.quiz.ts` data file can be imported into an MDX file and render correctly — verify with one complete lesson end-to-end before bulk authoring
- [ ] **Question ID uniqueness:** Every question has a unique `id` within its lesson — verify no two questions in one file share an `id`
- [ ] **Explanation coverage:** Every question has a non-empty `explanation` field — verify no question has an empty or placeholder explanation before shipping

---

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| `MarkCompleteButton` left as bypass path | LOW — code-only fix | Remove button from `LessonLayout`; audit that `markLessonComplete` is only called from `markQuizPassed` completion handler |
| Wrong-answer shows correct answer | LOW — UI-only fix | Remove the correct-answer reveal from wrong-answer state branch; no data model change |
| Quiz state not persisted (useState only) | MEDIUM — requires adding localStorage integration | Add quiz attempt localStorage key; write `useEffect` to read on mount; retest resume behavior |
| Randomization breaks localStorage resume | HIGH if live — requires schema change + re-auth of all in-progress attempts | Simplest recovery: disable randomization; store shuffle order in attempt schema if randomization is retained |
| `LessonProgress` type change breaks grandfathering | MEDIUM — requires updating `isLessonComplete` utility | Add grandfather condition; run full progress test suite; no localStorage migration needed |
| Quality drift in questions (modules 5–8 poor quality) | MEDIUM — content rewrite, not code | Rewrite affected questions using the authoring guide; `.quiz.ts` files make this surgical (no MDX changes needed) |
| `.quiz.ts` import fails in MDX | LOW per lesson, MEDIUM if discovered in batch | Validate import pattern on one lesson before bulk authoring; fix relative vs. absolute path; test with `next build` per module |

---

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| ProgressState gating race condition | Design phase — schema and gating rule locked | `MarkCompleteButton` removed; `markLessonComplete` only callable via quiz pass path |
| Wrong-answer reveals correct answer | Design phase — quiz state machine spec written | Wrong-answer branch in quiz component has no correct-answer string; verified by manual testing |
| Quiz state not persisted | Design phase — localStorage schema for quiz attempts defined | Refresh mid-quiz restores question and answers |
| Randomization breaks localStorage resume | Design phase — randomization deferred or shuffle order stored in schema | Refresh mid-quiz shows same question order |
| `LessonProgress` type not extended before components | Design phase — `types/progress.ts` updated first | `tsc --noEmit` passes with `quizPassed?: boolean` in `LessonProgress` |
| MDX inline quiz data at scale | Design phase — `.quiz.ts` import pattern decided | One lesson validates end-to-end before bulk authoring begins |
| Existing completions invalidated by definition change | Design phase — grandfather rule in `isLessonComplete` | Pre-v1.2 progress object reads as fully complete after v1.2 ships |
| Quiz content quality drift | Design phase (authoring guide) + content authoring (module-by-module review) | Per-module quality review pass exists in roadmap; module N review before module N+1 starts |
| `isHydrated` guard missing | Component implementation phase — each new progress-reading component reviewed | All quiz-gating UI returns neutral state when `!isHydrated` |

---

## Sources

- Direct codebase inspection: `hooks/useLocalStorage.ts` — SSR-safe localStorage hook with `isHydrated` guard; `components/progress/ProgressProvider.tsx` — `ProgressContextValue` shape, `markLessonComplete` implementation; `types/progress.ts` — `LessonProgress`, `ProgressState`, `version: 1`; `components/lesson/MarkCompleteButton.tsx` — existing completion mechanism; `components/lesson/LessonLayout.tsx` — component composition for all 56 lessons; `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` — server component rendering pattern — HIGH confidence
- Direct codebase inspection: `lib/mdx.ts` — `getLessonContent` uses relative `@/content/modules/...` dynamic import; frontmatter read separately via gray-matter — HIGH confidence (informs `.quiz.ts` import approach)
- [MDX JSX expression parsing — MDX official docs](https://mdxjs.com/) — inline JSX prop limitations with special characters; import pattern from co-located files — MEDIUM confidence (verified pattern from v1.1 experience in this codebase)
- [SSR-safe React hooks — ReactUse blog](https://reactuse.com/blog/ssr-safe-react-hooks/) — `useEffect`-deferred localStorage access to avoid hydration mismatch; confirmed against this codebase's existing `useLocalStorage` implementation — HIGH confidence
- [Retrieval practice and wrong-answer feedback — PMC 2023](https://pmc.ncbi.nlm.nih.gov/articles/PMC10060135/) — "negative testing effect" from revealing correct answers after wrong answers; deferred feedback (retake without hint) preserves desirable difficulty — MEDIUM confidence
- [Questioning for retrieval: five mistakes to avoid — Improving Teaching blog](https://improvingteaching.co.uk/2023/04/23/questioning-for-retrieval-five-mistakes-to-avoid/) — concrete anti-patterns in multiple-choice question design (trivial distractors, restatement explanations) — MEDIUM confidence
- [Math.random() key warning — React docs](https://react.dev/learn/rendering-lists#keeping-list-items-in-order-with-key) — generating keys with Math.random() causes DOM recreation every render; applies to question-order shuffling during render — HIGH confidence
- Existing `PITFALLS.md` v1.1 research (2026-03-20) — MDX prop serialization failure pattern, `annotated={true}` per-exercise gate pattern, batch vs. module-by-module migration discipline — HIGH confidence (directly applicable to quiz data authoring)

---
*Pitfalls research for: v1.2 Quiz/Assessment System — Multiple-Choice Quizzes Gating Lesson Completion*
*Researched: 2026-03-22*
