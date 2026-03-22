# Feature Research

**Domain:** Multiple-choice quiz / assessment system added to existing interactive DevOps course
**Researched:** 2026-03-22
**Confidence:** HIGH (core mechanics and codebase dependencies), MEDIUM (competitor UX patterns)

---

## Context: What Already Exists

This is a SUBSEQUENT MILESTONE research file. The following are already built and must NOT be
re-implemented — they are dependencies the quiz system builds on:

- `ProgressProvider` / `useProgress` — localStorage-backed context with `markLessonComplete`, `markExerciseComplete`
- `LessonProgress` type — `{ completed, completedAt, exercisesCompleted[] }`
- `ProgressState` — `Record<LessonId, LessonProgress>` with a `version` field already present for migrations
- `MarkCompleteButton` — currently the sole path to marking a lesson complete; will be replaced or gated
- `PrerequisiteBanner` — reads `progress.lessons[id].completed` to gate lesson access visually
- `LessonLayout` — renders `<MarkCompleteButton>` at the lesson bottom; quiz slots after the exercise section
- `ScenarioQuestion` — single open-ended Q&A expand/collapse (different pattern from MC quiz, not replaced)
- Lesson ordering — `content/modules/index.ts` has lesson ordering data needed for "next lesson" navigation

The quiz system must plug into this existing architecture, not replace it.

---

## Feature Landscape

### Table Stakes (Users Expect These)

Features that define the quiz as functional. Missing any one of these makes the quiz feel broken
or pointless given the stated design spec.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Multiple-choice question rendering | Core deliverable — 7-10 MC questions per lesson | LOW | Each question: stem + 4 options, one correct |
| Single-selection per question | Users expect radio-button behavior — only one answer selectable at a time | LOW | Prevent multi-select; unambiguous correct/incorrect feedback |
| Wrong answer feedback: "Incorrect" label only | Spec requires no correct answer reveal on failure — forces genuine retrieval | LOW | Show red "Incorrect" state on selected option; do NOT highlight the correct option |
| Correct answer feedback: explanation shown | Spec requires explanation on correct selection to reinforce reasoning | LOW | Show explanation paragraph below question when correct option is chosen |
| Full retake on failure | Spec: learner retakes entire quiz if any question is wrong | MEDIUM | Resets all question states to unanswered; cannot resume mid-quiz after wrong answer; retake from Q1 |
| 100% pass gate on lesson completion | Spec: lesson complete only when quiz passed — extends existing completion flow | MEDIUM | All questions must be answered correctly; replaces or gates `MarkCompleteButton` |
| Quiz positioned after hands-on exercise | Spec: quiz lives at bottom of lesson page after the exercise section | LOW | `LessonLayout` already orders content; quiz is the last section before the completion action |
| Persistent quiz pass state | Pass state must survive page refresh — show "Quiz Passed" badge per lesson | MEDIUM | Extends `LessonProgress` type; new field `quizPassed: boolean`; uses existing `version` bump pattern |

### Differentiators (Competitive Advantage)

Features that make this quiz system pedagogically excellent, aligned with the "learn by doing"
course philosophy and retrieval practice research.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Wrong-answer no-reveal pattern | Pedagogically sound: forces learner to re-read lesson content rather than scanning for the answer. KRF-only feedback (correct/incorrect signal, no answer reveal) with full retake produces stronger long-term retention than KCRF (immediate reveal). This is a deliberate departure from Duolingo and Codecademy. | LOW | The no-reveal behavior is a differentiator, not a limitation — it should be designed intentionally, not apologetically |
| Explanation tied to correct selection only | Elaborated feedback on success reinforces the accurate mental model. Giving explanations on wrong answers risks learners reading explanations as a shortcut to skip thinking. | LOW | Explanation text authored per question; shown only when the learner selects the correct option |
| Quiz locked until exercise completed | Enforces "do before you quiz" — no skipping the hands-on work. Retrieval practice is most effective immediately after an encoding experience (the exercise). | MEDIUM | Check `exercisesCompleted.length > 0` for the lesson before allowing quiz interaction; simpler than per-exercise-ID check |
| Attempt count tracked | Shows learner how many tries it took — normalizes struggle and provides motivation signal. | LOW | Store `quizAttempts: number` in `LessonProgress`; increment on each full retake |
| Quiz completion triggers lesson complete automatically | After passing, lesson is marked complete without requiring a separate "Mark as Complete" click — the pass event IS the completion event | MEDIUM | `markQuizPassed` action calls `markLessonComplete` internally; removes the manual button from the quiz-pass flow |
| "Continue to Next Lesson" CTA after pass | Surfaces next-lesson navigation immediately after quiz pass — closes the learning loop cleanly | MEDIUM | Requires next-lesson lookup from `modules.ts`; renders a CTA button that replaces the retake prompt |

