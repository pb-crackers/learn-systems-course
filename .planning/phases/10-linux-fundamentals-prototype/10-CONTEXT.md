# Phase 10: Linux Fundamentals Prototype - Context

**Gathered:** 2026-03-20
**Status:** Ready for planning

<domain>
## Phase Boundary

Migrate the Linux Fundamentals module (content/modules/01-linux-fundamentals/) to use all v1.1 command pedagogy features. This validates the annotation schema, ScenarioQuestion pattern, and mode-aware rendering against real content before Phase 11 bulk migration.

10 lessons in this module. Per audit (docs/design/audit-results.md), Linux Fundamentals has 34 Foundation command fields to annotate.

</domain>

<decisions>
## Implementation Decisions

### Content Authoring (locked from Phase 8 design docs)
- Annotations co-located in each step's `annotations` array (not separate file imports)
- Each annotation has token (the flag/arg), description (≤120 chars, verb-first), optional example
- Every Foundation exercise step with a command MUST have annotations — no unannotated command blocks
- Annotation style: explain what the flag DOES, not just what it stands for ("list files including hidden ones" not "all files flag")

### Scenario Questions (locked from user direction)
- Every exercise must have at least one ScenarioQuestion tying commands back to the opening scenario
- Pattern: "I am running this command so I can answer THIS question"
- Questions should make the learner think about WHY they're running a command, not just WHAT it does
- Answers revealed via expandable panel after learner considers

### Difficulty Tier Content
- Foundation lessons: annotated commands (guided mode) + scenario questions
- Intermediate lessons: step descriptions without commands (recall mode) + scenario questions
- Challenge lessons (if any in this module): goal-only with reference sheet (compose mode)

### Claude's Discretion
- Exact wording of all annotations and scenario questions — optimize for student understanding
- How many ScenarioQuestions per exercise (minimum 1, but more where pedagogically valuable)
- Whether to add challengePrompt to any exercises in this module
- Order of lesson migration within the module

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `AnnotatedCommand` component — renders command + per-flag annotation table
- `ScenarioQuestion` component — renders question with expandable answer reveal
- `ExerciseCard` — now mode-aware, accepts `annotated` and `mode` props
- `types/exercises.ts` — all type contracts including `CommandAnnotation`

### Established Patterns
- MDX exercises use `<ExerciseCard>` with `steps={[...]}` prop
- Each step has `{ step, description, command? }` shape
- New: add `annotations?: CommandAnnotation[]` to steps
- New: add `annotated={true}` prop to ExerciseCard for Foundation lessons
- New: intersperse `<ScenarioQuestion>` components between exercise steps in MDX

### Integration Points
- All 10 MDX files in content/modules/01-linux-fundamentals/
- ExerciseCard step objects need annotations arrays added
- ScenarioQuestion components added inline in MDX between steps
- `next build` must pass after all changes

</code_context>

<specifics>
## Specific Ideas

- User emphasis: "I am running this command so I can answer THIS question" — ScenarioQuestions must connect commands to the scenario, not be generic quiz questions
- User wants to understand what commands do and flags mean so they can write them independently
- This prototype validates the authoring pattern — if the DX is bad here, fix before Phase 11

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>
