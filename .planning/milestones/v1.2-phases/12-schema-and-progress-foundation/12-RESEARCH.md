# Phase 12: Schema and Progress Foundation - Research

**Researched:** 2026-03-22
**Domain:** TypeScript type definitions, localStorage schema migration, React context extension
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
None — all implementation choices are at Claude's discretion.

### Claude's Discretion
All implementation choices are at Claude's discretion — pure infrastructure phase.

### Deferred Ideas (OUT OF SCOPE)
None.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| DATA-01 | Quiz questions defined as typed MDX named exports with validated TypeScript schema | `types/quiz.ts` creates the validated schema; downstream MDX authors `export const quiz` typed against it |
| DATA-02 | Quiz type schema locked (question text, options array, correct index, explanation) before content authoring begins | `QuizQuestion` interface with `id`, `question`, `options[4]`, `correctIndex`, `explanation`; `QuizPhase` type wraps the array |
| GATE-02 | Existing completed lessons remain complete after v1.2 upgrade (grandfather rule) | `isLessonComplete` must treat `completed: true && quizPassed === undefined` as complete; covered by migration guard in ProgressProvider |
| GATE-03 | Lessons without quiz data retain current completion behavior | `MarkCompleteButton` reads `completed` directly — no change needed; quiz fields are optional so absence is structurally equivalent to null |
</phase_requirements>

---

## Summary

Phase 12 is a pure TypeScript infrastructure phase: create `types/quiz.ts` and extend the existing progress layer (`types/progress.ts`, `components/progress/ProgressProvider.tsx`) with three new optional fields plus two new context methods. No UI, no quiz logic, no MDX changes.

The codebase already has a clean, auditable pattern for this work. `LessonProgress` uses optional fields (`completedAt?: string`) and `ProgressState.version` was deliberately introduced to support schema migrations. `ProgressContextValue` follows a named-method contract — adding `markQuizPassed` and `isQuizPassed` follows the exact same pattern as the existing `markLessonComplete` and `markExerciseComplete`.

The one non-trivial design decision is the grandfather rule for GATE-02: any lesson record with `completed: true` and no `quizPassed` field must remain logically complete. This is implemented via an `isLessonComplete` helper that reads `completed && quizPassed !== false` rather than `completed && quizPassed === true`. Version bump from `1` to `2` documents that the schema changed but does NOT trigger a wipe — the shape is purely additive.

**Primary recommendation:** Write `isLessonComplete` as a standalone pure function in `lib/progress.ts`, add `QuizQuestion` and `QuizPhase` to a new `types/quiz.ts`, extend `LessonProgress` with three optional fields, bump `ProgressState.version` to `2`, and add two callbacks to `ProgressContextValue`. All downstream phases (`13`, `14`, `15`) depend on this contract being stable — keep it minimal and do not add quiz UI logic here.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| TypeScript | ^5 (project) | Type definitions, `tsc --noEmit` gate | Already the project language; strict mode enabled |
| React + useCallback | 19.2.4 (project) | New context callbacks | Matches existing `markLessonComplete` / `markExerciseComplete` pattern |
| Vitest | ^4.1.0 (project) | Unit tests for `isLessonComplete` | Already configured; `vitest run` passes in ~2s |

No new packages required. This phase adds zero dependencies.

**Version verification:** All versions confirmed from `package.json` — no npm lookup needed.

---

## Architecture Patterns

### Files Changed in This Phase
```
types/
├── quiz.ts          # NEW — QuizQuestion, QuizPhase
└── progress.ts      # EXTEND — 3 new fields on LessonProgress, version → 2

components/progress/
└── ProgressProvider.tsx  # EXTEND — markQuizPassed, isQuizPassed on context

lib/
└── progress.ts      # EXTEND — isLessonComplete pure helper

lib/__tests__/
└── progress.test.ts # EXTEND — tests for isLessonComplete
```

