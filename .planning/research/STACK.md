# Stack Research

**Domain:** Multiple-choice quiz system — v1.2 additions to existing interactive DevOps course app
**Researched:** 2026-03-22
**Confidence:** HIGH (all integration points verified by direct codebase inspection; no external library evaluation needed because none are required)

---

## Context: What Already Exists (Do Not Re-Research)

Next.js 16.2, React 19.2.4, Tailwind v4, shadcn/ui via `@base-ui/react` 1.3.0, MDX with `rehype-pretty-code`, `useLocalStorage<T>` SSR-safe hook, `ProgressProvider` context with `ProgressState`/`LessonProgress` types, `MarkCompleteButton` lesson completion flow, existing color tokens (`green-400`, `red-400`, `amber-400`) and icon set (`lucide-react` 0.577.0). Vitest 4.1.0 + Testing Library for tests.

This STACK.md covers only what is **new or changed** for v1.2.

---

## Executive Verdict

**Zero new npm dependencies required.**

Quiz functionality is a pure state machine component with localStorage persistence. Every required capability — controlled React state, localStorage persistence, accessible UI primitives, icon set, color tokens, TypeScript type system — is already installed and verified in the project. The entire feature is three internal deliverables: new TypeScript types, one new `QuizCard` component, and targeted extensions to the progress system.

---

## Recommended Stack (New/Changed Only)

### No New npm Packages

| Capability Needed | Existing Asset | Location |
|-------------------|---------------|----------|
| Quiz session state machine | `useState` (React 19) | Built-in |
| Quiz result persistence | `useLocalStorage<T>` | `hooks/useLocalStorage.ts` |
| Cross-component quiz gate check | `ProgressContext` | `components/progress/ProgressProvider.tsx` |
| Answer option buttons | `Button` | `components/ui/button.tsx` |
| Score/pass badges | `Badge` | `components/ui/badge.tsx` |
| Question progress indicator | `Progress` | `components/ui/progress.tsx` |
| Correct/wrong state colors | Tailwind tokens: `green-400/10`, `red-400/10` | Already used in `LessonLayout.tsx` |
| Feedback icons | `CheckCircle2`, `XCircle`, `RotateCcw` | `lucide-react` 0.577.0 |
| Slide/fade transitions | `tw-animate-css` | `tw-animate-css` 1.4.0 |
| Quiz question schema | TypeScript interfaces | New types in `types/progress.ts` and/or `types/quiz.ts` |
| Component unit tests | Vitest + Testing Library | `vitest` 4.1.0, `@testing-library/react` 16.3.2 |

---

## Internal Deliverables (No npm Install)

### 1. Type Extensions

**`types/progress.ts`** — add two optional fields to `LessonProgress`. Both are optional to preserve backward compatibility with existing serialized localStorage data:

```typescript
export interface LessonProgress {
  completed: boolean
  completedAt?: string
  exercisesCompleted: string[]
  quizPassed?: boolean       // NEW: true after 100% quiz score
  quizPassedAt?: string      // NEW: ISO date string for future analytics
}
```

**`types/quiz.ts`** (new file) — quiz question schema:

```typescript
export interface QuizQuestion {
  q: string             // Question text
  options: string[]     // 4 answer strings, index matches `correct`
  correct: number       // 0-based index of correct option
  explanation: string   // Shown after correct answer; never shown on wrong
}
```

**`types/content.ts`** — add optional `quiz` field to `LessonFrontmatter`:

```typescript
quiz?: QuizQuestion[]
```

### 2. `QuizCard` Component

**`components/content/QuizCard.tsx`** — new client component. Self-contained state machine. Uses `useState` for all quiz session state.

State phases: `idle → answering → graded-correct → graded-wrong → passed | failed`

Behavior contract:
- Wrong answer: reveal failure feedback (no correct answer shown), reset to `idle` after confirm (forces full retake)
- Correct answer: reveal explanation, advance after confirm
- 100% score: call `markQuizPassed(lessonId)` from ProgressContext, render pass state
- Persists `quizPassed` to localStorage via ProgressContext — survives page reload

Props:
```typescript
interface QuizCardProps {
  lessonId: string
  questions: QuizQuestion[]
}
```

### 3. `ProgressProvider` Extension

**`components/progress/ProgressProvider.tsx`** — add `markQuizPassed(lessonId: LessonId)` action to context:

```typescript
// Addition to ProgressContextValue
markQuizPassed: (lessonId: LessonId) => void
```

Implementation: sets `quizPassed: true` and `quizPassedAt` on the lesson entry. Does not call `markLessonComplete` — those are separate actions. Lesson completion is handled by the existing `MarkCompleteButton` flow.

### 4. `LessonLayout` Integration

**`components/lesson/LessonLayout.tsx`** — insert `<QuizCard>` between MDX content and `<MarkCompleteButton>`:

```tsx
{frontmatter.quiz && frontmatter.quiz.length > 0 && (
  <QuizCard lessonId={lessonId} questions={frontmatter.quiz} />
)}
<MarkCompleteButton lessonId={lessonId} />
```

`MarkCompleteButton` reads `progress.lessons[lessonId]?.quizPassed` to gate the completion button: disabled or hidden until quiz is passed (when a quiz is present).

### 5. MDX Frontmatter Authoring Pattern

Questions live in MDX frontmatter — parsed by existing `gray-matter` 4.0.3. No new file format or loader:

```yaml
quiz:
  - q: "What does the -l flag do in ls -l?"
    options:
      - "Lists files in long format"
      - "Lists hidden files only"
      - "Lists files recursively"
      - "Limits output to 10 lines"
    correct: 0
    explanation: "-l enables long listing format, showing permissions, owner, size, and modification time for each file."
```

