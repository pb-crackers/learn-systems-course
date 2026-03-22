# Architecture Research

**Domain:** Quiz/assessment integration — multiple-choice quiz system added to existing Next.js MDX lesson architecture (v1.2 milestone)
**Researched:** 2026-03-22
**Confidence:** HIGH — based on direct codebase inspection of all relevant files

---

## Context: What Exists (v1.1 Baseline)

This is a subsequent-milestone document. All integration decisions are grounded in the live codebase.

### Existing Component Inventory

| Component | File | Relevant to Quiz |
|-----------|------|-----------------|
| `ExerciseCard` | `components/content/ExerciseCard.tsx` | Hands-on exercise — quiz comes after this |
| `MarkCompleteButton` | `components/lesson/MarkCompleteButton.tsx` | Must be replaced with gated completion logic |
| `LessonLayout` | `components/lesson/LessonLayout.tsx` | Renders `MarkCompleteButton` — must add `LessonQuiz` above it |
| `ProgressProvider` | `components/progress/ProgressProvider.tsx` | Stores `LessonProgress` — must add quiz state |
| `PrerequisiteBanner` | `components/lesson/PrerequisiteBanner.tsx` | Reads `progress.lessons[id].completed` — no change needed |
| `mdx-components.tsx` | root | Registers MDX-available components — no quiz registration needed (quiz is layout-level, not MDX-level) |

### Existing Type Contracts (What Quiz Must Integrate With)

```typescript
// types/progress.ts — CURRENT
export interface LessonProgress {
  completed: boolean
  completedAt?: string
  exercisesCompleted: string[]
}

export interface ProgressState {
  lessons: Record<LessonId, LessonProgress>
  version: number
}

export const PROGRESS_STORAGE_KEY = 'learn-systems-progress'
```

```typescript
// types/content.ts — NO CHANGE NEEDED
export interface LessonFrontmatter {
  title: string
  description: string
  module: string
  moduleSlug: ModuleSlug
  lessonSlug: LessonSlug
  order: number
  difficulty: Difficulty
  estimatedMinutes: number
  prerequisites: LessonId[]
  tags: string[]
}
```

### Existing Data Flow

```
content/modules/[module]/[lesson].mdx  (MDX source — quiz data lives here)
        | (dynamic import at build time via @next/mdx)
        v
app/modules/[moduleSlug]/[lessonSlug]/page.tsx
        | getLessonContent() — extracts frontmatter via gray-matter
        | quiz data is NOT in frontmatter — it is exported from MDX or passed as props
        v
LessonLayout (receives frontmatter)
        | renders MDXContent children, then LessonQuiz below content
        v
<MDXContent /> — renders lesson prose + ExerciseCard etc.
        v
LessonQuiz (new) — positioned after MDXContent, before MarkCompleteButton
        | reads/writes progress via useProgress()
        v
MarkCompleteButton (modified) — disabled until quiz passed
```

---

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                       MDX Lesson Content                                 │
│  Prose + Callout + ExerciseCard + VerificationChecklist                  │
│  quiz data exported from MDX as named export (see Pattern 1)            │
└───────────────────────────────┬─────────────────────────────────────────┘
                                | MDX named export extracted by getLessonContent()
┌───────────────────────────────v─────────────────────────────────────────┐
│         app/modules/[moduleSlug]/[lessonSlug]/page.tsx                   │
│  (MODIFIED) passes quiz prop to LessonLayout                             │
└───────────────────────────────┬─────────────────────────────────────────┘
                                |
┌───────────────────────────────v─────────────────────────────────────────┐
│                    components/lesson/LessonLayout.tsx                    │
│  (MODIFIED) receives quiz prop; renders LessonQuiz below MDXContent      │
│             removes MarkCompleteButton; LessonQuiz owns completion gate  │
└──────────────┬──────────────────────────┬───────────────────────────────┘
               |                          |