### Pattern 1: Optional-Field Extension on LessonProgress
**What:** Add three optional fields to the existing interface without breaking callers.
**When to use:** Any time the progress schema must grow while old localStorage blobs must remain valid.
**Example:**
```typescript
// Source: types/progress.ts (existing pattern)
export interface LessonProgress {
  completed: boolean
  completedAt?: string        // existing optional
  exercisesCompleted: string[]

  // NEW in v1.2 — all optional so pre-v1.2 records remain valid
  quizPassed?: boolean
  quizPassedAt?: string       // ISO date string, set when quizPassed becomes true
  quizAttempts?: number       // missing field treated as 0 at read sites
}
```
Note: `quizAttempts` is `number | undefined` in the interface but callers must treat `undefined` as `0`. A getter helper avoids scattered `?? 0` coercions at every read site.

### Pattern 2: Version Bump WITHOUT Migration Wipe
**What:** Bump `ProgressState.version` from `1` to `2` to document the schema change without resetting user data.
**When to use:** Additive-only changes where old shape is still valid as new shape (undefined fields are acceptable).
**Example:**
```typescript
// types/progress.ts
export const INITIAL_PROGRESS: ProgressState = {
  lessons: {},
  version: 2,   // bumped; old blobs at version: 1 remain valid
}
```
The `useLocalStorage` hook deserializes whatever is stored. Because all new fields are optional, a `version: 1` record in localStorage loads cleanly as a valid `LessonProgress` — no migration function needed.

### Pattern 3: Grandfather Rule via isLessonComplete
**What:** Pure function that encodes the completion logic for GATE-02 and GATE-03.
**When to use:** Anywhere a lesson's "done" state must be determined — replaces direct `progress.lessons[id]?.completed` reads over time.
**Example:**
```typescript
// lib/progress.ts
/**
 * A lesson is considered complete if:
 * - completed === true AND
 * - quizPassed is not explicitly false (undefined = pre-v1.2 record, treated as passed)
 * This implements the grandfather rule: pre-v1.2 records are never silently reset.
 */
export function isLessonComplete(lesson: LessonProgress | undefined): boolean {
  if (!lesson) return false
  return lesson.completed === true && lesson.quizPassed !== false
}
```
This is the critical GATE-02 implementation. The logic `quizPassed !== false` means:
- `quizPassed: undefined` (old record, no quiz field) → `true` (grandfathered)
- `quizPassed: true` (passed quiz in v1.2) → `true`
- `quizPassed: false` (attempted but not yet passed) → `false`

### Pattern 4: Context Method Pair
**What:** Add `markQuizPassed` and `isQuizPassed` to `ProgressContextValue` following the established contract.
**When to use:** Every new progress operation that consumers need.
**Example:**
```typescript
// In ProgressContextValue interface
markQuizPassed: (lessonId: LessonId) => void
isQuizPassed: (lessonId: LessonId) => boolean

// Implementation inside ProgressProvider
const markQuizPassed = useCallback(
  (lessonId: LessonId) => {
    setProgress((prev) => ({
      ...prev,
      lessons: {
        ...prev.lessons,
        [lessonId]: {
          ...prev.lessons[lessonId],
          completed: true,
          quizPassed: true,
          quizPassedAt: new Date().toISOString(),
          exercisesCompleted: prev.lessons[lessonId]?.exercisesCompleted ?? [],
          quizAttempts: prev.lessons[lessonId]?.quizAttempts ?? 1,
        },
      },
    }))
  },
  [setProgress]
)

const isQuizPassed = useCallback(
  (lessonId: LessonId): boolean =>
    progress.lessons[lessonId]?.quizPassed === true,
  [progress]
)
```
Note: `markQuizPassed` also sets `completed: true` because passing the quiz IS lesson completion for quiz-enabled lessons. Phase 14 will retire `MarkCompleteButton` for those lessons; in Phase 12 both paths write to the same `completed` flag.

