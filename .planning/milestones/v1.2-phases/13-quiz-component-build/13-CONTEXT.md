# Phase 13: Quiz Component Build - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Build the interactive quiz component that lets users answer multiple-choice questions one at a time, receive immediate feedback (incorrect = retake from Q1, correct = see explanation), track attempts, and see a pass screen with "Continue to Next Lesson" button. Uses fixture data only — no MDX integration or layout placement (Phase 14).

</domain>

<decisions>
## Implementation Decisions

### Question Presentation Flow
- One question displayed at a time — focused attention, matches retrieval practice pedagogy
- Wrong answer triggers immediate retake — quiz resets to question 1 with "Incorrect" flash, no partial progress saved
- Progress shown as "Question 3 of 8" text — minimal, matches existing UI density
- No back navigation — forward-only reinforces commitment to answers

### Feedback & Pass Screen
- Incorrect feedback: inline red banner below selected answer — "Incorrect — quiz will restart from question 1" with 2s auto-dismiss then reset
- Correct feedback: green highlight on selected option + explanation paragraph below — stays visible until "Next Question" clicked
- Pass screen: celebratory card with checkmark icon, attempt count display, and "Continue to Next Lesson" button
- Attempt counter: subtle text below quiz title — "Attempt 2" — always visible during quiz

### Component Architecture
- State machine via useReducer with explicit states: idle, active, failed, passed
- Single Quiz component file with internal sub-components (QuizQuestion, QuizFeedback, QuizPassScreen) as non-exported helpers
- File location: components/lesson/Quiz.tsx
- Fixture data: hardcoded in test file + one MDX lesson for manual testing

### Claude's Discretion
- Exact Tailwind styling choices within the established design system patterns
- Internal state shape beyond the four explicit phases
- Test organization and helper utilities
- Animation/transition details for feedback display

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `types/quiz.ts` — `QuizQuestion` (id, question, options[4], correctIndex, explanation), `QuizPhase`
- `types/progress.ts` — `LessonProgress` with `quizPassed?`, `quizPassedAt?`, `quizAttempts?`
- `components/progress/ProgressProvider.tsx` — `markQuizPassed(lessonId)`, `isQuizPassed(lessonId)`
- `hooks/useProgress.ts` — context consumer hook
- `components/ui/button.tsx` — Button with variants (default, outline, secondary, ghost) and sizes
- `components/ui/dialog.tsx` — Dialog primitives if needed for overlays
- Lucide icons via `lucide-react` (CheckCircle2, AlertCircle, ChevronRight, etc.)

### Established Patterns
- Client components use `'use client'` directive
- SSR safety: check `isHydrated` before rendering progress-dependent UI
- Interactive components (ExerciseCard, ScenarioQuestion) use useState for expand/collapse
- Tailwind with semantic tokens (text-foreground, bg-muted, border-border, text-muted-foreground)
- CVA (Class Variance Authority) for component variants in ui/ components

### Integration Points
- `useProgress()` hook for `markQuizPassed`, `isQuizPassed`, `progress` state
- `LessonId` type from `types/content.ts` for quiz-progress linkage
- Phase 14 will import Quiz component into LessonLayout — keep props interface clean

</code_context>

<specifics>
## Specific Ideas

No specific requirements — standard approaches accepted for all areas

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>