┌──────────────v──────────────┐  ┌────────v──────────────────────────────┐
│  components/lesson/         │  │  components/quiz/ (NEW directory)      │
│  LessonQuiz.tsx (NEW)       │  │  QuizQuestion.tsx (NEW)                │
│                             │  │  QuizResult.tsx (NEW)                  │
│  Orchestrates quiz state:   │  │                                        │
│  - not-started              │  │  QuizQuestion: single question with    │
│  - in-progress              │  │  4 options, submit, explanation reveal │
│  - passed                   │  │                                        │
│  - failed (retake whole)    │  │  QuizResult: end-of-quiz summary       │
│                             │  │  (passed: lesson unlocked message;     │
│  Calls markLessonComplete() │  │   failed: full retake prompt)          │
│  on 100% score              │  │                                        │
└──────────────┬──────────────┘  └────────────────────────────────────────┘
               |
┌──────────────v──────────────────────────────────────────────────────────┐
│           components/progress/ProgressProvider.tsx (MODIFIED)            │
│                                                                          │
│  EXTENDED ProgressState:                                                 │
│    quizPassed: boolean           (has the quiz ever been passed)         │
│    quizPassedAt?: string         (ISO timestamp)                         │
│                                                                          │
│  NEW context methods:                                                    │
│    markQuizPassed(lessonId): void                                        │
│    isQuizPassed(lessonId): boolean                                       │
│                                                                          │
│  MODIFIED markLessonComplete:                                            │
│    lesson.completed = quizPassed (quiz gate enforced here)               │
└─────────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Status |
|-----------|----------------|--------|
| `LessonQuiz` | Orchestrates quiz state machine; calls `markLessonComplete` on pass | NEW |
| `QuizQuestion` | Renders one multiple-choice question; handles answer selection, reveals explanation on correct, blocks on incorrect | NEW |
| `QuizResult` | End-of-quiz screen: pass (lesson unlocked) or fail (retake prompt) | NEW |
| `ProgressProvider` | Adds `quizPassed` to `LessonProgress`; exposes `markQuizPassed` | MODIFIED |
| `LessonLayout` | Receives `quiz` prop; renders `LessonQuiz` below `MDXContent`; removes standalone `MarkCompleteButton` | MODIFIED |
| `MarkCompleteButton` | Removed from `LessonLayout`; quiz pass triggers completion directly | REMOVED from layout (may keep for lessons without quizzes) |
| `page.tsx` | Extracts quiz data from MDX named export; passes to `LessonLayout` | MODIFIED |
| `lib/mdx.ts` | Extracts `quiz` named export alongside `frontmatter` | MODIFIED |

---

## Quiz Data Storage Decision

**Decision: MDX named export — NOT frontmatter, NOT separate file.**

### Why Not Frontmatter

Frontmatter (`gray-matter` parsing) is YAML. Multi-line question/answer text in YAML is verbose and error-prone. The `LessonFrontmatter` type is clean and minimal — adding 7-10 question objects with 4 options each creates unreadable YAML and pollutes the type with runtime content.

### Why Not Separate JSON/TS Files

A separate `content/quizzes/01-linux-fundamentals/01-how-computers-work.json` creates a parallel directory tree with no co-location. The quiz is pedagogically part of the lesson — splitting it into a different file means authoring two files per lesson change and risks content drift (question references a concept removed from the lesson). 56 separate quiz files adds complexity with no benefit for a single-author local app.

### Why MDX Named Export

`@next/mdx` compiles MDX to a JavaScript module. The default export is the React component. Any other named export is accessible when you dynamically import the module. This is a first-class MDX feature.

**Authoring pattern in MDX:**
```mdx
---
title: "How Computers Work"
# ... existing frontmatter unchanged ...
---

export const quiz = [
  {
    id: "q1",
    question: "A process is using 400% CPU on a system with 4 cores. What does this indicate?",
    options: [
      "The process has a memory leak",
      "The process is multi-threaded and using all 4 cores simultaneously",
      "The system is overloaded and will crash soon",
      "CPU measurement tools are reporting incorrectly"
    ],
    correctIndex: 1,
    explanation: "CPU usage above 100% means the process has multiple threads running on multiple cores simultaneously. 400% on a 4-core system means all cores are fully utilized by this one process — a sign of good parallelization, not a problem."
  },
  // ... 6-9 more questions
]

## Overview
...existing lesson content unchanged...
```