### Pattern 5: QuizQuestion Schema (DATA-01, DATA-02)
**What:** New `types/quiz.ts` with a minimal, locked interface for quiz content.
**When to use:** Phase 15 MDX authors type their `export const quiz` against this.
**Example:**
```typescript
// types/quiz.ts
export interface QuizQuestion {
  id: string           // unique within the lesson, e.g., "q1"
  question: string     // full question text
  options: [string, string, string, string]  // exactly 4 options (tuple enforces length)
  correctIndex: 0 | 1 | 2 | 3              // index into options
  explanation: string  // shown after correct answer (QUIZ-03)
}

export type QuizPhase = QuizQuestion[]
```
The tuple type `[string, string, string, string]` enforces the "exactly 4 options" requirement at the type level so malformed quiz data fails at compile time, not at runtime.

### Anti-Patterns to Avoid
- **Writing `quizAttempts` as required:** Making it required breaks every existing `LessonProgress` literal in test helpers (`makeProgress`). Keep it optional.
- **Adding `isLessonComplete` only inside ProgressProvider:** The function needs to be testable in isolation. It belongs in `lib/progress.ts` as a pure function, imported by the provider.
- **Migration that resets data:** `version: 1` blobs in localStorage are valid as `version: 2` blobs. No wipe, no migration function. A migration function that resets `completed: false` would violate GATE-02.
- **Storing quiz state separately:** The CONTEXT.md and STATE.md decisions confirm all quiz progress stays in the same `LessonProgress` record under the same `PROGRESS_STORAGE_KEY`. No second localStorage key.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Exactly-4-options enforcement | Runtime length check | TypeScript tuple `[string, string, string, string]` | Caught at compile time, zero runtime overhead |
| localStorage deserialization safety | Custom deserializer | Existing `useLocalStorage<T>` hook | Already handles SSR, JSON.parse errors, hydration flag |
| React context boilerplate | New context + provider | Extend existing `ProgressContext` | Adding fields to an existing provider costs 10 lines; a new provider costs 100+ and requires new placement in the app tree |

**Key insight:** The existing progress infrastructure was designed for extension. `ProgressState.version` and optional fields on `LessonProgress` are deliberate affordances — use them.

---

## Common Pitfalls

### Pitfall 1: Breaking the Test Helper makeProgress
**What goes wrong:** `progress.test.ts` builds `ProgressState` literals with `version: 1` and `LessonProgress` objects with no quiz fields. If `quizAttempts` becomes required, the test file gets TS errors.
**Why it happens:** Forgetting that test helpers are also callers of the interface.
**How to avoid:** Keep `quizAttempts?: number` (optional). Document that callers read `lesson.quizAttempts ?? 0`.
**Warning signs:** `tsc --noEmit` fails in `lib/__tests__/progress.test.ts` or `hooks/__tests__/useLocalStorage.test.ts`.

### Pitfall 2: isLessonComplete Not Matching MarkCompleteButton
**What goes wrong:** `MarkCompleteButton` reads `progress.lessons[lessonId]?.completed === true` directly (line 14 of the component). If `isLessonComplete` is introduced but the button doesn't use it, they can diverge.
**Why it happens:** Phase 12 is infrastructure-only — we're adding the function but not refactoring callers yet.
**How to avoid:** Phase 12 does NOT need to change `MarkCompleteButton`. The button's direct `completed` read is still correct for quiz-null lessons (GATE-03). The refactor belongs in Phase 14.
**Warning signs:** Temptation to update `MarkCompleteButton` here — resist it. It is out of Phase 12 scope.

