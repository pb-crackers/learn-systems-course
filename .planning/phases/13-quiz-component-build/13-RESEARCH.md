# Phase 13: Quiz Component Build - Research

**Researched:** 2026-03-22
**Domain:** React useReducer state machine, interactive quiz UI, Vitest unit testing
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Question Presentation Flow**
- One question displayed at a time — focused attention, matches retrieval practice pedagogy
- Wrong answer triggers immediate retake — quiz resets to question 1 with "Incorrect" flash, no partial progress saved
- Progress shown as "Question 3 of 8" text — minimal, matches existing UI density
- No back navigation — forward-only reinforces commitment to answers

**Feedback & Pass Screen**
- Incorrect feedback: inline red banner below selected answer — "Incorrect — quiz will restart from question 1" with 2s auto-dismiss then reset
- Correct feedback: green highlight on selected option + explanation paragraph below — stays visible until "Next Question" clicked
- Pass screen: celebratory card with checkmark icon, attempt count display, and "Continue to Next Lesson" button
- Attempt counter: subtle text below quiz title — "Attempt 2" — always visible during quiz

**Component Architecture**
- State machine via useReducer with explicit states: idle, active, failed, passed
- Single Quiz component file with internal sub-components (QuizQuestion, QuizFeedback, QuizPassScreen) as non-exported helpers
- File location: components/lesson/Quiz.tsx
- Fixture data: hardcoded in test file + one MDX lesson for manual testing

### Claude's Discretion
- Exact Tailwind styling choices within the established design system patterns
- Internal state shape beyond the four explicit phases
- Test organization and helper utilities
- Animation/transition details for feedback display

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| QUIZ-01 | User sees 7-10 multiple choice questions at the bottom of each lesson page after the exercise | Single Quiz component with QuizQuestion[] prop; fixture array of 7-10 items in test file enables standalone verification without layout integration (Phase 14 handles placement) |
| QUIZ-02 | User selects one answer per question and sees "Incorrect" with no correct answer revealed on wrong selection | useReducer `failed` state + inline red banner; correctIndex never shown in incorrect feedback branch |
| QUIZ-03 | User sees an explanation reinforcing the reasoning when answering correctly | useReducer `answeredCorrect` sub-state shows `question.explanation` paragraph below green-highlighted option |
| QUIZ-04 | User must retake the entire quiz when any answer is wrong | Reducer resets `currentIndex` to 0 on wrong answer; 2s timeout then transitions back to `active` state at question 0 |
| QUIZ-05 | User sees how many attempts they have made on the current quiz | Local `attempts` counter in reducer state; incremented on every START action; displayed as "Attempt N" below quiz title |
| QUIZ-06 | User sees a "Continue to Next Lesson" button after passing the quiz with 100% | Reducer transitions to `passed` state after correct answer on last question; QuizPassScreen renders with button + attempt count |
</phase_requirements>

---

## Summary

Phase 13 builds a self-contained interactive quiz component using React's `useReducer` for explicit state machine management. The four named states (idle, active, failed, passed) map directly to distinct UI renders, making the component straightforward to reason about and test. All infrastructure from Phase 12 is already in place: `QuizQuestion` type (with 4-tuple options), `LessonProgress` with `quizAttempts`/`quizPassed` fields, and `markQuizPassed`/`isQuizPassed` context methods on `ProgressProvider`.

The implementation is a single file (`components/lesson/Quiz.tsx`) containing internal sub-components. No new libraries are required — the existing stack (Tailwind semantic tokens, `lucide-react` icons, `Button` component from `@base-ui/react`, `useProgress` hook) covers everything. The 2-second auto-dismiss on incorrect feedback is the only timing concern; it must be cleared on unmount to avoid state-update-after-unmount errors.

Testing uses Vitest + `@testing-library/react` (already installed) to cover all state machine transitions. The success criterion explicitly requires all transitions be covered with no failures.

