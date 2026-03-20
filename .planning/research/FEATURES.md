# Feature Research

**Domain:** CLI Command Pedagogy — Annotated Commands and Challenge-Mode Exercises
**Researched:** 2026-03-20
**Confidence:** HIGH (existing component audit), MEDIUM (competitor pedagogy patterns), HIGH (instructional design research)

---

## Context: What Already Exists (v1.0 Baseline)

Before identifying what to build, the existing component set must be understood as constraints and integration targets.

**Built and working:**
- `ExerciseCard` — collapsible card with `difficulty`, `scenario`, `objective`, `steps[]`. Each step has optional `command` field rendered as monospace inline code.
- `CodeBlock` — syntax-highlighted block with copy button and filename header. Wraps rehype-pretty-code output.
- `VerificationChecklist` — checkable items with expandable `hint` field. Nested inside `ExerciseCard` as children.
- `QuickReference` — table of `{ command, description, example }` items grouped into sections. Currently used as standalone cheat-sheet component.
- `TerminalBlock` — simulates terminal output with `{ type: 'command' | 'output' | 'comment', content }` lines. Used in lesson prose.
- `Callout` — styled tip/warning/deep-dive callout boxes.
- `Difficulty` type — union `"Foundation" | "Intermediate" | "Challenge"`. Already stored on every lesson's frontmatter and passed to `ExerciseCard`.

**Current gap being addressed by v1.1:**
The `difficulty` prop on `ExerciseCard` is purely cosmetic — it changes the badge color only. Foundation, Intermediate, and Challenge exercises all render identically: numbered steps with optional `command` inline code. No difference in scaffolding level, no annotation, no reference-sheet mode.

---

## Feature Landscape

### Table Stakes (Users Expect These)

Features that any credible CLI pedagogy system provides. Missing these = the difficulty system is theater, not learning design.

| Feature | Why Expected | Complexity | Dependency on Existing Components |
|---------|--------------|------------|-----------------------------------|
| Per-flag inline annotation on Foundation commands | The primary value of "Foundation" difficulty is full explanation, not just a command to copy. Learners at this level don't yet have mental models to decode flags from context. explainshell.com's entire existence proves there is demand for per-token command explanation. | MEDIUM | Extends existing `ExerciseCard.steps[]` — adds `annotations` array to the step schema alongside the existing `command` field. Does not require a new component; `ExerciseCard` renders them conditionally on difficulty. |
| Command reference sheet in Challenge exercises | Challenge exercises (HTB, OverTheWire, KodeKloud Engineer) universally provide a reference of available commands without prescribing which to use. The learner must figure out the sequence. Without a reference sheet, Challenge becomes a memorization test, not a problem-solving test. | LOW | `QuickReference` component already exists and works. Challenge exercises need it embedded in `ExerciseCard` children alongside `VerificationChecklist`. |
| Objective-only display for Challenge difficulty | OverTheWire, HTB Guided Mode, and KodeKloud all distinguish "here are the steps" from "here is the goal, figure it out." Challenge exercises should hide the `steps` array and show only `scenario`, `objective`, and the reference sheet. | MEDIUM | `ExerciseCard` currently always renders `steps`. Needs a branch: if `difficulty === "Challenge"`, render goal + reference; suppress step list. |
| Foundation annotation visible inline (not tooltip/hover) | Tooltips fail on mobile and require hover-discovery. Learners on a learning platform aren't expected to discover hover states. All major teaching platforms (Codecademy, KodeKloud, MDN) show explanations as visible, static text. ExplainShell uses spatial separation — command token above, explanation below — which is the dominant pattern. | LOW | Static rendering. No interactive state needed. Pure presentational. |
| Intermediate exercises suppress commands but keep steps | The middle tier: learners know what to do conceptually but may not recall exact syntax. Steps should describe what to do without providing the command. The learner must recall or look up the command themselves. This is the scaffolding-fading pattern from instructional design research (fade-in scaffolding is better for novice programmers — PMC 2022 study). | MEDIUM | Requires `ExerciseCard` to conditionally hide `command` field in `steps` when `difficulty === "Intermediate"`. Step descriptions must be written to be actionable without the command. |

### Differentiators (Competitive Advantage)