**Extraction in `lib/mdx.ts`:**
```typescript
const mod = await import(`@/content/modules/${moduleSlug}/${lessonSlug}.mdx`)
// mod.default = React component (existing)
// mod.quiz = QuizQuestion[] | undefined (NEW named export)
return {
  default: mod.default,
  frontmatter,
  quiz: mod.quiz ?? null,
}
```

This requires zero changes to the MDX build pipeline (`next.config.ts`, `remarkFrontmatter`, `rehypePrettyCode` are all untouched). Named exports in MDX are supported by `@next/mdx` without any plugin additions.

---

## Recommended Project Structure (new files only)

```
components/
└── quiz/                        # NEW directory
    ├── LessonQuiz.tsx           # Quiz orchestrator: state machine, completion gate
    ├── QuizQuestion.tsx         # Single question renderer
    └── QuizResult.tsx           # Pass/fail end screen

types/
└── quiz.ts                      # NEW — QuizQuestion type, QuizState type
```

Modified files:
```
types/progress.ts                # Extend LessonProgress with quizPassed
components/progress/ProgressProvider.tsx   # Add markQuizPassed, isQuizPassed
components/lesson/LessonLayout.tsx         # Accept quiz prop, render LessonQuiz
app/modules/[moduleSlug]/[lessonSlug]/page.tsx  # Pass quiz from getLessonContent
lib/mdx.ts                       # Extract quiz named export from MDX module
```

### Structure Rationale

- **`components/quiz/`**: Quiz components are distinct from `components/content/` (MDX content primitives) and `components/lesson/` (layout-level chrome). A separate directory signals these are lesson-level interactive assessment components, not reusable content blocks.
- **`types/quiz.ts`**: Quiz question shape and state machine enum live here. Keeping them separate from `types/progress.ts` (persistence) and `types/content.ts` (MDX structure) maintains the existing type file discipline.
- **No new route or API**: Everything is component-local state + existing localStorage. No server needed.

---

## Architectural Patterns

### Pattern 1: MDX Named Export for Quiz Data

**What:** Quiz questions are a named export (`export const quiz = [...]`) in the MDX file, extracted via dynamic import in `lib/mdx.ts`.

**When to use:** All 56 lessons. Lessons without a quiz yet simply do not export `quiz` — `mod.quiz` is `undefined`, `getLessonContent` returns `quiz: null`, `LessonLayout` omits `LessonQuiz`.

**Trade-offs:**
- Pro: Co-located with lesson content, no new file per lesson, zero build pipeline change, natural MDX authoring experience
- Pro: Progressive rollout — lessons without `quiz` export keep working exactly as before
- Con: Quiz data is compiled into the JavaScript bundle for that lesson (no lazy loading). Acceptable — 7-10 question objects of ~200 bytes each is negligible bundle impact.
- Con: `export const` in MDX body is unusual; authors need to know the convention. Address with the template.

**Example:**
```mdx
export const quiz = [
  {
    id: "q1",
    question: "When the Linux OOM killer runs, what does it do?",
    options: [
      "Increases swap space automatically",
      "Kills the process using the most memory to free RAM",
      "Pauses all processes until memory is freed",
      "Writes excess memory to disk as a core dump"
    ],
    correctIndex: 1,
    explanation: "The OOM (Out of Memory) killer selects and kills a process — usually the one consuming the most memory — to reclaim RAM and prevent a full system crash."
  }
]
```

### Pattern 2: Client-Side Quiz State Machine

**What:** `LessonQuiz` manages quiz state as a React `useState` state machine: `'idle' | 'active' | 'passed' | 'failed'`. No server state, no persistence for in-progress state — only the final `quizPassed` boolean persists to localStorage.

**When to use:** All quiz orchestration in `LessonQuiz.tsx`.

**Trade-offs:**
- Pro: Simple, no persistence complexity, matches existing single-learner local-app model
- Pro: Failed quiz resets entirely — intentional per requirements ("wrong answers require retaking the entire quiz")
- Con: Refreshing mid-quiz resets to start. This is correct behavior: the system should not track partial quiz state. A learner who closes the browser mid-quiz simply retakes from question 1.

**State transitions:**
```
idle ──(start quiz)──> active
active ──(all correct, 100%)──> passed ──(markLessonComplete called)
active ──(any wrong answer)──> failed
failed ──(retake)──> active (fresh, question 0, shuffled or fixed order)
passed ──(persisted quizPassed=true in localStorage)──> idle (next visit shows lesson complete)
```