This is standard YAML nested array-of-objects syntax. Verified: `gray-matter` already parses frontmatter with arrays (`prerequisites`, `tags`) throughout the project — quiz arrays are the same structure.

---

## What NOT to Add

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Any quiz library (`react-quiz-component`, `react-quiz-lib`, etc.) | Opinionated DOM structure and styling that fights the existing design system; adds bundle weight for a feature that is ~120 lines of bespoke state machine code | Plain `useState` + `QuizCard` component |
| Zustand, Jotai, Recoil | Global state management is already handled by `ProgressContext`; quiz session state is component-local and does not need to be shared across routes | `useState` in `QuizCard` + `ProgressContext` for persistence |
| Framer Motion | Project already has `tw-animate-css` 1.4.0 for transitions; adding a 100KB motion library for slide/fade on a quiz card is unnecessary | `tw-animate-css` utilities or Tailwind `transition-*` classes |
| `react-hook-form` | Quiz is a controlled state machine, not a form submission flow; `useForm` is the wrong abstraction | `useState` for selected option tracking |
| Separate localStorage key per lesson quiz | Key proliferation; the global `resetProgress()` in `ProgressProvider` would not clear quiz data, leaving stale state | Extend existing `LessonProgress` with `quizPassed` field inside `PROGRESS_STORAGE_KEY` |
| `@radix-ui/react-*` primitives | Not installed; project uses `@base-ui/react` 1.3.0 exclusively for UI primitives | `@base-ui/react` `Button`, `Badge`, etc. |
| Server-side quiz answer validation / API route | Project constraint: no backend; single-learner local app | Client-side validation; answers defined in frontmatter |

---

## Installation

```bash
# No new packages — nothing to install
```

---

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Question storage | MDX frontmatter (gray-matter, existing) | Separate `.json` files per lesson | Requires new file-discovery logic in `lib/mdx.ts`; splits content from lesson; adds complexity with zero benefit |
| Question storage | MDX frontmatter | TypeScript data files imported in MDX | MDX import resolution through `@next/mdx` works, but adds boilerplate per lesson (56 separate import files). Frontmatter is authoring-friendly and already parsed |
| Quiz session state | `useState` (flat states) | `useReducer` | Either is valid; `useReducer` is preferred for complex state graphs. This quiz has 5 phases — `useState` is sufficient and easier to test. Revisit if quiz complexity grows |
| Pass/fail persistence | Extend `LessonProgress` in existing key | New `learn-systems-quiz` localStorage key | Fragmented state: existing `resetProgress()` would not clear quiz state, making the progress reset feature incorrect |
| Completion gating | `MarkCompleteButton` checks `quizPassed` before enabling | `markLessonComplete` internally checks `quizPassed` gate | Surface the gate at the UI layer (`MarkCompleteButton`) rather than silently blocking in the action — clearer to the learner and easier to debug |

---

## Version Compatibility

No new packages, so no new compatibility surface. Confirmed against quiz requirements:

| Package | Installed Version | Quiz Compatibility |
|---------|------------------|--------------------|
| `gray-matter` | ^4.0.3 | Parses nested YAML arrays-of-objects in frontmatter — confirmed by existing `prerequisites` and `tags` arrays in lesson frontmatter |
| `@base-ui/react` | ^1.3.0 | `Button`, `Badge`, `Progress` components handle controlled selected/disabled states for answer options |
| `lucide-react` | ^0.577.0 | `CheckCircle2` (correct answer), `XCircle` (wrong answer), `RotateCcw` (retake prompt) — all present in this version |
| `tw-animate-css` | ^1.4.0 | CSS animation classes for state transitions (fade in explanation, slide feedback panel) |
| `vitest` | ^4.1.0 | Unit-testable state machine: `scoreQuiz`, option selection, pass/fail gating logic all testable without DOM |
| `@testing-library/react` | ^16.3.2 | Component integration tests for `QuizCard` interaction flow (click option, see feedback, advance, retake) |

---

## Sources

- Direct inspection of `package.json` — all installed package versions confirmed — HIGH confidence
- Direct inspection of `hooks/useLocalStorage.ts` — SSR-safe hook pattern; `[value, setValue, isHydrated]` return type — HIGH confidence
- Direct inspection of `components/progress/ProgressProvider.tsx` — `ProgressContextValue` interface, `markLessonComplete`/`markExerciseComplete` action pattern — HIGH confidence
- Direct inspection of `types/progress.ts` — `LessonProgress` interface, `PROGRESS_STORAGE_KEY`, `INITIAL_PROGRESS` — HIGH confidence
- Direct inspection of `components/lesson/LessonLayout.tsx` — insertion point for `QuizCard` between content and `MarkCompleteButton`; existing `green-400/10` and `red-400/10` color tokens in use — HIGH confidence
- Direct inspection of `components/lesson/MarkCompleteButton.tsx` — `isHydrated` guard pattern, `useProgress()` hook call — HIGH confidence
- Direct inspection of `components/ui/` — `Button`, `Badge`, `Progress` available; no `Alert` or `Toast` component present (quiz feedback uses inline state, not toast notifications) — HIGH confidence
- Direct inspection of `components/content/ScenarioQuestion.tsx` — `useState` expand/collapse pattern; confirms the established pattern for inline interactive components — HIGH confidence
- YAML nested array spec + `gray-matter` usage with arrays in existing frontmatter (`prerequisites`, `tags`) — quiz array format is identical — HIGH confidence

---

*Stack research for: v1.2 quiz feature — multiple-choice quiz system for interactive DevOps course*
*Researched: 2026-03-22*