Features that go beyond what competitors provide and align with this course's "understand the mechanism" core value.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Anatomical annotation format with command-then-breakdown | Rather than a separate tooltip, show the full command first (complete, copyable) and then an indented breakdown per flag. This matches how tldr-pages and the Unix Shell instructor notes structure explanations — command first, then what each part means. Learners can copy the command immediately and understand it simultaneously. | MEDIUM | Requires a new data shape: `{ command: string, annotations: { token: string, meaning: string }[] }`. Renders as command block + indented annotation rows below it. |
| Difficulty-aware rendering as a first-class prop (not CSS only) | Most platforms use difficulty as a label. This course uses it to change what the learner sees: full scaffolding, partial scaffolding, or goal-only. This is the scaffolding-fading principle applied consistently. | MEDIUM | One behavior change per difficulty tier, controlled inside `ExerciseCard`. No new component needed. |
| Challenge exercises surface `QuickReference` inline | Most challenge platforms link to external docs. Embedding the relevant command reference inside the exercise card keeps the learner in context and makes the reference set explicitly scoped to what was taught in this module. Learners don't get lost in man pages. | LOW | Existing `QuickReference` sections prop pattern works. Challenge `ExerciseCard` children get a scoped reference. |
| Annotation format survives MDX serialization | Annotations must be expressible as a JSX prop array in MDX, not requiring a separate data file. The existing `steps` prop already uses this pattern (`steps={[{ step: 1, description: "...", command: "..." }]}`). Annotations extend this cleanly. | LOW | Data modeling decision. Array of objects in JSX props is already established by `steps`. |

### Anti-Features (Commonly Requested, Often Problematic)

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Tooltip-based flag explanations (hover to reveal) | Tooltips feel "clean" — no vertical space cost. explainshell.com uses spatial separation, which some interpret as tooltips. | Hover is undiscoverable on mobile and tablets. Learners at Foundation level need persistent visibility, not discoverable overlays. Tooltip state management adds complexity for zero pedagogical gain over static text. | Inline annotation rows below the command. Visible always. Learners scan down to read, skip if they already know the flag. |
| Live shell integration in the annotation | "Run the command and highlight which flag produced which output" seems pedagogically ideal. | Requires a browser terminal, significant infrastructure, and always-on execution environment. Project.md explicitly defers browser terminal to Future. Annotation is a static teaching aid, not a debugger. | Annotate in prose: "this flag causes X behavior." Pair with `TerminalBlock` showing expected output when needed. |
| Per-step difficulty (mix of annotated and bare commands in one exercise) | Granular control is appealing. | Inconsistent scaffolding within one exercise breaks the mental model. Learners at Foundation level need consistency — they can't context-switch between "this step is annotated, this step is not." The difficulty is on the exercise, not the step. | Pick difficulty per exercise. Author a Foundation version with annotations and an Intermediate version without commands if truly needed — but this doubles content authoring burden. Avoid. |
| Auto-detect difficulty from command complexity | "Parse the command and automatically annotate complex flags" sounds efficient. | Shell commands don't have a stable grammar for automated parsing in React. Would require shipping a bash parser or calling an external service. The annotation data belongs in the lesson content where the author controls meaning, not inferred by a parser. | Author annotations explicitly in MDX. The author knows what the learner needs explained; a parser does not. |
| Animated scaffolding reveal (type in the command yourself) | "Typing the command yourself improves retention" is a real effect. | Requires a controlled input component, focus management, keyboard event handling, and accessible fallbacks. Significant complexity for modest pedagogical gain. This is in scope for the deferred browser terminal feature, not for annotation. | Read and understand the command with annotations before running it. Manual typing in a real terminal (not a simulated one) is the actual practice. |
| Separate Challenge "lesson" type vs difficulty="Challenge" on ExerciseCard | Having a distinct MDX component for challenge lessons seems architecturally clean. | Creates divergence from the established pattern. 56 existing lessons all use `ExerciseCard`. A separate component means authoring and rendering two parallel systems. The existing `difficulty` prop is the right control point. | Extend `ExerciseCard` behavior based on `difficulty`. Keep one component, one authoring pattern. |

---

## Feature Dependencies

