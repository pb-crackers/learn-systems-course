# Pitfalls Research

**Domain:** Command Pedagogy Retrofit — Annotated Commands + Challenge-Mode Exercises for Existing CLI Teaching Platform
**Researched:** 2026-03-20
**Confidence:** HIGH (analysis grounded in direct codebase inspection of all 56 lessons + 6 existing components; supplemented by instructional design literature)

---

## Critical Pitfalls

### Pitfall 1: Prop Interface Breakage on ExerciseCard — Silent Regression Across 52 Lessons

**What goes wrong:**
The new annotation and challenge-mode features require extending ExerciseCard's prop interface. If `steps` item shape changes (e.g., adding `annotations?: Annotation[]` as required) without making it optional, every existing MDX file that uses `ExerciseCard` passes the old shape and TypeScript compile errors surface across all 52 lesson files simultaneously. Worse — if the prop is added as optional but the rendering branch is wrong, lessons silently render annotation UI in Foundation exercises without the data, producing empty UI elements.

**Why it happens:**
ExerciseCard is a single component consumed in MDX via `mdx-components.tsx`. It has no versioning. Adding behavior to it is always additive to the entire corpus. The new features require rendering different UI based on `difficulty`, but the `steps` prop is currently a flat array — retrofitting annotation data onto it means either changing the shape (breaking) or adding a parallel prop (messy but safe).

**How to avoid:**
- Make all new props strictly optional with fallback behavior: `annotations?: CommandAnnotation[]`, `challengeMode?: boolean`, `referenceSheet?: ReferenceItem[]`
- Never change the shape of the existing `steps` prop — leave it untouched, add new parallel props
- TypeScript strict mode (`"strict": true` is already in `tsconfig.json`) will catch missing required props at build time — use this as the regression gate
- Run `next build` after any interface change and treat compile errors as blocking before touching any MDX

**Warning signs:**
- Any new prop on ExerciseCard is non-optional
- The `steps` array item interface changes to add required fields
- TypeScript reports errors in MDX files after the component change
- `next build` passes but the rendered page has empty annotation sections on old lessons

**Phase to address:**
Phase 1 (component design). Lock the interface contract before writing any MDX. The rule: existing lessons must render identically with zero modification.

---

### Pitfall 2: Annotation Coverage Inconsistency — Half the Foundation Lessons Get Annotations, Half Don't

**What goes wrong:**
There are 22 Foundation-difficulty lessons. The milestone says "annotated command blocks for Foundation exercises." If annotations are written for 8 lessons in the first phase and the feature ships, learners see inconsistent experiences — some lessons have rich flag explanations, others have the same bare `command` field as before. The asymmetry is pedagogically confusing: learners do not know whether missing annotations mean "this command needs no explanation" or "this lesson is incomplete."

**Why it happens:**
Content migration at scale (22 lessons, potentially 200+ step entries with `command` fields) is underestimated. It feels like a data-entry task but each annotation requires understanding the command well enough to explain every flag in context. Authors annotate the first few lessons thoroughly, then rush the rest. The feature flag (Foundation → show annotations) makes the gap visible everywhere at once.

**How to avoid:**
- Audit all Foundation lesson `ExerciseCard` steps before writing any annotations — count every `command` field that needs annotation
- Write annotations module by module, completing one module before starting the next
- Do not ship the annotation UI feature until at least one complete module is annotated — use a per-exercise opt-in prop (`annotated={true}`) to gate display, not a lesson-level flag, so unannotated exercises stay clean
- Define the annotation schema precisely before writing content: `{ flag: string; description: string; example?: string }[]`

**Warning signs:**
- More than one module is "in progress" on annotations simultaneously
- The annotation component renders but some exercises show it empty
- No pre-migration audit exists of how many `command` fields need annotations

**Phase to address:**
Phase 1 (design) must include the audit. Phase 2 (content migration) must be module-by-module, never lesson-by-lesson across modules.

---

### Pitfall 3: Challenge-Mode Exercises Lose Verification Integrity — Goals Without Checks