**Primary recommendation:** Build the reducer and its type definitions first, write unit tests against the pure reducer function (no DOM needed), then build the UI layer and integration tests on top.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| React `useReducer` | React 19.2.4 (installed) | State machine for quiz phases | Explicit action types make all transitions testable; useState would require scattered boolean flags |
| Tailwind CSS v4 | 4.x (installed) | Styling with semantic tokens | Project standard — `bg-destructive/10`, `text-destructive`, `bg-green-500/10`, `text-green-400` match existing component patterns |
| `lucide-react` | 0.577.0 (installed) | Icons (CheckCircle2, AlertCircle, ChevronRight, Trophy) | Already imported by MarkCompleteButton and ExerciseCard |
| `@base-ui/react` Button | 1.3.0 (installed) | "Next Question" and "Continue to Next Lesson" buttons | Project's Button component wraps this with CVA variants |
| Vitest + @testing-library/react | Vitest 4.1.0, RTL 16.3.2 (installed) | Unit tests for reducer and component integration | Configured in vitest.config.ts with jsdom environment |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `@testing-library/user-event` | 14.6.1 (installed) | Simulate clicks in integration tests | Use for answer selection and button click tests |
| `cn` from `@/lib/utils` | project utility | Conditional Tailwind class merging | Use for option highlight (correct = green, neutral = default) |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `useReducer` | `useState` with multiple booleans | useState scatters state across 4-5 flags; useReducer makes all valid transitions explicit and testable as a pure function |
| Internal sub-components | Separate exported files | Context decided single file; sub-components as non-exported helpers keep the API surface clean for Phase 14 |

**Installation:** No new packages required. All dependencies are already installed.

---

## Architecture Patterns

### Recommended Project Structure

```
components/lesson/
└── Quiz.tsx          # Single file: QuizState type, quizReducer, Quiz (default export),
                      #   QuizQuestion (internal), QuizFeedback (internal), QuizPassScreen (internal)

components/lesson/__tests__/
└── Quiz.test.tsx     # Reducer unit tests + component integration tests

# Fixture data (no new file needed — inline in test and one MDX file for manual smoke test)
```

### Pattern 1: useReducer State Machine

**What:** All quiz state lives in a single reducer. The `QuizMachineState` discriminated union enforces that only valid data is present in each phase.

**When to use:** Any time a component has multiple named modes with different data requirements. Prevents impossible states (e.g., "showing explanation when no question is answered").

**Example:**
```typescript
// Source: project pattern (ExerciseCard uses useState for simpler expand/collapse;
//         quiz needs richer state with currentIndex + attempts so useReducer is correct)

type QuizMachineState =
  | { phase: 'idle' }
  | { phase: 'active'; currentIndex: number; attempts: number }
  | { phase: 'answering'; currentIndex: number; attempts: number; selectedIndex: number; isCorrect: boolean }
  | { phase: 'failed'; attempts: number }
  | { phase: 'passed'; attempts: number }

type QuizAction =
  | { type: 'START' }
  | { type: 'SELECT_ANSWER'; selectedIndex: number; correctIndex: number; isLast: boolean }
  | { type: 'NEXT_QUESTION' }
  | { type: 'RESET' }
  | { type: 'CONFIRM_PASS' }

function quizReducer(state: QuizMachineState, action: QuizAction): QuizMachineState {
  switch (action.type) {
    case 'START':
      return { phase: 'active', currentIndex: 0, attempts: state.phase === 'idle' ? 1 : (state as any).attempts + 1 }
    // ... etc
  }
}
```

**Key insight on `attempts`:** The local `attempts` counter in reducer state tracks display ("Attempt 2"). The `quizAttempts` field in `ProgressProvider` (incremented by `markQuizPassed`) tracks persistence. These are separate concerns — do not conflate them.

### Pattern 2: 2-Second Auto-Dismiss Timer

**What:** `useEffect` with `setTimeout` inside the `failed` phase renders. Must return a cleanup function.

**When to use:** Any timed UI transition where the component might unmount before the timer fires.

**Example:**
```typescript
// Inside Quiz component, when phase === 'failed'
useEffect(() => {
  if (state.phase !== 'failed') return
  const id = setTimeout(() => {
    dispatch({ type: 'START' })
  }, 2000)
  return () => clearTimeout(id)
}, [state.phase])
```

### Pattern 3: isHydrated Guard