**Example:**
```typescript
type QuizPhase = 'idle' | 'active' | 'passed' | 'failed'

function LessonQuiz({ lessonId, questions }: LessonQuizProps) {
  const [phase, setPhase] = useState<QuizPhase>('idle')
  const [currentIndex, setCurrentIndex] = useState(0)
  const [score, setScore] = useState(0)
  const { markLessonComplete, isQuizPassed } = useProgress()

  // On mount: if quiz already passed, skip to completed display
  // On correct answer: show explanation, advance to next question
  // On wrong answer: immediately transition to 'failed' state
  // On all correct: transition to 'passed', call markLessonComplete
}
```

### Pattern 3: Fail-Fast Wrong Answer Handling

**What:** When a learner selects a wrong answer, the quiz transitions to `failed` immediately — no explanation shown, no "which one was right" reveal, retake required.

**When to use:** Every question in every quiz.

**Rationale from requirements:** "Wrong answers show no correct answer — learner retakes entire quiz." This is a deliberate retrieval-practice design: the learner must recall the correct answer, not learn it from a correction screen. This is harder and more effective for long-term retention (see: testing effect, spaced repetition research).

**Trade-offs:**
- Pro: Prevents passive "I'll just see which one is highlighted" behavior
- Pro: Simpler component — no "reveal correct/incorrect" logic on wrong answers
- Con: Potentially frustrating if questions 9 of 10 is failed. Mitigate with clear "You must get all 10 correct" messaging before starting.

**Implementation note:** On wrong answer selection, immediately call `setPhase('failed')`. Do not reveal which option was wrong or which was right. Show only a "Not quite — try the full quiz again" message.

### Pattern 4: Correct Answer Explanation Reveal

**What:** When a learner selects the correct answer, an explanation panel slides in below the options. They confirm they've read it and advance to the next question.

**When to use:** Every question when the correct answer is selected.

**Rationale:** The explanation reinforces WHY the answer is correct — this is the elaborative interrogation effect. Explaining the mechanism deepens understanding beyond "I picked the right letter."

**Trade-offs:**
- Pro: Reinforces reasoning, not just fact recall
- Pro: Differentiates from a simple multiple-choice checkbox — the explanation is the value
- Con: Adds a "Continue" button click per question (minor friction)

---

## Data Flow

### Quiz Initialization

```
getLessonContent(moduleSlug, lessonSlug)
        | dynamic import of MDX module
        | mod.quiz = QuizQuestion[] | undefined
        v
page.tsx receives { default, frontmatter, quiz }
        | passes quiz to LessonLayout as prop
        v
LessonLayout renders LessonQuiz only if quiz !== null
        | passes lessonId + questions to LessonQuiz
        v
LessonQuiz mounts
        | checks isQuizPassed(lessonId) from ProgressContext
        | if true: render "quiz complete" state (lesson already unlocked)
        | if false: render "Start Quiz" idle state
```

### Quiz Completion and Lesson Gating

```
Learner answers all questions correctly
        | LessonQuiz phase = 'passed'
        v
LessonQuiz calls markQuizPassed(lessonId)
        | ProgressProvider writes quizPassed: true to localStorage
        | ProgressProvider calls markLessonComplete(lessonId)
        |   lesson.completed = true persisted to 'learn-systems-progress'
        v
ProgressContext re-renders all consumers
        | PrerequisiteBanner on subsequent lessons now shows prerequisites satisfied
        | Module completion percentage updates
        | Dashboard progress updates
```

### Wrong Answer Handling

```
Learner selects wrong answer
        | QuizQuestion receives onWrongAnswer callback from LessonQuiz
        v
LessonQuiz phase transitions: 'active' -> 'failed'
        | No answer revealed, no explanation shown
        v
QuizResult renders failed state
        | Shows "Try again — all questions must be answered correctly"
        | Shows "Retake Quiz" button
        v
Learner clicks Retake
        | LessonQuiz resets: currentIndex=0, score=0, phase='active'
        | Questions presented in same fixed order (not shuffled — content is authored in sequence)
```