**What goes wrong:**
Challenge-mode exercises describe a goal in English ("Set up a Docker Compose stack with health checks") instead of providing step-by-step commands. The existing VerificationChecklist provides manually-ticked checkboxes. If the challenge-mode variant uses the same VerificationChecklist with the same manually-ticked design, learners can mark all items complete without actually completing the challenge — the "verification" becomes performative. The existing exercises (like the capstone) already have this weakness; challenge-mode at scale amplifies it.

**Why it happens:**
The VerificationChecklist is a client-side toggle component — it stores checked state in React local state that resets on page refresh. There is no actual command verification; it is purely self-assessed. This was acceptable for Foundation exercises where commands are given and output is predictable. Challenge exercises without commands have no clear expected output, making even self-assessment vague.

**How to avoid:**
- Challenge-mode verification items must include precise success criteria as the `hint` field — not "you completed the task" but "run `docker ps | grep healthy` and verify all containers show `(healthy)` in the STATUS column"
- Each challenge-mode exercise needs 3–5 verification items that correspond to independently verifiable states, not a single "did you do it" checkbox
- Consider adding a `type: 'command-check'` field to VerificationChecklist items for challenge exercises — the hint becomes the verification command the learner runs and compares against expected output
- Never write a challenge-mode exercise with fewer verification checkpoints than Foundation exercises for the same topic

**Warning signs:**
- Challenge exercise verification items are written as vague accomplishment statements ("you deployed the stack")
- Fewer than 3 verification items for any challenge exercise
- No expected command output is specified in any hint field
- A challenge-mode exercise can be "completed" by reading it without touching a terminal

**Phase to address:**
Phase 1 (design). The challenge-mode exercise template must include the verification pattern before any challenge-mode content is written. This cannot be retrofitted after 20 challenge exercises are written.

---

### Pitfall 4: Command Reference Sheet Scope Creep — Becoming a Second Lesson

**What goes wrong:**
Challenge-mode exercises provide a command reference sheet instead of step-by-step instructions. Reference sheets intended to be a constrained "you may need these" guide expand into full command tutorials — every flag documented, every edge case noted, with examples for each. The reference sheet becomes longer and more instructional than the original Foundation lesson it accompanies. Learners read the reference sheet as a lesson and the challenge reduces to following its implicit sequence.

**Why it happens:**
Reference sheet authors know the material thoroughly and want to be complete. The QuickReference component (`sections[].items[]` with `command`, `description`, `example`) has no structural limit on how much content it can hold. There is no content policy differentiating "reference" from "tutorial."

**How to avoid:**
- Define a hard content budget for challenge-mode reference sheets: maximum 15 items, no sequential ordering (commands listed alphabetically or by category, never in the order you would use them), no "first do X, then do Y" narrative
- Reference sheet items must not name the solution — they can list `docker compose up --build` as a command but cannot say "use this to build and start your application from scratch"
- Use the existing QuickReference component without adding narrative structure; the component's table format enforces conciseness naturally
- Review reference sheets separately from exercises — read the reference sheet alone and verify it does not imply a solution sequence

**Warning signs:**
- Reference sheet has more than 15 command items
- Any reference sheet item description contains the words "first," "then," "after," or "next"
- Reference sheet items are ordered in the sequence the challenge requires them
- A learner could complete the challenge without reading the challenge description — only the reference sheet

**Phase to address:**
Phase 1 (design). Write the reference sheet policy before writing the first challenge-mode exercise.

---

### Pitfall 5: MDX Prop Serialization Failure — Annotation Objects Cause Parse Errors

**What goes wrong:**
MDX parses JSX prop values as JavaScript expressions. The existing `steps` prop is an array of objects with simple string values. Annotation data is more complex: `annotations={[{ flag: '-it', description: '...', example: '...' }]}`. If the annotation description string contains unescaped quotes, angle brackets, curly braces, or backticks, the MDX parser throws a parse error that blocks the entire lesson from rendering — not just the annotation. This is a hard failure, not a degraded experience.

**Why it happens:**
MDX inline JSX expressions do not support JavaScript template literals or multi-line strings in prop values. Writing `description="Run as --rm cleans up the container when it exits"` is fine; writing `description="The -v flag mounts a volume: /host:/container"` with a colon in a quoted attribute can confuse parsers in some MDX configurations. Complex annotation data written directly as inline JSX props is fragile.