### Anti-Features (Commonly Requested, Often Problematic)

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Show correct answer on wrong selection | "Helpful" feedback feels supportive | Eliminates retrieval practice — learner reads the right answer and clicks Retake without reconstructing understanding. Research (Frontiers in Psychology, PMC) confirms KRF-only with full retake produces stronger retention than immediate correct-answer reveal for technical content | Show "Incorrect" only; learner re-reads the relevant lesson section |
| Resume quiz at last unanswered question after failure | Reduces friction for long quizzes | Partial completion state is complex to persist correctly; learner skips reviewing their wrong answers; defeats the purpose of full retake as a retrieval event. For 7-10 questions, full retake takes under 2 minutes — friction cost is minimal | Full retake from Q1 every time |
| Shuffle questions on retake | Prevents pattern memorization | DevOps content is sequential — question 3 often depends on Q2 context; shuffling breaks the narrative arc. Adds implementation complexity for marginal gain in a fixed-order technical curriculum | Fixed order; rely on explanation quality to prevent rote clicking |
| Question bank with random subset (15-20 questions, draw 7-10) | Variety across retakes | Requires authoring 15-20 questions per lesson to draw 7-10 from; at 56 lessons that is 840-1120 questions minimum — unsustainable content burden for a single-author project | Fixed 7-10 questions per lesson; rely on explanation depth |
| Per-question progress save (resume mid-quiz) | Survive browser close mid-quiz | Complex state management; trivial risk for a 7-10 question quiz that takes 3-4 minutes to complete | Stateless quiz session; persist only the final passed/failed outcome |
| Score display (e.g., "8/10 correct") | Feels like informative feedback | 100% required means any score below 100% means retake — showing "8/10" implies "almost there" which can breed learned helplessness ("close enough next time"). Does not add information over "one or more incorrect." | Pass/fail only: "All correct — lesson complete" vs "One or more incorrect — retake" |
| Partial credit or weighted questions | Nuanced assessment | 100% gate means partial credit cannot change the outcome — it adds UI complexity with no functional effect | Binary correct/incorrect per question; binary pass/fail for the quiz |
| Timer / timed quiz | Urgency | Learner is on localhost, not in an exam. Timers add cognitive load without pedagogical value for skill-building. Mastery learning treats time as the variable, achievement as the constant — enforcing a timer inverts this | No timer |
| Per-question "hint" before answering | Reduces frustration | Hints undermine the retrieval event that makes quizzing effective. A hint before attempting is just reading the answer in a different format | No hints; learner re-reads lesson prose instead |

---

## Feature Dependencies

```
[quizPassed: boolean in LessonProgress]
    └──requires──> [LessonProgress type extension]
                       └──requires──> [ProgressState version bump (v1 → v2)]
                                          └──requires──> [migration guard in useLocalStorage]

[LessonQuiz React component]
    └──requires──> [Quiz data format decided and authored per lesson]
    └──requires──> [markQuizPassed action in ProgressProvider]
    └──reads──> [exercisesCompleted[] from existing LessonProgress]

[Lesson completion gate]
    └──requires──> [quizPassed: boolean]
    └──conflicts──> [MarkCompleteButton as standalone gate]
                    (MarkCompleteButton must be removed or hidden when quiz present)

[markQuizPassed action]
    └──requires──> [ProgressProvider update]
    └──calls internally──> [existing markLessonComplete]
    └──increments──> [quizAttempts counter on each attempt]

[Quiz locked until exercise done]
    └──requires──> [exercisesCompleted[] — already exists in LessonProgress]
    └──requires──> [consistent exercise ID per lesson OR length > 0 heuristic]

["Continue to Next Lesson" CTA after pass]
    └──requires──> [quizPassed state]
    └──requires──> [next lesson lookup from modules.ts — already exists]

[Quiz data authoring (56 lessons)]
    └──required-by──> [LessonQuiz component]
    └──this is the highest-volume work item in v1.2]
```

### Dependency Notes

- **LessonProgress type extension is the first dependency:** Add `quizPassed: boolean` and `quizAttempts: number` to the type. Bump `ProgressState.version` from `1` to `2`. Add a migration guard in `useLocalStorage` that defaults `quizPassed: false` for existing lesson records so progress data from v1.1 is not lost.

- **MarkCompleteButton conflicts with quiz-driven completion:** Currently the only path to `markLessonComplete`. With quiz gating, completion fires via `markQuizPassed`. The manual button must be removed from lessons that have a quiz — keeping both creates a bypass that defeats the gate entirely.

- **Quiz data authoring is the highest-effort dependency:** 56 lessons × 7-10 questions = 392-560 questions. This is primarily a content authoring problem. The data format decision (MDX frontmatter array, co-located `.json` files, or TypeScript data files in `content/`) gates all quiz rendering work and must be locked before bulk authoring begins.

- **Exercise lock heuristic:** Rather than requiring a specific exercise ID per lesson (which would require auditing 56 lessons), check `exercisesCompleted.length > 0` — if any exercise in the lesson has been completed, the quiz is unlocked. This is simpler and correct for the use case.

---

## MVP Definition

### Launch With (v1.2 — this milestone)