**What:** Check `isHydrated` from `useProgress()` before rendering quiz UI that depends on progress state. Matches existing MarkCompleteButton pattern.

**When to use:** Any client component that reads from localStorage-backed context.

**Example:**
```typescript
// Source: components/lesson/MarkCompleteButton.tsx (lines 16-17)
const { markQuizPassed, isQuizPassed, isHydrated } = useProgress()
if (!isHydrated) return null
```

### Pattern 4: Non-Exported Internal Sub-Components

**What:** Define `QuizQuestion`, `QuizFeedback`, and `QuizPassScreen` as regular functions inside `Quiz.tsx` — no `export` keyword. Only `Quiz` (or `function Quiz`) is exported.

**When to use:** When sub-components are implementation details with no standalone use case. Keeps Phase 14's import clean: `import { Quiz } from '@/components/lesson/Quiz'`.

**Example:**
```typescript
// Internal — not exported
function QuizPassScreen({ attempts, lessonId, onContinue }: PassScreenProps) { ... }

// Exported
export function Quiz({ questions, lessonId }: QuizProps) { ... }
```

### Anti-Patterns to Avoid

- **Storing `correctIndex` in failed state:** The incorrect feedback must NOT reveal the correct answer (QUIZ-02). Never pass `correctIndex` to the feedback banner render path.
- **Forgetting to clear setTimeout:** Returning no cleanup from the 2s timer `useEffect` causes "Can't perform a React state update on an unmounted component" warnings. Always return `() => clearTimeout(id)`.
- **Deriving attempt count from ProgressProvider in the quiz UI:** `progress.lessons[lessonId]?.quizAttempts` only updates after a pass. The in-session attempt count must come from local reducer state so it updates on every retake including failed ones.
- **Using `isQuizPassed` to gate the quiz render:** `isQuizPassed` is for Phase 14 (layout integration). The Quiz component itself should show the pass screen after a successful run, not skip rendering based on previous pass history.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Button with variants | Custom button element | `Button` from `@/components/ui/button` | CVA variants (default, outline) already match design system |
| Icon components | SVG inline | `lucide-react` (CheckCircle2, AlertCircle, ChevronRight, Trophy) | Already installed, consistent sizing with `[&_svg:not([class*='size-'])]:size-4` |
| Conditional class merging | Manual string concatenation | `cn()` from `@/lib/utils` | Handles Tailwind conflict resolution |
| localStorage reads | Direct `window.localStorage` | `useProgress()` hook → `markQuizPassed`, `isQuizPassed` | Already abstracted with hydration safety |

**Key insight:** Phase 12 delivered exactly the context API this phase needs. Do not re-implement any progress persistence logic.

---

## Common Pitfalls

### Pitfall 1: Correct Answer Leakage in Failed State
**What goes wrong:** Developer passes `correctIndex` to the `QuizFeedback` component "just in case" and renders it accidentally.
**Why it happens:** It seems natural to show what was wrong. REQUIREMENTS.md explicitly marks this out of scope.
**How to avoid:** The `failed` state in the reducer should NOT store `correctIndex`. The banner text is fixed: "Incorrect — quiz will restart from question 1".
**Warning signs:** Any render path that compares `selectedIndex === correctIndex` in the failed banner.

### Pitfall 2: Stale Closure on Timeout Dispatch
**What goes wrong:** `dispatch` captured in a `setTimeout` runs after the component tree changes state, causing unexpected transitions.
**Why it happens:** `dispatch` from `useReducer` is stable across renders (React guarantees this), so this is NOT actually a risk — but only if you use `dispatch` directly, not a derived value.
**How to avoid:** Dispatch actions (`{ type: 'START' }`), never dispatch derived values computed before the timeout fires.

### Pitfall 3: Attempt Counter Off-by-One
**What goes wrong:** "Attempt 1" shows before the learner has actually attempted, or the first retake shows "Attempt 1" instead of "Attempt 2".
**Why it happens:** Unclear when to increment — on START or on SUBMIT.
**How to avoid:** Increment on `START` action (when the learner begins or restarts the quiz). The first `START` dispatch sets `attempts: 1`. Each `RESET` + `START` cycle increments.

