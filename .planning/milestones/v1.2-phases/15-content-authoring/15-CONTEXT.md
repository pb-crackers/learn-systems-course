# Phase 15: Content Authoring - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Author 7-10 multiple-choice quiz questions for every lesson across all 8 modules (56 lessons total). Each quiz is exported as `export const quiz: QuizQuestion[]` in the lesson's MDX file. No infrastructure changes — purely content creation using the schema and pipeline established in Phases 12-14.

</domain>

<decisions>
## Implementation Decisions

### Quiz Content Standards
- Question difficulty matches the lesson's difficulty tier — Foundation tests basic recall, Intermediate tests application, Challenge tests synthesis
- Distractors are plausible but clearly wrong — common misconceptions or adjacent concepts, not obviously absurd
- Explanations are 2-3 sentences explaining WHY the correct answer is right — reinforce the mechanism, not just restate the fact
- Questions scoped to that specific lesson only — never test content from other lessons or modules

### Authoring Strategy
- 7-10 questions per lesson quiz (per QUIZ-01 requirement)
- One plan per module (8 plans total) — each plan authors all lessons in that module
- tsc --noEmit after each module to catch type errors early
- Note: 01-how-computers-work already has 3 test questions from Phase 14 — replace with full 7-10 question quiz

### Claude's Discretion
- Exact question wording and topic selection within each lesson's content
- Number of questions per quiz within the 7-10 range
- Order of questions within each quiz
- Specific distractor choices

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `types/quiz.ts` — `QuizQuestion` interface (id, question, options[4], correctIndex: 0|1|2|3, explanation)
- Phase 14 test lesson (`01-how-computers-work.mdx`) — reference for `export const quiz` format
- All 56 MDX lesson files in `content/modules/` — target files for quiz additions

### Established Patterns
- Quiz export placed at bottom of MDX file after all prose content
- `export const quiz: QuizQuestion[] = [...]` with typed array
- Each question has unique `id` like `{lesson-slug}-q{N}`
- Options are exactly 4 strings as a tuple
- correctIndex is 0-3

### Integration Points
- `getLessonContent` in `lib/mdx.ts` already extracts `quiz` from MDX named exports
- `LessonLayout` already conditionally renders QuizSection when quiz data exists
- No changes needed to any infrastructure — just add content to MDX files

</code_context>

<specifics>
## Specific Ideas

No specific requirements — standard approaches accepted for all areas

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>
