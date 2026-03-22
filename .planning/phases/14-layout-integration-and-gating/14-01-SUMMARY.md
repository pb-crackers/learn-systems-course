---
phase: 14-layout-integration-and-gating
plan: 01
subsystem: ui
tags: [mdx, quiz, react, next.js, rsc, lesson-layout]

# Dependency graph
requires:
  - phase: 12-schema-and-progress-foundation
    provides: QuizQuestion type, markQuizPassed, isQuizPassed, progress schema
  - phase: 13-quiz-component-build
    provides: Quiz component with state machine, useProgress hook integration

provides:
  - Quiz renders on 01-how-computers-work lesson from MDX named export
  - getLessonContent returns quiz array (or null) alongside MDX component
  - QuizSection client wrapper bridges RSC boundary with router.push navigation
  - LessonLayout conditionally renders QuizSection or MarkCompleteButton
  - nextLessonHref computed from module lesson list and passed through layout

affects:
  - phase 15-quiz-content-authoring (template for adding quiz exports to all lessons)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - MDX named export pattern for quiz data (export const quiz = [...])
    - RSC boundary bridging via 'use client' wrapper (QuizSection wraps Quiz)
    - Conditional rendering gate: quiz present -> QuizSection, quiz absent -> MarkCompleteButton

key-files:
  created:
    - components/lesson/QuizSection.tsx
  modified:
    - lib/mdx.ts
    - app/modules/[moduleSlug]/[lessonSlug]/page.tsx
    - components/lesson/LessonLayout.tsx
    - content/modules/01-linux-fundamentals/01-how-computers-work.mdx

key-decisions:
  - "QuizSection 'use client' wrapper bridges RSC serialization boundary — LessonLayout stays as Server Component"
  - "getLessonContent uses Array.isArray(mod.quiz) guard to safely extract optional named export"
  - "nextLessonHref falls back to /modules/{moduleSlug} when lesson is last in module"
  - "MarkCompleteButton renders only when quiz is null (not when quiz is empty array)"

patterns-established:
  - "Pattern 1: MDX quiz named export (export const quiz = [...]) is the sole data source for quiz content"
  - "Pattern 2: RSC boundary bridging — Server Component (LessonLayout) passes serializable data to 'use client' wrapper (QuizSection) which provides function props to Quiz"
  - "Pattern 3: nextLessonHref computed at page.tsx level using getModuleBySlug + findIndex, threaded as prop"

requirements-completed: [LAYOUT-01, LAYOUT-02, GATE-01]

# Metrics
duration: 10min
completed: 2026-03-22
---

# Phase 14 Plan 01: Layout Integration and Gating Summary

**Quiz integration wired end-to-end: MDX named export -> getLessonContent -> page.tsx -> LessonLayout -> QuizSection -> Quiz, with MarkCompleteButton gated out for quiz-enabled lessons**

## Performance

- **Duration:** ~10 min
- **Started:** 2026-03-22T13:39:00Z
- **Completed:** 2026-03-22T13:49:00Z
- **Tasks:** 3
- **Files modified:** 5

## Accomplishments
- Extended getLessonContent to extract quiz named export from MDX dynamic import using Array.isArray guard
- Created QuizSection client wrapper bridging RSC serialization boundary for router.push onContinue
- Threaded quiz data and nextLessonHref from page.tsx through LessonLayout with conditional rendering
- Added 3-question test quiz to 01-how-computers-work lesson validating the full pipeline
- All 55 existing tests pass; zero new TypeScript errors in production code

## Task Commits

Each task was committed atomically:

1. **Task 1: Extract quiz from MDX pipeline and create QuizSection client wrapper** - `dede6cd` (feat)
2. **Task 2: Thread quiz data through page.tsx and update LessonLayout** - `f84ede1` (feat)
3. **Task 3: Add test quiz to lesson 01-how-computers-work and verify build** - `b80aaeb` (feat)

## Files Created/Modified
- `lib/mdx.ts` - Added QuizQuestion import, updated return type to include quiz field, Array.isArray extraction
- `components/lesson/QuizSection.tsx` - New 'use client' wrapper: receives questions/lessonId/nextLessonHref, passes onContinue as router.push to Quiz
- `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` - Imports getModuleBySlug, destructures quiz, computes nextLessonHref, passes both to LessonLayout
- `components/lesson/LessonLayout.tsx` - Imports QuizSection and QuizQuestion type, extends props, conditionally renders QuizSection or MarkCompleteButton
- `content/modules/01-linux-fundamentals/01-how-computers-work.mdx` - Added export const quiz with 3 questions (hw-q1, hw-q2, hw-q3)

## Decisions Made
- QuizSection 'use client' wrapper pattern keeps LessonLayout as a Server Component while still providing function props (onContinue) to Quiz
- Array.isArray(mod.quiz) guard chosen over typeof check for safety against accidental non-array quiz exports
- MarkCompleteButton renders only when quiz is strictly null — an empty quiz array would not show the button (plan requirement)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
- Pre-existing tsc errors in test files (vitest globals not in tsconfig) — confirmed pre-existing before my changes, out of scope per deviation rules

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Phase 15 (quiz content authoring) can now begin: the pipeline is live and validated
- Template established: add `export const quiz = [...]` at end of any MDX file to enable quiz for that lesson
- All other lessons still show MarkCompleteButton (quiz prop is null until export is added)

---
*Phase: 14-layout-integration-and-gating*
*Completed: 2026-03-22*