- [ ] `QuizQuestion` type and `LessonQuiz` data interface defined in TypeScript
- [ ] `LessonProgress` type extended with `quizPassed: boolean` and `quizAttempts: number`; `ProgressState` version bumped with migration guard
- [ ] `markQuizPassed(lessonId)` action added to `ProgressProvider` (internally calls `markLessonComplete`)
- [ ] `LessonQuiz` React component — renders 7-10 MC questions, handles single-selection, shows Incorrect/explanation feedback, triggers pass on 100%, triggers full retake on any wrong answer
- [ ] `MarkCompleteButton` removed from lessons that have a quiz (quiz pass is the completion event)
- [ ] Quiz data authored for all 56 lessons (7-10 questions each, with explanation per correct answer)
- [ ] Quiz rendered in `LessonLayout` after the exercise section

### Add After Validation (v1.2.x)

- [ ] "Continue to Next Lesson" CTA after quiz pass — add once base flow is validated working across all 56 lessons
- [ ] Attempt count display in the quiz UI — add once base component is stable
- [ ] Exercise completion lock on quiz — add after confirming `exercisesCompleted` is populated consistently across all modules

### Future Consideration (v2+)

- [ ] Spaced repetition review — surface questions from completed lessons as optional review; requires a separate review mode and scheduling logic
- [ ] Question-level analytics — track which questions are most frequently failed; requires aggregation beyond per-user localStorage
- [ ] Adaptive follow-up questions — harder variants on first-attempt pass; significant authoring and logic overhead

---

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| MC question rendering with correct/incorrect feedback | HIGH | LOW | P1 |
| Explanation text on correct selection | HIGH | LOW | P1 |
| Full retake on failure (any wrong answer) | HIGH | MEDIUM | P1 |
| 100% pass gate + quizPassed state | HIGH | MEDIUM | P1 |
| LessonProgress type extension + migration guard | HIGH | LOW | P1 |
| MarkCompleteButton removal/replacement | HIGH | LOW | P1 |
| Quiz data authoring (all 56 lessons) | HIGH | HIGH | P1 |
| "Continue to Next Lesson" CTA after pass | MEDIUM | MEDIUM | P2 |
| Exercise completion lock on quiz | MEDIUM | MEDIUM | P2 |
| Attempt count display | LOW | LOW | P2 |
| Quiz data schema validation | MEDIUM | LOW | P2 |

**Priority key:**
- P1: Must have for v1.2 launch
- P2: Add after core is working and validated
- P3: Future milestone

---

## Competitor Feature Analysis

Included to document the deliberate departures from industry defaults and why.

| Feature | Duolingo | Codecademy | Khan Academy | This App |
|---------|----------|------------|--------------|----------|
| Wrong answer feedback | Shows correct answer immediately; continue | Shows correct answer with explanation | Shows correct answer | "Incorrect" only — no reveal |
| Pass gate | Lives/hearts system; lesson ends on 0 hearts | No score gate on most content | Usually no strict gate | 100% required; full retake |
| Retake behavior | Full lesson restart | Optional practice, not gated | Re-attempt allowed | Full quiz retake from Q1 |
| Correct answer feedback | Celebratory + brief explanation | Explanation inline | Explanation shown | Explanation paragraph shown |
| Score display | Progress bar + streak count | Percentage displayed | Points shown | None — pass/fail only |
| Exercise-quiz coupling | N/A (gamified format) | Code exercise before quiz in some paths | Practice before quiz | Hands-on exercise must precede quiz |

The no-reveal-on-failure pattern is a deliberate deviation from all three competitors.
It is grounded in retrieval practice research: forcing re-reading rather than answer-scanning
produces stronger retention for technical commands and concepts where understanding the
mechanism matters, not just recognizing the correct option.

---

## Sources

- [The Effects of Different Feedback Types on Learning With Mobile Quiz Apps — Frontiers in Psychology](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2021.665144/full)
- [The Effects of Different Feedback Types on Learning With Mobile Quiz Apps — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8200521/)
- [Finding the best pattern for quiz feedback — Max Maier, Medium](https://medium.com/@maxmaier/finding-the-best-pattern-for-quiz-feedback-9e174b8fd6b8)
- [Mastery Learning — Wikipedia](https://en.wikipedia.org/wiki/Mastery_learning)
- [A Practical Review of Mastery Learning — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10159400/)
- [How Retaking Practice Questions Improves Memory Retention — TrueLearn](https://truelearn.com/resource-library/retaking-practice-questions-is-key-to-better-memory-retention-in-healthcare-education/)
- [CBE Mastery Framework — IES REL Southeast, 2025](https://ies.ed.gov/rel-southeast/2025/01/cbe-mastery-framework)
- Existing codebase (HIGH confidence, direct inspection): `types/progress.ts`, `types/content.ts`, `components/progress/ProgressProvider.tsx`, `components/lesson/MarkCompleteButton.tsx`, `components/lesson/LessonLayout.tsx`, `components/content/ScenarioQuestion.tsx`, `hooks/useProgress.ts`, `lib/progress.ts`

---

*Feature research for: multiple-choice quiz system, learn-systems DevOps course (v1.2)*
*Researched: 2026-03-22*
