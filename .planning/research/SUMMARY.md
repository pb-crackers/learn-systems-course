# Project Research Summary

**Project:** learn-systems v1.1 — Command Pedagogy
**Domain:** CLI teaching platform retrofit — annotated command blocks and challenge-mode exercises
**Researched:** 2026-03-20
**Confidence:** HIGH

## Executive Summary

v1.1 is a focused retrofit of an existing, working Next.js MDX course platform. The core problem is that the `difficulty` prop on `ExerciseCard` is purely cosmetic — Foundation, Intermediate, and Challenge exercises all render identically (numbered steps with optional inline `command` code). Research confirms this is fixable with minimal new dependencies: one npm package (`@shikijs/transformers@4.0.2`, matching the already-installed `shiki` version) and two new authored components (`AnnotatedCommand`, `ChallengeReferenceSheet`), both built on already-installed primitives. All three tier behaviors flow through a single modified `ExerciseCard` — this is the single control point, and all implementation depends on it being designed correctly first.

The recommended approach is bottom-up construction with strict interface contracts established before any content migration. `ExerciseCard` is consumed across 52 MDX lesson files — all new props must be strictly optional, and the existing `steps` array item shape must not change to add required fields. Architecture research (based on direct codebase inspection) confirms that a `preferredMode` global preference lives in `ProgressProvider` under a separate localStorage key (`'learn-systems-preferences'`), a `DifficultyToggle` client component in `LessonLayout` writes to it, and `ExerciseCard` resolves effective mode via a three-tier fallback chain: explicit `mode` prop, then learner preference, then difficulty default. The build order is non-negotiable: context/types, then leaf components, then `ExerciseCard` modification, then `LessonLayout` integration.

The highest-risk area is content migration: 22 Foundation lessons with approximately 200 `command` step entries that each need an `annotations` array co-located in the step object (not a parallel top-level array indexed by step number). Pitfalls research is emphatic on two constraints: annotation data must be structurally co-located with the step it annotates to prevent silent misalignment on step reordering, and `next build` must be run after each module — not in batch — to catch MDX prop serialization errors early. Challenge-mode content carries a parallel risk: reference sheets must be capped at 15 items with no sequential ordering language, and verification items must specify exact runnable commands with expected output rather than vague accomplishment statements. Eight distinct pitfalls are classified as Phase 1 prevention items — all design decisions must be locked before any code or content is written.

---

## Key Findings

### Recommended Stack

The platform already runs Next.js 16.2, React 19, Tailwind v4, `@next/mdx` 3.1.1, `rehype-pretty-code` 0.14.3, `shiki` 4.0.2, and `@base-ui/react` 1.3.0. v1.1 adds one npm package and two authored components — everything else is reuse of existing primitives.

**Core technologies:**
- `@shikijs/transformers@4.0.2`: Word highlighting via `[!code word:X]` notation in existing code fences — ships at the same major version as the installed `shiki` 4.0.2; slots into the existing `rehype-pretty-code` `transformers: ShikiTransformer[]` option with no version conflict; added to `next.config.ts` only
- `AnnotatedCommand` (new authored component, zero deps): Renders a full CLI command with a collapsible per-token annotation panel below — built on `@base-ui/react` Tooltip (already at v1.3.0); registered in `mdx-components.tsx`; 'use client' required for collapse state
- `ChallengeReferenceSheet` (new authored component, zero deps): Thin wrapper over existing `QuickReference` with distinct visual treatment (different border accent, "Command Reference" header label); reuses exported `ReferenceSection` and `ReferenceItem` types; starts as a server component

What NOT to add: Code Hike (replaces rehype-pretty-code entirely — not additive; migration cost is the entire lesson corpus), `@radix-ui/react-tooltip` (`@base-ui/react` already provides Tooltip at v1.3.0), `framer-motion` (Tailwind CSS transitions cover accordion behavior), any global state management library (annotation state is component-local, progress uses the existing `localStorage` hooks).

### Expected Features

