# Phase 9: Component Implementation - Context

**Gathered:** 2026-03-20
**Status:** Ready for planning

<domain>
## Phase Boundary

Build all new React components and modify ExerciseCard so that all three difficulty tiers render correctly. This phase produces working components registered in mdx-components.tsx — no content migration (that's Phase 10-11).

New components: AnnotatedCommand (flag breakdown panel), ScenarioQuestion (scenario-linked question with reveal), ChallengeReferenceSheet (reference sheet for compose mode). Modified: ExerciseCard (mode-aware rendering), LessonLayout (DifficultyToggle).

</domain>

<decisions>
## Implementation Decisions

### Component Rendering (locked from Phase 8 design docs)
- Foundation mode ("guided"): Steps show command + AnnotatedCommand panel below. Always visible, static, never tooltips.
- Intermediate mode ("recall"): Steps show description text only. Command is NOT rendered. Learner must recall syntax.
- Challenge mode ("compose"): Only challengePrompt shown + ChallengeReferenceSheet. Numbered step list is hidden entirely.
- Foundation safety net: `difficulty === 'Foundation'` ALWAYS returns guided mode regardless of any toggle or prop. Hard override, not soft default.

### Mode Resolution Chain (locked from Phase 8 preference-spec.md)
- Priority 1: Explicit `mode` prop on ExerciseCard
- Priority 2: Learner's `preferredMode` from localStorage preferences
- Priority 3: `DIFFICULTY_MODE_DEFAULT[difficulty]` mapping
- Foundation overrides all three priorities

### DifficultyToggle (locked from Phase 8 preference-spec.md)
- Appears ONLY on Challenge-difficulty lessons (Foundation/Intermediate lessons don't show it)
- Two options: Guided / Challenge (no Recall option in toggle — keep it simple for learners)
- Persists to `'learn-systems-preferences'` localStorage key (separate from progress)
- Placement: LessonLayout header area, near the existing difficulty badge

### ScenarioQuestion Design
- Renders between exercise steps — "I am running this command so I can answer THIS question"
- Shows question text that explicitly references the exercise's opening scenario
- Has expandable answer reveal (click to show expected answer after learner thinks)
- Should feel like a natural part of the exercise flow, not a separate quiz

### Claude's Discretion
- Exact component styling (colors, spacing, borders) — should match existing ExerciseCard/Callout visual quality
- Whether to create a PreferencesProvider context or just use useLocalStorage directly in components
- Internal component file organization within components/content/
- Whether AnnotatedCommand is a standalone component or inline within ExerciseCard render

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `useLocalStorage<T>(key, initialValue)` hook — SSR-safe, returns hydration flag. Use for preferences storage.
- `QuickReference` component — accepts `sections: ReferenceSection[]` with command/description/example. Reuse for ChallengeReferenceSheet.
- `ExerciseCard` — currently takes title, scenario, difficulty, objective, steps, children. All new props (mode, annotated, challengePrompt) are optional in types/exercises.ts.
- `Callout` component — has expandable reveal pattern, inform ScenarioQuestion design.
- `ProgressProvider` pattern — context + useLocalStorage, model for PreferencesProvider if needed.

### Established Patterns
- All content components in `components/content/`
- Client components use `'use client'` directive
- MDX components registered in `mdx-components.tsx`
- Difficulty is `'Foundation' | 'Intermediate' | 'Challenge'` from `types/content.ts`
- Tailwind v4 for styling, dark-first CSS pattern

### Integration Points
- `mdx-components.tsx` — register new components (ScenarioQuestion, ChallengeReferenceSheet, AnnotatedCommand if standalone)
- `LessonLayout.tsx` — add DifficultyToggle in header area
- `types/exercises.ts` — all v1.1 types already defined in Phase 8
- `ExerciseCard.tsx` — modify to read mode and render conditionally

</code_context>

<specifics>
## Specific Ideas

- User wants "I am running this command so I can answer THIS question" pattern — ScenarioQuestion must feel purpose-driven, not quiz-like
- User loves the existing component look (Callout boxes, ExerciseCard) — new components should match that visual quality
- User emphasis: commands should have context so learners understand WHY they're running something, not just copy-pasting

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>