```
[Annotated Command Block (Foundation)]
    └──extends──> [ExerciseCard] (adds annotations field to ExerciseStep)
    └──requires──> [ExerciseCard difficulty-aware rendering]

[Difficulty-Aware ExerciseCard Rendering]
    └──gates──> [Intermediate command suppression]
    └──gates──> [Challenge goal-only mode]
    └──is the core deliverable for v1.1]

[Challenge Reference Sheet Integration]
    └──uses──> [QuickReference] (already exists, no changes)
    └──requires──> [ExerciseCard Challenge mode] (to know when to surface reference)
    └──enhances──> [VerificationChecklist] (both live in ExerciseCard children)

[Intermediate Command Suppression]
    └──requires──> [ExerciseCard difficulty-aware rendering]
    └──conflicts with──> [Per-step difficulty overrides] (don't build this)

[Content Migration: 56 Lessons]
    └──requires──> [Annotated Command Block] (to add annotations to Foundation steps)
    └──requires──> [Intermediate command suppression] (remove commands from Intermediate step objects)
    └──requires──> [Challenge reference sheets] (add QuickReference to Challenge ExerciseCard children)
    └──this is the highest-effort task in v1.1]
```

### Dependency Notes

- **ExerciseCard is the single control point:** All three difficulty-tier behaviors flow through one component. Build the rendering logic there first, then migrate content. Don't attempt content migration before the component is complete.
- **Annotation data lives in MDX, not a separate file:** The `steps` prop already accepts arrays of objects. Annotations extend that shape. No new data pipeline.
- **QuickReference is already built:** Challenge mode doesn't require a new component. It requires the Challenge `ExerciseCard` variant to include `QuickReference` in its children — which is just an authoring convention, not new code.
- **Content migration is independent of component work:** Once the component is updated, each lesson can be migrated independently. They do not block each other.

---

## MVP Definition for v1.1

### Launch With

Minimum to make the difficulty system meaningful, not cosmetic.

- [ ] `ExerciseCard` renders differently for each difficulty — Foundation (annotated), Intermediate (steps without commands), Challenge (goal + reference, no steps). This is the core deliverable.
- [ ] Annotation data shape defined and documented in `_exercise-template.mdx`. Authors need to know the schema before migrating content.
- [ ] Foundation annotation format: command block (full, copyable) + per-flag breakdown rows below. Static. No hover required.
- [ ] Challenge mode: `scenario` + `objective` displayed prominently; `steps` hidden; `QuickReference` surfaces in children slot.
- [ ] At least one migrated example per difficulty tier (proof that content works with the new rendering). Does not require all 56 lessons to be migrated before v1.1 ships.

### Add After Validation (v1.1.x)

- [ ] Full content migration: annotate all Foundation exercises (est. ~20 lessons), strip commands from Intermediate (est. ~20 lessons), add reference sheets to Challenge (est. ~3 lessons). Migration can be phased across several sessions.
- [ ] Update `_exercise-template.mdx` with full authoring guide for all three difficulty tiers.

### Future Consideration (v2+)

- [ ] Browser terminal — in-browser execution environment. Deferred per PROJECT.md. Annotation is meaningful without it; the learner runs commands in their own terminal.
- [ ] Auto-graded exercise responses. Deferred per PROJECT.md.

---

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| ExerciseCard difficulty-aware rendering (all 3 tiers) | HIGH | MEDIUM | P1 |
| Foundation annotation data schema | HIGH | LOW | P1 |
| Foundation annotation rendering (command + breakdown) | HIGH | MEDIUM | P1 |
| Challenge mode (goal-only, reference sheet visible) | HIGH | LOW | P1 |
| Intermediate mode (steps visible, commands hidden) | HIGH | LOW | P1 |
| Content migration: Foundation lessons (~20 lessons) | HIGH | HIGH | P2 |
| Content migration: Intermediate lessons (~20 lessons) | MEDIUM | MEDIUM | P2 |
| Content migration: Challenge lessons (~3 lessons) | MEDIUM | LOW | P2 |
| Authoring guide in `_exercise-template.mdx` | MEDIUM | LOW | P2 |

---

## Competitor Feature Analysis

How existing CLI teaching platforms handle the guided-to-self-directed spectrum.