**Must have (table stakes — these make the difficulty system meaningful, not cosmetic):**
- Per-flag inline annotation on Foundation commands — full visible breakdown below each command; collapsed by default, learner expands; static (no hover required), persists for mobile users
- Difficulty-aware ExerciseCard rendering — Foundation (annotated steps), Intermediate (steps without commands), Challenge (goal + reference sheet, no step list)
- Challenge-mode goal-only display — shows `challengePrompt` paragraph, `ChallengeReferenceSheet`, and `VerificationChecklist` children; hides numbered step list entirely
- Intermediate command suppression — step descriptions remain but `command` field is not rendered; learner must recall or look up syntax (scaffolding-fading principle from instructional design research)
- Global `preferredMode` toggle in lesson header for Challenge-difficulty lessons — learner switches between guided and challenge for the whole page at once, stored persistently

**Should have (differentiators):**
- Anatomical annotation format: full command first (copyable), then per-flag breakdown rows below — matches explainshell.com spatial pattern and tldr-pages example-first approach; command is immediately usable even if annotation is skipped
- Explicit `mode` prop on `ExerciseCard` for pedagogy-critical overrides — some Foundation exercises must always be guided (learner's first encounter with a command); some Challenge exercises must never degrade to step-by-step
- Per-exercise opt-in gate (`annotated={true}`) during migration — prevents partially-annotated modules from showing empty annotation UI; remove after full coverage

**Defer (v2+):**
- Browser terminal / live command execution — explicitly deferred per PROJECT.md
- Auto-graded exercise responses — explicitly deferred per PROJECT.md
- Per-step difficulty overrides within one exercise — anti-feature per FEATURES.md; inconsistent scaffolding within one exercise breaks the learning model

### Architecture Approach

All new behavior is a component-layer addition — no new routes, no new API endpoints, no new lib utilities. The five files that do not change are confirmed from direct codebase inspection: `getLessonContent()` in `lib/mdx.ts`, `generateStaticParams()` in the lesson page, `LessonFrontmatter` type, `TerminalBlock`, `VerificationChecklist`, `Callout`, and `CodeBlock`.

**Major components:**
1. `AnnotatedCommand` (`components/content/AnnotatedCommand.tsx`, NEW) — renders command + collapsible per-token annotation panel; 'use client'; all data from MDX props; no context reads
2. `ChallengeReferenceSheet` (`components/content/ChallengeReferenceSheet.tsx`, NEW) — wraps `QuickReference` with challenge visual treatment; starts as server component; reuses `ReferenceSection`/`ReferenceItem` types
3. `ExerciseCard` (MODIFIED) — adds `mode?`, `challengePrompt?`, `challengeReference?` props; reads `preferredMode` from `ProgressContext`; three-tier mode resolution: explicit prop, then learner preference, then difficulty default
4. `ProgressProvider` (MODIFIED) — adds `preferredMode` / `setPreferredMode` to context; persists to `'learn-systems-preferences'` localStorage key (separate from progress state so a progress reset does not wipe mode preference)
5. `DifficultyToggle` (`components/lesson/DifficultyToggle.tsx`, NEW) — small 'use client' component; writes `preferredMode` via `useProgress()`; rendered by `LessonLayout` only when `frontmatter.difficulty === 'Challenge'`

**Build order (non-negotiable, derived from dependency analysis):** Step 1: context/types. Step 2: leaf components (no context reads). Step 3: ExerciseCard modification. Step 4: LessonLayout integration. Step 5: mdx-components.tsx registration. Step 6: content authoring.

### Critical Pitfalls

1. **ExerciseCard prop interface breakage** — Adding a required prop or changing the shape of the `steps` array item to include required fields creates TypeScript compile errors across all 52 existing MDX lesson files simultaneously. All new props must be strictly optional with safe fallback behavior. Run `next build` immediately after any interface change and treat compile errors as blocking before touching any MDX.

2. **Annotation co-location vs. parallel array misalignment** — Annotations must live inside the step object (`{ step, description, command?, annotations?: CommandAnnotation[] }`), not as a top-level `annotations` prop on `ExerciseCard` indexed by step number. A parallel top-level array breaks silently when steps are reordered or a new step is inserted — the annotation for step 4 appears under step 5's command with no error.

3. **MDX prop serialization failures** — Annotation description strings with unescaped quotes (`"`), backticks (`` ` ``), curly braces (`{}`), or angle brackets (`<>`) cause MDX parse errors that block the entire lesson from rendering. Decide the inline-vs-imported-data pattern before writing any annotation content. If inline annotation strings are used, restrict them to plain prose with no special characters. Run `next build` per module, not in batch.

4. **Annotation coverage inconsistency** — 22 Foundation lessons with ~200 command fields. If annotations are written for 8 lessons and the feature ships, learners see inconsistent experiences with no signal about whether missing annotations mean "complete" or "incomplete." Use a per-exercise opt-in gate (`annotated={true}`) so unannotated exercises show nothing new; complete one module fully before starting the next; do not remove the gate until full coverage is achieved.

5. **Challenge verification integrity** — `VerificationChecklist` is self-assessed (client-side state, resets on page refresh, no actual command verification). Challenge-mode verification items must specify exact runnable commands and expected output in the `hint` field, not vague accomplishment statements. Minimum 3 verification items per challenge exercise. This is a content policy decision that must be in the authoring template before any challenge content is written.

---

## Implications for Roadmap

Research is unanimous that all design decisions — interface contracts, annotation data structure, MDX prop pattern, challenge content policy, reference sheet scope rules, and difficulty source (ExerciseCard prop, not frontmatter) — must be locked in Phase 1 before any implementation begins. PITFALLS.md maps all eight critical pitfalls to Phase 1 prevention. None can be cheaply recovered after the schema is in use across 52 files.

### Phase 1: Design Lock — Interface Contracts, Schema, and Content Policy

**Rationale:** Eight critical pitfalls are explicitly classified as "Phase 1: design" prevention items. The annotation data structure, MDX prop serialization pattern, reference sheet content rules, challenge verification standards, and difficulty source must all be decided before any code or content is written. An audit of frontmatter-vs-ExerciseCard difficulty mismatches must also be completed here to know where the rendering logic's difficulty-source assumption holds and where it diverges.

**Delivers:** Locked `ExerciseCard` prop interface (all new props optional, no existing shape changes); `CommandAnnotation` TypeScript type; annotation style guide (flag format with leading dash, one-sentence description, max 120 chars, optional example); reference sheet content policy (max 15 items, no sequential ordering language, items do not name the solution); challenge verification standard (min 3 items, hints include runnable commands and expected output); audit of Foundation lesson command field count (~200 estimate confirmed or revised); list of all ExerciseCard/frontmatter difficulty mismatches.

**Addresses:** Per-flag annotation format (table stakes); challenge verification policy (table stakes); annotation schema definition.

**Avoids:** All eight critical pitfalls from PITFALLS.md — all are Phase 1 preventions.

### Phase 2: Component Implementation

**Rationale:** Architecture research mandates bottom-up build order based on explicit dependency analysis. Leaf components have no context reads and no dependencies on other new components. ExerciseCard modification depends on context types from Step 1 and the leaf components from Step 2. LessonLayout integration depends on the context being extended.

**Delivers:**
- `AnnotatedCommand` component (new, `components/content/`)
- `ChallengeReferenceSheet` component (new, `components/content/`)
- `ProgressProvider` extended with `preferredMode` / `setPreferredMode` (separate localStorage key `'learn-systems-preferences'`)
- `ExerciseCard` modified with mode-aware rendering branches and three-tier mode resolution
- `DifficultyToggle` client component (`components/lesson/`)
- `LessonLayout` updated to render `DifficultyToggle` gated on `frontmatter.difficulty === 'Challenge'`
- `mdx-components.tsx` updated to register `AnnotatedCommand` and `ChallengeReferenceSheet`
- `next.config.ts` updated to add `transformerNotationWordHighlight()` to `rehypePrettyCode` options

**Uses:** `@shikijs/transformers@4.0.2` (the one new npm install), `@base-ui/react` Tooltip (existing at v1.3.0), `QuickReference` (existing, unchanged).

**Implements:** Full architecture from ARCHITECTURE.md: Props-in-MDX pattern, Context-Driven Render Branching, and Explicit Mode Override for pedagogy requirements.

**Avoids:** Anti-patterns from ARCHITECTURE.md — reading lesson-level frontmatter difficulty inside ExerciseCard; annotating inside TerminalBlock; per-exercise toggle UI instead of global preference; building ChallengeReferenceSheet from scratch instead of wrapping QuickReference.

### Phase 3: Proof-of-Concept Content (One Complete Module)

**Rationale:** FEATURES.md explicitly defines the MVP as requiring at least one migrated example per difficulty tier before v1.1 ships. Migrating one complete module validates the annotation schema, MDX authoring DX, and component integration before committing to 22 Foundation lessons. The inline-vs-imported annotation data pattern must also be validated against the actual Next.js 16.2 + `@next/mdx` 3.1.1 configuration (a gap identified in confidence assessment).

**Delivers:** One complete module with Foundation annotations (all command fields annotated), Intermediate command suppression, and Challenge reference sheet with verified checklist items. Exercise template updated with authoring guide covering all three difficulty tiers. Per-exercise opt-in gate (`annotated={true}`) in place.

**Validates:** Annotation schema works end-to-end in the actual MDX pipeline. MDX prop serialization behavior confirmed. Component rendering correct for all three difficulty tiers simultaneously.

**Avoids:** Batch annotation discovery pitfall (MDX parse errors caught per-module, not in batch); annotation coverage inconsistency pitfall (per-exercise gate ensures only the annotated module shows annotation UI).

### Phase 4: Full Content Migration

**Rationale:** Once the component and schema are validated by Phase 3, the remaining 21 Foundation lessons, ~20 Intermediate lessons, and ~3 Challenge lessons can be migrated module by module. This is the highest-effort phase — ~200 command fields across Foundation lessons alone — and requires the style guide, schema, and per-exercise gate established in Phase 1 to maintain consistency.

**Delivers:** All Foundation lessons annotated (per-flag breakdowns co-located in step objects), all Intermediate lessons with commands suppressed, all Challenge lessons with reference sheets (max 15 items, no sequential language) and precise verification items (min 3 items, runnable command checks in hints). Full authoring guide in `_exercise-template.mdx`. Per-exercise gate removed once coverage is confirmed.

**Implements:** Module-by-module migration strategy from FEATURES.md — complete one module before starting the next; run `next build` after each module; style review pass per module to catch voice/format drift.

### Phase Ordering Rationale

- Phase 1 before everything: eight critical pitfalls are Phase 1 preventions; none can be cheaply recovered after the schema is in use across 52 files. The annotation co-location structure and MDX prop pattern are architectural — only fixable before content is written.
- Phase 2 before Phase 3: cannot validate annotation schema in content until the component exists to render it.
- Phase 3 before Phase 4: proof-of-concept validates schema, authoring DX, and MDX serialization behavior before committing to high-effort migration across the full corpus. Discovering a problem at Phase 3 is cheap; discovering it mid-Phase 4 requires reworking all migrated lessons.
- Phase 4 is internally parallelizable (module-by-module) but cannot start until Phase 2 is complete and Phase 3 validates the pattern.

### Research Flags

Phases with standard patterns (skip research-phase — all integration points verified against live codebase):
- **Phase 2 (component implementation):** `@base-ui/react` Tooltip API verified against base-ui.com. `rehype-pretty-code` `transformers` option verified against official docs. `ExerciseCard` interface and `mdx-components.tsx` registration pattern confirmed by direct codebase inspection. Build order derived from explicit dependency analysis. No additional research needed.
- **Phase 3 (proof-of-concept content):** Authoring pattern defined in Phase 1; component exists from Phase 2; no new unknowns.
- **Phase 4 (full content migration):** Pure execution of schema and style guide defined in Phase 1.

Phases that warrant a closer look during planning:
- **Phase 1 (design):** The frontmatter-vs-ExerciseCard difficulty mismatch audit may reveal more edge cases than the ~5-10 PITFALLS.md estimate. Run the grep before finalizing Phase 1 scope to avoid surprises during Phase 2. The exact Foundation command field count (~200 estimate) should also be confirmed to right-size Phase 4.

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All version checks performed against live `node_modules` (shiki 4.0.2, rehype-pretty-code 0.14.3, @base-ui/react 1.3.0 confirmed); `@shikijs/transformers` API verified against official shiki docs; Code Hike ruled out via official docs |
| Features | HIGH | Existing component set audited by direct inspection; instructional design rationale grounded in PMC 2022 scaffolding study and Sweller/Kalyuga worked-examples research (peer-reviewed); competitor patterns confirmed via official sources |
| Architecture | HIGH | All findings based on direct codebase inspection of every relevant file; build order derived from explicit dependency analysis; no external sources required; no inference |
| Pitfalls | HIGH | All pitfalls grounded in direct inspection of 52 MDX lesson files and 6 existing components; MDX parse behavior verified against official MDX docs; recovery strategies classified by cost |

**Overall confidence:** HIGH

### Gaps to Address

- **Frontmatter/ExerciseCard difficulty mismatch count:** PITFALLS.md estimates 5-10 mismatches but this has not been enumerated. Run a grep across all MDX files during Phase 1 planning to get the exact list before writing rendering logic that depends on ExerciseCard `difficulty` prop as the authoritative source.
- **Foundation command field exact count:** PITFALLS.md estimates ~200 command fields across 22 Foundation lessons. This is an estimate from lesson structure inspection, not an exact count. An exact count during Phase 1 planning surfaces whether Phase 4 needs to be split across multiple sessions.
- **MDX inline prop parse behavior with complex objects in this specific configuration:** The recommendation is to import annotation data from `.ts` files rather than write it inline in MDX. This pattern has not been tested against the specific Next.js 16.2 + `@next/mdx` 3.1.1 configuration. Validate the import pattern in Phase 3 (proof-of-concept) before committing it across 22 lessons in Phase 4.

---

## Sources

### Primary (HIGH confidence)

- Direct inspection of `components/content/ExerciseCard.tsx` — existing prop interface, Difficulty type usage, steps rendering pattern
- Direct inspection of `components/content/QuickReference.tsx` — ReferenceSection, ReferenceItem types, sections prop API
- Direct inspection of `components/progress/ProgressProvider.tsx` — ProgressContextValue shape, localStorage key pattern
- Direct inspection of `mdx-components.tsx` — component registration pattern for all existing content components
- Direct inspection of `node_modules/shiki/package.json` — shiki 4.0.2 confirmed installed
- Direct inspection of `node_modules/rehype-pretty-code/package.json` — 0.14.3 confirmed installed
- Direct inspection of `node_modules/@base-ui/react/package.json` — 1.3.0, `./tooltip` export confirmed
- `rehype-pretty.pages.dev` — `transformers: ShikiTransformer[]` option in rehype-pretty-code Options API
- `shiki.style/packages/transformers` — `@shikijs/transformers` 4.0.2; `transformerNotationWordHighlight` API; `[!code word:X]` notation
- `base-ui.com/react/components/tooltip` — `@base-ui/react` Tooltip component API (Provider, Root, Trigger, Positioner, Popup parts)
- `codehike.org/docs` — Code Hike v1 is a remark plugin replacing (not extending) rehype-pretty-code; ruled out as additive option
- PMC 2022 — "Fade-in scaffolding is better than fade-out for novice programmers" — direct justification for Foundation → Intermediate → Challenge tier design
- Sweller 1994 / Kalyuga 2007 — worked examples appropriate for novices; problem-solving for intermediate learners — direct justification for annotation on Foundation, suppression on Intermediate
- OverTheWire Bandit — goal-only challenge model (no steps, scenario + objective only)

### Secondary (MEDIUM confidence)

- HTB Guided Mode announcement — guided vs. adventure mode distinction; maps to Foundation vs. Challenge tier
- HTB Academy FAQ — module structure: theory + checkpoints + skills assessments
- KodeKloud hands-on lab format — embedded challenge with scoped command reference
- explainshell.com — spatial per-token annotation UX pattern (site inspected; full UI not rendered via fetch)
- tldr-pages style guide — example-first command explanation pattern; annotation format reference
- MDX JSX expression parsing edge cases — string literal restrictions in JSX attribute values

---

*Research completed: 2026-03-20*
*Ready for roadmap: yes*