### Pitfall 4: Test Relies on setTimeout Ticking
**What goes wrong:** Integration tests that expect the quiz to auto-reset after 2 seconds hang or become flaky.
**Why it happens:** Real timers in jsdom don't reliably align with test execution.
**How to avoid:** Use Vitest's fake timers (`vi.useFakeTimers()`, `vi.advanceTimersByTime(2000)`) in tests that verify the auto-reset behavior. Alternatively, test the reducer transition directly without DOM — preferred because it's faster.

### Pitfall 5: Reducer Tests Require DOM Setup
**What goes wrong:** Developer writes reducer tests inside a `renderHook` or `render` call when the reducer is a pure function.
**Why it happens:** Pattern cargo-culting from React component tests.
**How to avoid:** Test `quizReducer` directly as a pure function: `expect(quizReducer(initialState, { type: 'START' })).toEqual(...)`. No `render` needed. Reserve `@testing-library/react` for integration tests of click interactions.

---

## Code Examples

Verified patterns from existing project code:

### useProgress Hook Consumption (from MarkCompleteButton.tsx lines 13-16)
```typescript
// Source: components/lesson/MarkCompleteButton.tsx
const { progress, markLessonComplete, isHydrated } = useProgress()
if (!isHydrated) return null
```

### Semantic Color Tokens in Use (from ExerciseCard.tsx lines 11-15)
```typescript
// Source: components/content/ExerciseCard.tsx
const DIFFICULTY_CONFIG = {
  Foundation: { classes: 'bg-green-500/10 text-green-400 border-green-500/30' },
  Intermediate: { classes: 'bg-amber-500/10 text-amber-400 border-amber-500/30' },
  Challenge:    { classes: 'bg-red-500/10 text-red-400 border-red-500/30' },
}
```
Apply same pattern for quiz feedback: green for correct (`bg-green-500/10 text-green-400`), red for incorrect (`bg-red-500/10 text-red-400` or `bg-destructive/10 text-destructive`).

### Button Import (from button.tsx)
```typescript
// Source: components/ui/button.tsx
import { Button } from '@/components/ui/button'
// Variants: 'default' | 'outline' | 'secondary' | 'ghost' | 'destructive' | 'link'
// Sizes: 'default' | 'xs' | 'sm' | 'lg' | 'icon' | 'icon-xs' | 'icon-sm' | 'icon-lg'
```

### Vitest Test File Shape (from lib/__tests__/progress.test.ts)
```typescript
// Source: lib/__tests__/progress.test.ts
import { isLessonComplete } from '../progress'

describe('isLessonComplete', () => {
  it('returns false for undefined', () => {
    expect(isLessonComplete(undefined)).toBe(false)
  })
})
```
Quiz reducer tests follow the same structure, importing `quizReducer` from `'../Quiz'` (or a separate `quizReducer.ts` if extracted).