**How to avoid:**
- Keep annotation data in co-located TypeScript data files rather than inline JSX in MDX: `import { annotations } from './annotations/03-filesystem.ts'` and `<ExerciseCard annotations={annotations} ...>`
- If inline is required, restrict annotation strings to single-line, no embedded quotes, no curly braces, no markdown syntax — enforce this with a linter rule or content style guide
- Test MDX parse in `next build` after writing each annotated exercise, not in batch — catch parse errors one at a time rather than all at once
- Prefer double quotes in annotation prop values and use HTML entities for embedded quotes if needed

**Warning signs:**
- Any annotation description string contains `"`, `` ` ``, `{`, `}`, or `<` characters
- Annotation data is written inline in MDX for complex, multi-sentence descriptions
- `next build` is only run after a batch of annotations are written
- The team writes all annotations before testing any of them in the browser

**Phase to address:**
Phase 1 (design). Decide inline vs. imported data pattern before writing any annotation content. The pattern choice determines whether this pitfall exists at all.

---

### Pitfall 6: Difficulty Label Divergence — Frontmatter Difficulty vs. ExerciseCard Difficulty

**What goes wrong:**
Each lesson has a `difficulty` in frontmatter (the lesson-level difficulty). Each `ExerciseCard` has its own `difficulty` prop (the exercise-level difficulty). These can diverge — a lesson with `difficulty: "Foundation"` in frontmatter that contains an `<ExerciseCard difficulty="Intermediate" ...>` already exists in the codebase (e.g., the Processes lesson is `Intermediate` but has steps structured more like Foundation content). When the new rendering logic uses `difficulty` to decide "show annotations" vs. "show challenge mode," the wrong `difficulty` value drives the wrong rendering path.

**Why it happens:**
The annotation/challenge-mode feature is described as "difficulty-aware exercise rendering tied to existing Foundation/Intermediate/Challenge system." This is ambiguous — tied to which `difficulty`? The lesson frontmatter or the ExerciseCard prop? They can differ. If the new component reads props.difficulty, it is tied to the ExerciseCard prop. If it reads a context value from lesson frontmatter, it is tied to the lesson. Neither is wrong, but they must be deliberately chosen and consistently applied.

**How to avoid:**
- Establish the rule explicitly in Phase 1: annotation rendering is tied to the ExerciseCard `difficulty` prop, not lesson frontmatter
- Audit all lessons where ExerciseCard `difficulty` differs from frontmatter `difficulty` before implementing the rendering logic — there may be 5-10 such cases
- The ExerciseCard prop is the source of truth because it is the component that renders the exercise; frontmatter is for navigation/filtering

**Warning signs:**
- The word "difficulty-aware" appears in implementation decisions without specifying which `difficulty` field
- A Foundation exercise in an Intermediate lesson renders annotations (when it should show challenge mode, or vice versa)
- The team does not know how many ExerciseCard/frontmatter difficulty mismatches exist before starting implementation

**Phase to address:**
Phase 1 (design). Run the audit before writing any rendering logic.

---

### Pitfall 7: Content Migration Without a Migration Script — Manual Error at Scale

**What goes wrong:**
Adding annotations to 22 Foundation lessons means touching ~200 ExerciseCard step entries across 52 MDX files. Doing this by hand introduces inconsistencies: some annotations use `flag` as the key, others use `flags`; some include the leading dash (`-it`), others omit it (`it`); description prose style varies wildly between lessons written by different contributors (even if the same author, written across weeks). The corpus looks inconsistent and learners lose trust.

**Why it happens:**
Content migrations at this scale feel manageable when you think about them lesson-by-lesson ("just 22 lessons") but each lesson has multiple steps, each step has multiple flags to annotate. No tooling is used to enforce schema consistency. Human pattern-matching is applied to data that should be machine-validated.

**How to avoid:**
- Write a TypeScript type for the annotation schema and generate a JSON schema from it; validate all annotation data against the schema before building
- Use a consistent annotation style guide: flag format (always with leading dash), description length (one sentence, max 120 chars), example format (actual runnable snippet)
- Consider a code generation approach: write a canonical annotation source (TypeScript constant files per lesson) that gets imported into MDX, rather than authoring annotations inline per-lesson
- Do a content review pass after each module's annotations are complete — read all annotations in one sitting to catch voice/format drift

**Warning signs:**
- Annotations are written directly in MDX without a shared TypeScript type enforcing the schema
- No style guide exists for annotation prose format before migration starts
- The team discovers annotation format inconsistencies during the final review pass, not during migration

**Phase to address:**
Phase 1 (design). Schema and style guide must exist before the first annotation is written.

---

### Pitfall 8: ExerciseCard Step Command Embedded in UI — Annotation Renders Next to Unrelated Command

**What goes wrong:**
The existing `ExerciseCard` step structure has `{ step, description, command? }`. The `command` field is a string rendered in a `<code>` block. For annotation to work, the annotation data must be structurally paired with the command it annotates. If annotations are passed as a separate prop array indexed by step number, any reordering of steps or insertion of a step without a command breaks the index alignment — step 4's annotation appears under step 5's command, or annotations are shown for descriptive steps that have no command at all.

**Why it happens:**
Separating annotation data from the step data it belongs to creates an implicit coupling that breaks when content changes. Authors add a step, forget to update the annotation array index, and the mismatch is invisible in code review but visible (and confusing) in the rendered lesson.

**How to avoid:**
- Annotations must be co-located with the step they annotate — extend the step object: `{ step, description, command?, annotations?: CommandAnnotation[] }`
- Never implement annotations as a parallel top-level prop indexed by step number
- This means the ExerciseCard step interface does change — but it changes by adding an optional field to each step object, not by changing any required field
- Enforce in code review: every `command` field in a Foundation ExerciseCard should have an accompanying `annotations` array (can be empty but must be present as intent marker)

**Warning signs:**
- Annotation data is stored as a top-level `annotations` prop on ExerciseCard rather than nested in each step
- Steps with descriptions but no `command` have annotation entries
- Annotation count for a lesson does not match command count for that lesson

**Phase to address:**
Phase 1 (design). This structural decision is load-bearing — it determines how MDX is written for all 22 Foundation lessons.

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Add annotation rendering directly into ExerciseCard with multiple if/else blocks | Single file to change | ExerciseCard becomes a god component handling Foundation, Intermediate, and Challenge rendering in one 200-line file | Never — extract to sub-components |
| Write annotations inline in MDX as raw JSX props | No import boilerplate | Parse errors on any special character; annotation data is not reusable or queryable | Only for short, simple annotations with no special characters |
| Use lesson frontmatter `difficulty` to drive annotation rendering | Simpler — no prop needed | Diverges from ExerciseCard prop; wrong rendering when frontmatter and prop disagree | Never |
| Ship challenge-mode with placeholder reference sheets ("coming soon") | Faster initial launch | Learners encounter challenge exercises with no reference material; worse than Foundation exercises | Never — do not ship partial challenge-mode |
| Add a global `ANNOTATION_ENABLED = true` flag to gate the feature | Easy on/off during development | Feature flag proliferation; old branches of conditionals rot; hard to remove later | Acceptable during development only, must be removed before merge |
| Write all 22 Foundation annotation sets before testing any | Maximizes batch efficiency | Batch parse errors discovered at test time, not write time; all rework at once | Never — test each module after annotating it |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| MDX + complex JSX props | Writing multi-line object literals as inline prop values in MDX | Import annotation data from `.ts` files; keep MDX props simple strings and booleans |
| rehype-pretty-code + annotation overlay | Adding annotation UI inside the `<pre>` element that rehype-pretty-code wraps | Annotation UI must be outside `<pre>` — use a wrapper `<div>` in ExerciseCard, not inside CodeBlock |
| ExerciseCard in mdx-components.tsx | Passing new annotation component from mdx-components without registering it | Any new component used in MDX (e.g., `CommandAnnotation`) must be registered in `useMDXComponents` in `mdx-components.tsx` |
| QuickReference for challenge reference sheets | Using `children` markdown table mode (prose mode) instead of structured `sections` prop | Use structured `sections` prop for reference sheets — it enforces table format and resists scope creep; markdown children mode allows arbitrary prose |
| VerificationChecklist in challenge-mode | Reusing the same component with no changes | Challenge verification items need a richer `hint` field with exact commands and expected output — document this in the style guide even if the component does not change |

---

## Performance Traps

For a local Next.js app read by one user, traditional performance at scale is not the concern. The traps here are build-time and authoring-time.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Importing annotation data from many `.ts` files in MDX | `next build` time grows as each MDX file now imports a companion `.ts` file | Structure annotations as static JSON imports, not full TypeScript modules | After 20+ annotated lessons |
| Large annotation datasets inline in MDX | MDX compilation of individual lesson files slows; hot reload during development lags | Keep annotation arrays small per step (2–5 flags max); move large datasets to imports | Any step with 10+ annotation entries |
| ExerciseCard re-rendering on annotation expand/collapse | If annotation state is lifted to ExerciseCard level, toggling one annotation collapses/expands the whole card | Annotation open/close state must be local to the annotation subcomponent, not ExerciseCard | Every annotation interaction |

---

## UX Pitfalls

| Pitfall | Learner Impact | Better Approach |
|---------|----------------|-----------------|
| Annotation displayed by default (always expanded) | Foundation lessons become visually dense; learner cannot scan the command first | Annotations collapsed by default; learner clicks/taps to reveal flag explanations |
| Annotation displayed for every token including the command name | Annotations for `docker` itself on every Docker lesson step; learner already knows the main command | Only annotate flags and arguments, not the base command name |
| Challenge reference sheet appears above the challenge description | Learner reads solutions before reading the problem | Reference sheet always below the objective and scenario sections |
| No visual distinction between Foundation (annotated) and Intermediate/Challenge (no annotations) | Learner in an Intermediate lesson expects annotations that are not there | Difficulty badge already exists in ExerciseCard header — add subtle copy under the badge: "Foundation exercises include command annotations" |
| Challenge mode looks identical to Foundation mode except commands are missing | Learner thinks the exercise is incomplete or broken | Challenge-mode ExerciseCard needs distinct visual treatment — different header copy, reference sheet component, goal-oriented step wording ("Achieve..." not "Run...") |
| Annotation popover clips on mobile/tablet | Annotation explanation cut off; learner scrolls to find it | Use inline expand (accordion below command) not tooltip/popover; the lesson is prose-heavy, inline expansion respects flow |

---

## "Looks Done But Isn't" Checklist

- [ ] **Annotation component:** Annotations are collapsed by default — verify they do not auto-expand on lesson load
- [ ] **ExerciseCard interface:** All new props are optional — verify `next build` passes on all 52 existing ExerciseCard usages without any MDX changes
- [ ] **Foundation annotation coverage:** All Foundation lesson step `command` fields have `annotations` arrays — verify no Foundation step with a command has an empty/missing annotations field after migration
- [ ] **Challenge-mode verification:** Every challenge exercise has 3–5 precise verification items with specific commands in hints — verify no item is a vague accomplishment statement
- [ ] **Reference sheet scope:** No reference sheet has more than 15 items or uses sequential ordering language — read each one as if you are a learner who has not read the lesson
- [ ] **MDX parse health:** `next build` passes clean after each module's content is written — verify before moving to next module, not after all modules are done
- [ ] **Difficulty source:** ExerciseCard `difficulty` prop, not frontmatter, drives annotation rendering — verify the rendering logic reads `props.difficulty`, not a context or page-level value
- [ ] **New component registration:** Any new MDX-usable component is registered in `mdx-components.tsx` — verify by using it in one test lesson and checking the rendered output
- [ ] **Challenge vs. Foundation rendering in same lesson:** If a lesson has both a Foundation and Intermediate ExerciseCard, verify each renders its correct mode independently

---

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Prop interface breaking 52 lessons | HIGH — TypeScript errors block build | Revert ExerciseCard interface change; redesign as optional-only additions; re-run build |
| Annotation coverage inconsistency (half-annotated modules) | MEDIUM — content work, not code | Gate annotation display on per-exercise `annotated` prop; unannotated exercises show nothing new; complete remaining modules before removing the gate |
| MDX parse errors from annotation strings | LOW per error, MEDIUM if batched | Run `next build` after each lesson; parse errors are line-specific; fix character escaping or move to imported data |
| Challenge-mode verification too vague | MEDIUM — requires content rewrite, not code | Audit all verification items; rewrite vague items with specific commands + expected output; does not require component changes |
| Reference sheet scope creep | LOW — content edit only | Edit reference sheets to remove sequential/narrative items; trim to 15 items; no component changes needed |
| Difficulty source confusion (wrong field drives rendering) | MEDIUM — requires component logic fix + regression test | Fix rendering to use ExerciseCard prop; audit all lessons where prop and frontmatter disagree; verify each in browser |
| Annotation co-location vs. parallel array misalignment | HIGH if caught late — requires content rework | If caught during design (Phase 1): choose co-located structure before any content is written; if caught mid-migration: rewrite annotations into step objects |

---

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| ExerciseCard prop interface breakage | Phase 1: Component design — all new props optional | `next build` passes with zero MDX changes after interface update |
| Annotation coverage inconsistency | Phase 1: Audit — count all Foundation command fields before migration | Checklist of Foundation lessons with command counts exists before Phase 2 starts |
| Challenge verification integrity | Phase 1: Template design — verification pattern defined before any challenge content | No challenge exercise has fewer than 3 verification items; all hints include runnable commands |
| Reference sheet scope creep | Phase 1: Policy — reference sheet content rules defined in style guide | Read each completed reference sheet and confirm it has no sequential narrative |
| MDX prop serialization failures | Phase 1: Pattern decision — inline vs. imported annotation data | `next build` runs clean after each module is annotated |
| Difficulty label divergence | Phase 1: Audit — identify all ExerciseCard/frontmatter mismatches | Rendering reads ExerciseCard prop; mismatches documented and intentionally resolved |
| Manual migration inconsistency | Phase 1: Schema + style guide — TypeScript type + prose rules defined first | All annotation data validates against schema; style review per module |
| Annotation/step misalignment | Phase 1: Structure decision — annotations co-located in step objects | No lesson has a top-level `annotations` prop on ExerciseCard |

---

## Sources

- Direct codebase inspection: `components/content/ExerciseCard.tsx`, `components/content/VerificationChecklist.tsx`, `components/content/QuickReference.tsx`, `components/content/TerminalBlock.tsx`, `mdx-components.tsx` — HIGH confidence
- Direct content inspection: 56 MDX lessons in `content/modules/`, `_exercise-template.mdx` — HIGH confidence; 22 Foundation lessons identified, ~200 command fields estimated
- [MDX JSX expression parsing edge cases — MDX docs](https://mdxjs.com/docs/what-is-mdx/#expressions) — string literal restrictions in JSX attribute values (MEDIUM confidence; verified by reading official docs)
- [Next.js MDX configuration — Next.js docs](https://nextjs.org/docs/app/guides/mdx) — component registration in useMDXComponents required for custom components (HIGH confidence, official)
- [Cognitive scaffolding in programming education — ACM Computing Surveys](https://dl.acm.org/doi/10.1145/3457922) — graduated difficulty scaffolding; removing scaffolding without replacement causes performance drop (MEDIUM confidence)
- [Worked examples vs. problem solving in skill acquisition — Sweller 1994, revisited in Kalyuga 2007](https://link.springer.com/article/10.1007/s10648-007-9053-6) — annotations as worked-example scaffolding appropriate for novices; challenge mode appropriate for intermediate learners (HIGH confidence, established instructional design research)
- Existing `PITFALLS.md` v1 research (2026-03-18) — tool-operator syndrome, verification integrity patterns already established for this codebase (HIGH confidence, project-specific)

---
*Pitfalls research for: v1.1 Command Pedagogy — Annotation + Challenge-Mode Retrofit*
*Researched: 2026-03-20*