### Progress Gating for Next Lessons

```
lesson.completed === true is the single gate for:
  - PrerequisiteBanner (existing — no change)
  - Module completion percent (existing — no change)
  - Dashboard progress bars (existing — no change)

lesson.completed is only set to true when:
  - Quiz exists AND quizPassed === true (new path)
  - Quiz does not exist (quiz === null) AND learner clicks MarkCompleteButton (existing path — kept for lessons pending quiz authoring)
```

---

## Modified Type Contracts

### `types/quiz.ts` (NEW)

```typescript
export interface QuizQuestion {
  id: string                  // unique within lesson, e.g. "q1", "q2"
  question: string            // question text — full sentence, no trailing colon
  options: [string, string, string, string]  // exactly 4 options
  correctIndex: 0 | 1 | 2 | 3               // index into options
  explanation: string         // shown after correct answer — explains WHY, not just confirms
}

export type QuizPhase = 'idle' | 'active' | 'passed' | 'failed'
```

### `types/progress.ts` (MODIFIED)

```typescript
export interface LessonProgress {
  completed: boolean
  completedAt?: string
  exercisesCompleted: string[]
  // NEW:
  quizPassed?: boolean        // optional — absent on existing records (treated as false)
  quizPassedAt?: string       // ISO timestamp
}
```

The `quizPassed` field is optional (`?`), which means:
- All 56 existing lesson progress records in learners' localStorage remain valid with no migration
- A lesson record without `quizPassed` is treated as `quizPassed === false`
- Lessons that have no quiz yet can be completed via `MarkCompleteButton` (quizPassed irrelevant)

---

## Integration Points

### New vs. Modified — Explicit Inventory

**New files:**
| File | What It Does |
|------|-------------|
| `types/quiz.ts` | `QuizQuestion` type, `QuizPhase` type |
| `components/quiz/LessonQuiz.tsx` | Quiz state machine orchestrator |
| `components/quiz/QuizQuestion.tsx` | Single question renderer |
| `components/quiz/QuizResult.tsx` | Pass/fail end screen |

**Modified files:**
| File | What Changes |
|------|-------------|
| `types/progress.ts` | Add `quizPassed?: boolean`, `quizPassedAt?: string` to `LessonProgress` |
| `components/progress/ProgressProvider.tsx` | Add `markQuizPassed`, expose `isQuizPassed`; update `markLessonComplete` to accept quiz-gated path |
| `components/lesson/LessonLayout.tsx` | Accept `quiz: QuizQuestion[] \| null` prop; render `LessonQuiz` below `MDXContent`; gate `MarkCompleteButton` |
| `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` | Extract `quiz` from `getLessonContent`; pass to `LessonLayout` |
| `lib/mdx.ts` | Return `quiz: mod.quiz ?? null` from `getLessonContent` |

**No-touch files (confirmed):**
| File | Why Unchanged |
|------|--------------|
| `next.config.ts` | Named exports work without any plugin change |
| `mdx-components.tsx` | Quiz is layout-level, not MDX-embedded component |
| `content/modules/**/*.mdx` | Adding `export const quiz = [...]` is additive; existing lessons work without it |
| `hooks/useLocalStorage.ts` | Generic hook; no quiz-specific changes needed |
| `types/content.ts` | `LessonFrontmatter` unchanged |
| `components/content/*` | All content components unchanged |
| `components/lesson/PrerequisiteBanner.tsx` | Already reads `progress.lessons[id].completed` — will automatically work once quizPassed gates completion |
| `components/lesson/ScrollProgressBar.tsx` | No change |
| `components/lesson/TableOfContents.tsx` | No change |
| `lib/modules.ts` | No change |
| `lib/progress.ts` | No change — `isModuleComplete` already reads `lesson.completed` correctly |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| MDX → `getLessonContent` | Named export `quiz` extracted via dynamic import | `@next/mdx` supports named exports natively; no pipeline change |
| `page.tsx` → `LessonLayout` | New `quiz` prop (nullable) | `LessonFrontmatter` type unchanged |
| `LessonLayout` → `LessonQuiz` | Props: `lessonId`, `questions` | `LessonLayout` stays server-friendly; `LessonQuiz` is 'use client' |
| `LessonQuiz` → `ProgressContext` | `markQuizPassed`, `isQuizPassed`, `markLessonComplete` via `useProgress()` | `LessonQuiz` is the only new context consumer |
| `LessonQuiz` → `QuizQuestion` | Props: question data, callbacks (`onCorrect`, `onWrong`) | Pure parent-child; `QuizQuestion` has no context reads |
| `LessonQuiz` → `QuizResult` | Props: `phase`, `onRetake` callback | Pure parent-child |
| `ProgressProvider` → localStorage | Extends existing `LessonProgress` records with `quizPassed` | Additive field; backward-compatible with existing stored records |

