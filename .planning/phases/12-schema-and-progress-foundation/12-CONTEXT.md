# Phase 12: Schema and Progress Foundation - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Define quiz type system (`types/quiz.ts`) and extend the existing progress infrastructure (`types/progress.ts`, `components/progress/ProgressProvider.tsx`) with quiz-specific fields. No UI, no quiz logic — only stable contracts for downstream phases.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion — pure infrastructure phase

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `types/progress.ts` — `LessonProgress`, `ProgressState` (version: 1), `INITIAL_PROGRESS`
- `types/content.ts` — `LessonId`, `Module`, `Lesson` types
- `components/progress/ProgressProvider.tsx` — `ProgressContextValue` interface, `markLessonComplete`, `markExerciseComplete`
- `hooks/useProgress.ts` — context consumer hook
- `hooks/useLocalStorage.ts` — SSR-safe localStorage with hydration flag

### Established Patterns
- Progress stored in localStorage under `'learn-systems-progress'` key
- `ProgressState.version` field exists (currently `1`) for schema migrations
- `LessonProgress` uses optional fields (`completedAt?: string`)
- Context provides typed interface (`ProgressContextValue`) consumed via `useProgress()` hook

### Integration Points
- `types/progress.ts` — add `quizPassed`, `quizPassedAt`, `quizAttempts` to `LessonProgress`, bump version to `2`
- `components/progress/ProgressProvider.tsx` — add `markQuizPassed` and `isQuizPassed` to context value
- `lib/progress.ts` — `isModuleComplete`, `moduleCompletionPercent` may need quiz-awareness
- `components/lesson/MarkCompleteButton.tsx` — must still work for lessons without quiz data

</code_context>

<specifics>
## Specific Ideas

No specific requirements — infrastructure phase

</specifics>

<deferred>
## Deferred Ideas

None

</deferred>
