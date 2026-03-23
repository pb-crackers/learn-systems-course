# Phase 11: Full Content Migration - Context

**Gathered:** 2026-03-20
**Status:** Ready for planning

<domain>
## Phase Boundary

Apply the validated Phase 10 annotation pattern to all remaining 7 modules (~42 lessons). Foundation lessons get per-flag annotations + ScenarioQuestions. Intermediate lessons get ScenarioQuestions only. Challenge/capstone exercises get goal-only format with reference sheets. Each module must pass TypeScript compilation after migration.

</domain>

<decisions>
## Implementation Decisions

### Migration Pattern (validated in Phase 10)
- Foundation exercises: `annotated={true}` prop, `annotations` array on every step with a command, ≥1 ScenarioQuestion per exercise
- Intermediate exercises: ScenarioQuestions only (no annotations, no annotated prop — recall mode hides commands)
- Challenge/capstone exercises: Add `challengePrompt` prop, add `<ChallengeReferenceSheet>` component, ≥1 ScenarioQuestion
- Cheat sheet lessons: Skip (no ExerciseCard with command steps)
- Annotation style: verb-first description ≤120 chars, no angle brackets, explain what flags DO not what they stand for

### Module Order (from audit-results.md, lightest to heaviest)
1. Cloud (07-cloud) — 5 exercises
2. CI/CD (05-cicd) — 4 exercises
3. Monitoring (08-monitoring) — 5 exercises
4. IaC (06-iac) — 4 exercises
5. Docker (03-docker) — 9 exercises
6. Sysadmin (04-sysadmin) — 6 exercises
7. Networking (02-networking) — 7 exercises

### Claude's Discretion
- Exact annotation wording for all commands — optimize for student comprehension
- ScenarioQuestion content — must connect commands to opening scenario
- How many ScenarioQuestions per exercise (minimum 1)
- Whether any exercises warrant challengePrompt + ChallengeReferenceSheet treatment
- Grouping of lessons per plan within each module

</decisions>

<code_context>
## Existing Code Insights

### Validated Pattern (from Phase 10)
- Read the Phase 10 migrated lessons as reference for annotation style and ScenarioQuestion tone
- content/modules/01-linux-fundamentals/01-how-computers-work.mdx — Foundation example
- content/modules/01-linux-fundamentals/05-processes.mdx — Intermediate example

### Integration Points
- All MDX files in content/modules/{module-slug}/
- ExerciseCard accepts: annotated, mode, challengePrompt (all optional)
- ScenarioQuestion, AnnotatedCommand, ChallengeReferenceSheet registered in mdx-components.tsx

</code_context>

<specifics>
## Specific Ideas

- User emphasis: commands should have context so learners understand WHY they're running something
- "I am running this command so I can answer THIS question" pattern for all ScenarioQuestions
- Annotation quality matters more than speed — each annotation teaches a flag meaning

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>
