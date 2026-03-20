# Phase 8: Design Lock - Context

**Gathered:** 2026-03-20
**Status:** Ready for planning

<domain>
## Phase Boundary

Lock all interface contracts, data schemas, and content policies in writing before any code or content is authored. This phase produces documentation artifacts only — no component code, no MDX changes.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion — pure infrastructure/design phase. Key guidance from user: "make decisions based on the needs of students to learn and truly grasp concepts."

Design decisions should optimize for:
- Commands feel purposeful, not isolated — "I am running this command so I can answer THIS question"
- Foundation learners get full annotations so they can learn flag meanings without external lookup
- Challenge learners must compose commands from goals, building real recall and problem-solving
- Annotations should be thorough enough that a learner never needs to run `man` or google a flag

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `ExerciseCard` component (components/content/ExerciseCard.tsx) — consumed in 52/56 lessons, accepts difficulty prop
- `QuickReference` component — already renders reference tables, reusable for ChallengeReferenceSheet
- `CodeBlock` component — handles syntax highlighting and copy
- `useProgress` hook + ProgressProvider — localStorage-based state management pattern to follow
- `Callout` component — expandable reveal pattern may inform ScenarioQuestion

### Established Patterns
- MDX components registered in mdx-components.tsx
- All content components are in components/content/
- Difficulty is a frontmatter field: Foundation | Intermediate | Challenge
- localStorage keys: 'learn-systems-progress' for progress tracking

### Integration Points
- LessonLayout.tsx wraps all lessons — difficulty toggle goes here
- ExerciseCard is the primary exercise container — all tier rendering changes happen here
- mdx-components.tsx must register new components (AnnotatedCommand, ScenarioQuestion, ChallengeReferenceSheet)

</code_context>

<specifics>
## Specific Ideas

- User explicitly wants "I am running this command so I can answer THIS question" pattern for ScenarioQuestion
- Annotations should explain flags so learners can write commands themselves without copy-paste
- Challenge mode should feel like a real scenario, not a stripped-down version of Foundation
- The user likes the existing ExerciseCard, Callout, and QuickReference look — new components should match that visual quality

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>