---

## Build Order

Dependencies determine order. Quiz touches fewer existing systems than v1.1 did.

**Step 1 — Types (no component dependencies)**
- Create `types/quiz.ts` with `QuizQuestion`, `QuizPhase`
- Extend `types/progress.ts`: add `quizPassed?: boolean`, `quizPassedAt?: string` to `LessonProgress`

**Step 2 — Progress context extension (depends on Step 1 types)**
- Add `markQuizPassed(lessonId)` to `ProgressProvider`
- Add `isQuizPassed(lessonId)` to `ProgressProvider`
- Extend `ProgressContextValue` interface
- Verify backward-compatibility: existing `LessonProgress` records without `quizPassed` treated as `false`

**Step 3 — Quiz leaf components (no context reads, no Step 2 dependency)**
- Build `components/quiz/QuizQuestion.tsx` — pure props, no context
- Build `components/quiz/QuizResult.tsx` — pure props, no context

**Step 4 — LessonQuiz orchestrator (depends on Steps 2 + 3)**
- Build `components/quiz/LessonQuiz.tsx`
- Reads `useProgress()` for `markQuizPassed`, `isQuizPassed`, `markLessonComplete`
- Manages `QuizPhase` state machine
- Renders `QuizQuestion` per question; `QuizResult` at end

**Step 5 — MDX data extraction (depends on Step 1 types)**
- Modify `lib/mdx.ts`: extract `mod.quiz ?? null` from dynamic import
- Modify `page.tsx`: pass `quiz` to `LessonLayout`

**Step 6 — LessonLayout integration (depends on Steps 4 + 5)**
- Add `quiz: QuizQuestion[] | null` prop to `LessonLayout`
- Render `<LessonQuiz lessonId={lessonId} questions={quiz} />` below `MDXContent` when `quiz !== null`
- Gate `MarkCompleteButton`: show only when `quiz === null` (unquizzed lessons during rollout)

**Step 7 — Content authoring**
- Add `export const quiz = [...]` to each lesson MDX file
- 56 lessons × 7-10 questions each
- No other MDX changes required

---

## Anti-Patterns

### Anti-Pattern 1: Quiz Data in Frontmatter

**What people do:** Add `quiz:` key to YAML frontmatter with question objects.

**Why it's wrong:** YAML multi-line strings are fragile. Gray-matter parses YAML — question text with apostrophes, colons, special chars requires careful escaping. `LessonFrontmatter` becomes a mixed type (metadata + runtime content). The existing frontmatter validation in `lib/mdx.ts` throws on unexpected fields if the validation is ever tightened.

**Do this instead:** MDX named export. Clean separation: frontmatter = lesson metadata, MDX body = lesson content + quiz data as a JavaScript object literal.

### Anti-Pattern 2: Separate Quiz Files Per Lesson

**What people do:** Create `content/quizzes/[module]/[lesson].json` parallel to MDX files.

**Why it's wrong:** Two-file authoring means updating the lesson might require updating the quiz separately. Content drift is likely. For 56 lessons that is 56 additional files with no structural benefit for a single-author app.

**Do this instead:** `export const quiz = [...]` in the lesson MDX file. Co-located, co-versioned, single edit point.

### Anti-Pattern 3: Quiz as an MDX Component (`<Quiz questions={...} />`)

**What people do:** Register a `Quiz` component in `mdx-components.tsx` and embed `<Quiz questions={[...]} />` inside lesson prose.

**Why it's wrong:** Puts quiz in the middle of lesson content — placement becomes an authoring decision with no standard position. Every lesson has the quiz at a different vertical position. The quiz is a lesson-level concern (it gates completion), not a content-level concern (it is not part of the prose).