| Pattern | Platform | Implementation | Applicability to This Project |
|---------|----------|----------------|-------------------------------|
| Goal-only challenges (no steps) | OverTheWire Bandit, HTB Adventure Mode | SSH into a machine, description of what to find, no guidance. Pure discovery. | Foundation of the Challenge mode. Match this: scenario + objective only, learner figures out the how. |
| Guided steps with question hints | HTB Guided Mode | Questions guide toward the solution without giving it away. Available only on Easy difficulty machines. | Maps to Foundation — steps guide the sequence, annotations explain the why. |
| Guided + checkpoint + skills assessment | HTB Academy, KodeKloud | Material in sections → checkpoint exercise → end-of-module skills assessment (no guidance). | Maps to the three tiers: theory (lesson prose) → Foundation exercise → Challenge exercise. |
| Fading scaffolding | Instructional design research (PMC 2022, scaffolding literature) | Start with full support (worked examples, annotated commands), progressively remove until learner operates independently. "Fade-in scaffolding is better than fade-out for novice programmers." | Direct justification for Foundation (full annotation) → Intermediate (steps, no commands) → Challenge (goal only). |
| Embedded command reference in challenge | KodeKloud Engineer | Challenge provides a scoped reference of relevant commands. Not a full man page — just what applies to this task. | `QuickReference` embedded in Challenge `ExerciseCard` children. Already the right component. |
| Command + example breakdown (not per-flag) | tldr-pages | Example-first. Shows command, then brief description. No per-flag detail, but practical context. | Foundation annotations should exceed tldr — annotate each flag, not just the command. |
| Spatial per-token annotation | explainshell.com | Command parsed into tokens, each token linked to its man page excerpt below. Visual separation: command row, then explanation rows. | The annotation format pattern: full command first (copyable), then per-flag breakdown rows below. Static, not interactive. |
| No annotation (read the man page) | Exercism, OverTheWire | Platform gives no command explanation. Learner uses man/tldr/docs. | Appropriate for Challenge level only. Foundation must annotate. |

---

## Sources

- Existing codebase audit: `/components/content/ExerciseCard.tsx`, `QuickReference.tsx`, `VerificationChecklist.tsx`, `CodeBlock.tsx` — HIGH confidence, direct inspection.
- Existing lesson content: `content/modules/01-linux-fundamentals/04-file-permissions.mdx`, `05-processes.mdx`, `content/modules/03-docker/09-foundation-capstone.mdx` — HIGH confidence, direct inspection.
- [explainshell.com](https://explainshell.com/) — spatial per-token annotation UX pattern. MEDIUM confidence (site inspected, full UI not rendered via fetch).
- [HackTheBox Guided Mode announcement](https://www.hackthebox.com/blog/guided-mode) — guided vs adventure mode distinction. HIGH confidence, official source fetched.
- [HTB Academy FAQ](https://academy.hackthebox.com/faq) — module structure: theory + checkpoints + skills assessments. MEDIUM confidence (FAQ text only, not module screenshots).
- [KodeKloud hands-on lab format](https://kodekloud.com/blog/hands-on-devops-cloud-ai-learning-2025/) — embedded labs + challenge format with automated validation. MEDIUM confidence (marketing blog).
- [OverTheWire Bandit format](https://overthewire.org/wargames/bandit/) — goal-only challenge model, password-finding CTF structure. HIGH confidence, well-documented.
- [Codecademy 2024 Learn Command Line updates](https://www.codecademy.com/resources/blog/updates-learn-the-command-line/) — clearer hints, added exercises, AI feedback. MEDIUM confidence (blog post).
- [PMC: Fade-in vs fade-out scaffolding for novice programmers (2022)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8782216/) — "fade-in scaffolding is better than fade-out for novice programmers, and novices need scaffolding for a long time." HIGH confidence, peer-reviewed research.
- [tldr-pages format spec](https://github.com/tldr-pages/tldr/blob/main/contributing-guides/style-guide.md) — example-first command explanation pattern. HIGH confidence, official repository.

---

*Feature research for: v1.1 Command Pedagogy — Annotated Commands and Challenge-Mode Exercises*
*Researched: 2026-03-20*