### Pitfall 3: tsc --noEmit Baseline Confusion
**What goes wrong:** `tsc --noEmit` currently fails with ~30 errors about `describe`, `it`, `expect` not being defined — these are pre-existing because vitest globals are not in tsconfig types. Phase 12 must not ADD new errors, but it cannot be blamed for the pre-existing ones.
**Why it happens:** `tsconfig.json` does not include `"types": ["vitest/globals"]` — the project relies on vitest's `globals: true` config instead, which affects vitest runtime but not tsc.
**How to avoid:** The phase success criterion "tsc --noEmit passes with zero errors" applies to non-test source files only, OR the planner should add `"types": ["vitest/globals"]` to tsconfig as a Wave 0 fix. Either interpretation is valid; the planner should choose.
**Warning signs:** Reviewing tsc output and seeing only test-file errors — those are pre-existing and should not block phase verification.

### Pitfall 4: quizAttempts Increment Ownership
**What goes wrong:** Phase 12 adds `quizAttempts` to the schema but doesn't define who increments it or when.
**Why it happens:** The field is needed for QUIZ-05 display (Phase 13) but the increment happens when the quiz is submitted (Phase 13 logic).
**How to avoid:** In Phase 12, `markQuizPassed` can set `quizAttempts` (capturing the winning attempt), but the *increment on failed attempt* belongs in Phase 13. Phase 12 should add a `markQuizAttempt` callback OR just leave a comment noting Phase 13 will extend context with that operation. Document this clearly so Phase 13 planner doesn't duplicate work.
**Warning signs:** Implementing quiz submission logic (wrong-answer handling) inside `ProgressProvider` in Phase 12 — that is Phase 13 territory.

---

## Code Examples

### types/quiz.ts — complete new file
```typescript
// Source: original design, confirmed against CONTEXT.md and REQUIREMENTS.md
export interface QuizQuestion {
  id: string
  question: string
  options: [string, string, string, string]
  correctIndex: 0 | 1 | 2 | 3
  explanation: string
}

export type QuizPhase = QuizQuestion[]
```

### types/progress.ts — diff of additions
```typescript
// Existing LessonProgress — add three optional fields
export interface LessonProgress {
  completed: boolean
  completedAt?: string
  exercisesCompleted: string[]
  // v1.2 additions
  quizPassed?: boolean
  quizPassedAt?: string
  quizAttempts?: number
}

// Existing ProgressState — bump version constant only
export const INITIAL_PROGRESS: ProgressState = {
  lessons: {},
  version: 2,
}
```

### lib/progress.ts — new isLessonComplete function
```typescript
import type { LessonProgress } from '@/types/progress'

export function isLessonComplete(lesson: LessonProgress | undefined): boolean {
  if (!lesson) return false
  return lesson.completed === true && lesson.quizPassed !== false
}
```

