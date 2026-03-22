# Phase 14: Layout Integration and Gating - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Wire the Quiz component into the lesson page layout, pipe quiz data from MDX named exports through the content pipeline, gate lesson completion on quiz pass for quiz-enabled lessons, and conditionally remove MarkCompleteButton. One end-to-end test lesson to verify the full flow.

</domain>

<decisions>
## Implementation Decisions

### Quiz Placement & Data Flow
- Quiz renders after MDX content (exercises), before the MarkCompleteButton area — natural reading flow, quiz is the final gate
- Quiz data flows via MDX named export `quiz` → getLessonContent → page.tsx props → LessonLayout prop → Quiz component — follows existing content pipeline with no MDX build changes
- Horizontal rule + "Knowledge Check" heading separates content from quiz — clear section boundary

### Gating Behavior
- Quiz component calls markQuizPassed which already calls markLessonComplete internally (wired in Phase 12)
- MarkCompleteButton conditionally hidden when quiz data exists — `{!quiz && <MarkCompleteButton />}` in LessonLayout
- "Continue to Next Lesson" button links to the next lesson in the module using existing navigation data; if last lesson, links to module overview

### Claude's Discretion
- Exact prop threading approach through page.tsx and LessonLayout
- How to extract named export `quiz` from MDX dynamic import
- Test lesson selection for end-to-end verification
- Any TypeScript adjustments for quiz prop types on LessonLayout

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `components/lesson/Quiz.tsx` — Quiz component with `questions: QuizQuestion[]` and `lessonId: string` props
- `components/lesson/LessonLayout.tsx` — Two-column layout with breadcrumb, header, MDX content, MarkCompleteButton
- `components/lesson/MarkCompleteButton.tsx` — Standalone complete button, conditionally rendered
- `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` — Dynamic lesson page with getLessonContent
- `lib/content.ts` — getLessonContent function, MDX dynamic import pipeline

### Established Patterns
- MDX content loaded via `await import()` in getLessonContent
- Frontmatter extracted from MDX default export
- LessonLayout receives frontmatter + children (MDX content)
- Progress-dependent UI checks isHydrated before rendering

### Integration Points
- `getLessonContent` — add quiz extraction from MDX module
- `page.tsx` — pass quiz data as prop to LessonLayout
- `LessonLayout` — accept optional quiz prop, render Quiz component, conditionally hide MarkCompleteButton
- MDX lesson files — will need `export const quiz = [...]` (Phase 15 adds to all 56 lessons)

</code_context>

<specifics>
## Specific Ideas

No specific requirements — standard approaches accepted for all areas

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>