### markQuizPassed Usage (from ProgressProvider.tsx lines 97-115)
```typescript
// Source: components/progress/ProgressProvider.tsx
// markQuizPassed sets completed:true AND increments quizAttempts
// Call this ONLY on successful quiz completion (all questions answered correctly)
markQuizPassed(lessonId)
// This sets: { completed: true, quizPassed: true, quizPassedAt: ISO, quizAttempts: prev+1 }
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `useState` booleans for multi-mode UI | `useReducer` with discriminated union | Phase 13 decision (CONTEXT.md) | All state transitions explicit and testable as pure functions |
| Separate exported sub-components | Internal non-exported helpers in single file | Phase 13 decision (CONTEXT.md) | Clean import surface for Phase 14 |
| MarkCompleteButton for all lessons | Quiz pass screen with "Continue" button for quiz-enabled lessons | v1.2 milestone decision | MarkCompleteButton stays for quiz=null lessons (Phase 14 handles split) |

**Note on Next.js 16:** CLAUDE.md / AGENTS.md warns this version has breaking changes from training data. Phase 13 is purely a React component with no Next.js-specific APIs (no `page.tsx`, no server actions, no routing). The only Next.js surface is the `'use client'` directive — already used by every interactive component in the project.

---

## Open Questions

1. **Does Quiz need a `markQuizAttempt` for failed attempts?**
   - What we know: CONTEXT.md (Phase 12 plan note) says "Phase 13 will add a separate `markQuizAttempt` for failed attempts." The current `markQuizPassed` only records passing attempts.
   - What's unclear: Whether the QUIZ-05 requirement ("user sees how many attempts") needs persistence across page reloads, or just within a session.
   - Recommendation: Display attempt count from local reducer state (session-only). Persist only via `markQuizPassed` on pass. If persistence-across-reloads is needed, add a `markQuizAttempt` method to `ProgressProvider` — but this is a Phase 14+ concern. Success criteria for QUIZ-05 only says "visible in the UI"; session-only is sufficient.

2. **`lessonId` prop: required or optional?**
   - What we know: The Quiz component needs to call `markQuizPassed(lessonId)` on pass. Phase 14 will provide the real `lessonId`. Phase 13 uses fixture data for testing.
   - Recommendation: Make `lessonId` a required prop (`string`). The fixture in test files can use any string (e.g., `'test-lesson'`). This keeps the component contract clean for Phase 14 integration.

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.0 + @testing-library/react 16.3.2 |
| Config file | `vitest.config.ts` (project root) |
| Quick run command | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` |
| Full suite command | `npx vitest run` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| QUIZ-01 | Quiz renders first question from questions array | unit (reducer) + integration | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` | ❌ Wave 0 |
| QUIZ-02 | Wrong answer shows "Incorrect" banner, correctIndex never appears in banner | unit (reducer) + integration | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` | ❌ Wave 0 |
| QUIZ-03 | Correct answer shows explanation paragraph | unit (reducer) + integration | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` | ❌ Wave 0 |
| QUIZ-04 | Wrong answer resets currentIndex to 0 | unit (reducer) | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` | ❌ Wave 0 |
| QUIZ-05 | Attempt counter increments on each retake and is visible | unit (reducer) + integration | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` | ❌ Wave 0 |
| QUIZ-06 | Pass screen renders with "Continue to Next Lesson" after all correct | unit (reducer) + integration | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` | ❌ Wave 0 |

### Sampling Rate
- **Per task commit:** `npx vitest run components/lesson/__tests__/Quiz.test.tsx`
- **Per wave merge:** `npx vitest run`
- **Phase gate:** Full suite green before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `components/lesson/__tests__/Quiz.test.tsx` — covers QUIZ-01 through QUIZ-06
- [ ] `components/lesson/__tests__/` directory — does not exist yet

---

## Sources

### Primary (HIGH confidence)
- Direct code inspection of `types/quiz.ts`, `types/progress.ts`, `lib/progress.ts`, `components/progress/ProgressProvider.tsx` — all Phase 12 artifacts, confirmed present and matching CONTEXT.md specifications
- Direct code inspection of `components/content/ExerciseCard.tsx`, `components/lesson/MarkCompleteButton.tsx`, `components/content/ScenarioQuestion.tsx` — established patterns for `useProgress`, Tailwind tokens, `'use client'` directive
- `vitest.config.ts` and `package.json` — confirmed Vitest 4.1.0, jsdom environment, `@testing-library/react` 16.3.2 installed
- `lib/__tests__/progress.test.ts` — confirmed test file structure, `describe`/`it` pattern, no mocking framework

### Secondary (MEDIUM confidence)
- React 19 `useReducer` stable dispatch reference — well-established React behavior, confirmed by inspection of existing `useCallback([setProgress])` patterns in ProgressProvider

### Tertiary (LOW confidence)
- None — all findings verified against project source

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all packages confirmed installed in package.json, all APIs confirmed in existing components
- Architecture: HIGH — directly mirrors locked decisions in CONTEXT.md, grounded in Phase 12 delivered artifacts
- Pitfalls: HIGH — derived from code inspection and established React patterns (timer cleanup, pure reducer testing)

**Research date:** 2026-03-22
**Valid until:** 2026-04-22 (stable React + Vitest patterns; no fast-moving dependencies)