### lib/__tests__/progress.test.ts — new test cases to add
```typescript
// Add to the existing file
describe('isLessonComplete', () => {
  it('returns false for undefined lesson', () => {
    expect(isLessonComplete(undefined)).toBe(false)
  })

  it('returns false when completed is false', () => {
    expect(isLessonComplete({ completed: false, exercisesCompleted: [] })).toBe(false)
  })

  it('returns true for pre-v1.2 record with no quizPassed field (grandfather rule)', () => {
    expect(isLessonComplete({ completed: true, exercisesCompleted: [] })).toBe(true)
  })

  it('returns true when completed and quizPassed are both true', () => {
    expect(isLessonComplete({ completed: true, quizPassed: true, exercisesCompleted: [] })).toBe(true)
  })

  it('returns false when completed is true but quizPassed is false', () => {
    expect(isLessonComplete({ completed: true, quizPassed: false, exercisesCompleted: [] })).toBe(false)
  })
})
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `completed: boolean` only | `completed + quizPassed + quizAttempts` | Phase 12 (v1.2) | Enables quiz gating while preserving pre-v1.2 records |
| Direct `lesson.completed` reads | `isLessonComplete(lesson)` helper | Phase 12 (v1.2) | Single source of truth for completion logic; Phase 14 migrates callers |

**Deprecated/outdated:**
- None. This phase adds to the schema; nothing is removed. `MarkCompleteButton` stays active for quiz-null lessons throughout v1.2.

---

## Open Questions

1. **tsc --noEmit baseline for phase verification**
   - What we know: Currently ~30 pre-existing tsc errors in test files (vitest globals not typed in tsconfig)
   - What's unclear: Does the success criterion "tsc --noEmit passes with zero errors" mean all files or only non-test source files?
   - Recommendation: Planner should either (a) add `"types": ["vitest/globals"]` to `tsconfig.json` as Wave 0 task to make tsc fully clean, or (b) scope the tsc check to `--project tsconfig.json --noEmit` excluding test files via a `tsconfig.src.json`. Option (a) is simpler and lower risk.

2. **markQuizAttempt for failed submissions**
   - What we know: `quizAttempts` field belongs in Phase 12 schema; the QUIZ-05 display (attempt count) is Phase 13
   - What's unclear: Should Phase 12 add a `markQuizAttempt` callback to context now, or leave it for Phase 13?
   - Recommendation: Phase 12 adds only `markQuizPassed` and `isQuizPassed` per the success criteria. Phase 13 adds `markQuizAttempt`. Document this split in the plan.

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Vitest ^4.1.0 |
| Config file | `vitest.config.ts` |
| Quick run command | `npx vitest run lib/__tests__/progress.test.ts` |
| Full suite command | `npx vitest run` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DATA-02 | `QuizQuestion` tuple enforces exactly 4 options | unit (compile-time) | `npx tsc --noEmit types/quiz.ts` | ❌ Wave 0 — create `types/quiz.ts` |
| GATE-02 | `isLessonComplete` returns true for `completed: true, quizPassed: undefined` | unit | `npx vitest run lib/__tests__/progress.test.ts` | ✅ exists, extend with new cases |
| GATE-03 | `isLessonComplete` returns true for `completed: true` with no quiz fields | unit | `npx vitest run lib/__tests__/progress.test.ts` | ✅ exists, extend with new cases |
| DATA-01 | TypeScript compiles cleanly with new `QuizQuestion` type | compile | `npx tsc --noEmit` | ❌ Wave 0 — create `types/quiz.ts` |

### Sampling Rate
- **Per task commit:** `npx vitest run lib/__tests__/progress.test.ts`
- **Per wave merge:** `npx vitest run`
- **Phase gate:** Full suite green before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `types/quiz.ts` — create with `QuizQuestion` and `QuizPhase`; covers DATA-01, DATA-02
- [ ] New `isLessonComplete` cases in `lib/__tests__/progress.test.ts` — covers GATE-02, GATE-03

*(No new test files needed — existing `progress.test.ts` is extended)*

---

## Sources

### Primary (HIGH confidence)
- Direct read of `types/progress.ts` — exact current interface, version, optional field patterns
- Direct read of `components/progress/ProgressProvider.tsx` — exact context shape, `useCallback` patterns, `setProgress` updater signature
- Direct read of `lib/progress.ts` — existing pure functions to extend
- Direct read of `lib/__tests__/progress.test.ts` — test structure, vitest globals usage, `makeProgress` helper
- Direct read of `tsconfig.json` — strict mode enabled, no vitest types
- Direct read of `vitest.config.ts` — `globals: true`, jsdom, alias config
- `npx vitest run` output — 34 tests pass, clean baseline confirmed

### Secondary (MEDIUM confidence)
- TypeScript tuple type syntax for fixed-length arrays — standard TS feature, stable since TS 3.0

### Tertiary (LOW confidence)
- None

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all versions read from package.json directly
- Architecture: HIGH — all patterns read from existing source files; no speculation
- Pitfalls: HIGH — identified by reading actual source, running tsc, running vitest

**Research date:** 2026-03-22
**Valid until:** 2026-04-22 (stable domain; no external dependencies added)