**Do this instead:** Quiz is rendered at the layout level by `LessonLayout` after `MDXContent`. Its position is always consistent: bottom of lesson, after hands-on exercise, before (or in place of) `MarkCompleteButton`. Quiz data travels as a named export, not as embedded JSX.

### Anti-Pattern 4: Tracking Per-Question State in localStorage

**What people do:** Persist which questions were answered correctly mid-quiz to support resume-after-refresh.

**Why it's wrong:** Adds persistence complexity for negligible benefit in a local single-session app. The requirement is "wrong answers require retaking the entire quiz" — there is no partial completion concept. Persisting partial state contradicts the pedagogical intent and the explicit retake mechanic.

**Do this instead:** Only `quizPassed: boolean` is persisted. All in-progress state is ephemeral React state in `LessonQuiz`. A refresh resets the quiz to start — this is correct behavior.

### Anti-Pattern 5: Showing the Correct Answer on Wrong Selection

**What people do:** Highlight the correct option in green when the learner picks wrong.

**Why it's wrong:** Explicit requirement: "Wrong answers show no correct answer." Beyond the requirement, this turns the quiz into a flash card — learners can click options to find the right one without retrieval practice. The testing effect requires the learner to actively recall the correct answer.

**Do this instead:** On wrong selection, transition to `failed` state immediately. `QuizResult` (failed) shows only "Not correct — you must answer all questions correctly. Try again." No answer revealed.

### Anti-Pattern 6: Shuffling Question Order

**What people do:** Randomize question order or option order to prevent memorization.

**Why it's wrong:** Questions are authored in a pedagogically meaningful sequence (foundational concept first, nuanced scenario last). Shuffling destroys this intentional ordering. Option order is also authored — "option A is a common misconception" is a deliberate authoring choice, not arbitrary.

**Do this instead:** Fixed order. Questions are presented in exactly the order authored. The explanation reinforces each correct answer, so even retakers benefit from the sequence.

---

## Scaling Considerations

This is a local single-learner app. Scaling axis is content volume (56 lessons × ~8 questions = ~448 quiz questions).

| Concern | Reality | Approach |
|---------|---------|----------|
| Progressive rollout of quiz to all 56 lessons | Lessons without `export const quiz` skip quiz rendering entirely | `quiz === null` path keeps `MarkCompleteButton` — no lesson regresses |
| localStorage record migration | Existing `LessonProgress` lacks `quizPassed` field | Optional field treated as `false`; no migration script needed |
| 56 lessons × ~8 questions bundle impact | Each lesson bundles its own questions in the JS chunk | ~200 bytes × 8 questions = ~1.6KB per lesson chunk; negligible |
| `ProgressContext` re-renders on quiz pass | All context consumers re-render once on `markLessonComplete` | Same as existing `markLessonComplete` behavior — already acceptable |
| Question explanation quality | 56 × 8 = 448 explanations to author | Content policy: each explanation must state the mechanism, not just confirm the answer. Establish in template before authoring. |

---

## Sources

All findings are HIGH confidence — based on direct codebase inspection (2026-03-22):

- `app/modules/[moduleSlug]/[lessonSlug]/page.tsx`
- `lib/mdx.ts` — getLessonContent, dynamic import pattern
- `components/lesson/LessonLayout.tsx`
- `components/lesson/MarkCompleteButton.tsx`
- `components/lesson/PrerequisiteBanner.tsx`
- `components/progress/ProgressProvider.tsx`
- `hooks/useLocalStorage.ts`
- `hooks/useProgress.ts`
- `types/content.ts`
- `types/progress.ts`
- `types/exercises.ts`
- `mdx-components.tsx`
- `next.config.ts`
- `package.json` (next 16.2.0, @next/mdx ^16.2.0, react 19.2.4 confirmed)
- `.planning/PROJECT.md` — v1.2 requirements (100% score gate, wrong-answer no-reveal, quiz-gated completion)
- `content/modules/01-linux-fundamentals/01-how-computers-work.mdx` — representative lesson structure

---

*Architecture research for: quiz/assessment integration (v1.2 milestone)*
*Researched: 2026-03-22*
