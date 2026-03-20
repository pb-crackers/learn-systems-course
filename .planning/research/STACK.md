# Stack Research

**Domain:** Interactive DevOps Course — v1.1 Command Pedagogy additions to existing Next.js app
**Researched:** 2026-03-20
**Confidence:** HIGH (all library versions verified against npm and official docs; integration points verified against existing codebase)

---

## Context: What Already Exists (Do Not Re-Research)

The app runs Next.js 16.2, React 19, Tailwind v4, shadcn/ui, MDX via `@next/mdx` 3.1.1 with `rehype-pretty-code` 0.14.3 and `shiki` 4.0.2. The component library includes `ExerciseCard`, `CodeBlock`, `TerminalBlock`, `QuickReference`, `Callout`, and `VerificationChecklist`, all registered in `mdx-components.tsx`. The `@base-ui/react` 1.3.0 package is already installed and provides `Tooltip` and `Popover` primitives. No `@radix-ui/react-*` primitives are installed separately — the project uses `@base-ui/react` for accessible primitives.

This STACK.md covers only what is **new or changed** for v1.1.

---

## Recommended Stack (New/Changed Only)

### Core New Additions

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| `@shikijs/transformers` | 4.0.2 | Notation-based line and word highlighting in code blocks | Ships at the same version as the already-installed `shiki` 4.0.2, so no version conflict; `rehype-pretty-code` has a first-class `transformers: []` option that accepts `ShikiTransformer[]` from this package; enables `[!code word:X]` inline word highlighting needed for flag annotation |
| `AnnotatedCommand` component (new, zero deps) | n/a | Render a CLI command with per-token flag/argument tooltips | Built on `@base-ui/react` Tooltip (already installed); no new runtime dependency; renders server-side without `use client` for the layout, tooltip triggers are client-side; integrates into MDX via `mdx-components.tsx` same as existing components |
| `ChallengeCard` component (new, zero deps) | n/a | Goal-based exercise with collapsible command reference sheet | Extends `ExerciseCard` pattern; adds `mode="challenge"` rendering path that shows English goal description and a `QuickReference` panel instead of step-by-step commands; uses existing `Difficulty` type and existing `QuickReference` component |

### No New Runtime Libraries Required

The three v1.1 features (annotated command blocks, challenge-mode exercises, difficulty-aware rendering) can be fully implemented with:

1. `@shikijs/transformers` — the only new npm package
2. Two new React components (`AnnotatedCommand`, `ChallengeCard`) built on already-installed primitives
3. Modifications to `ExerciseCard` to support `difficulty`-driven rendering branches

---

## Feature-to-Stack Mapping

### Feature 1: Annotated Command Blocks

**Approach: Custom `AnnotatedCommand` React component (not a code fence)**

The approach is a purpose-built JSX component, not a rehype/shiki extension. Here is why:

- Annotating individual flags (e.g., `-aG` in `usermod -aG sudo alice`) requires associating free-text explanations with arbitrary token substrings. Shiki transformers can highlight words but cannot attach rich tooltip content — they only apply CSS classes.
- Code Hike v1 can do per-token annotations but it is a remark plugin that **replaces** rehype-pretty-code as the syntax highlighter, not a companion to it. Replacing rehype-pretty-code would require rewriting all 56 lessons and rebuilding the `CodeBlock` pipe. This is out of scope.
- `@base-ui/react` Tooltip (already installed at v1.3.0) provides the accessible popup behavior needed. It handles keyboard focus, delay management via `Tooltip.Provider`, and positioning via `Tooltip.Positioner` — no new code needed for those concerns.

**Component API (design target for implementation):**

```typescript
interface CommandToken {
  text: string        // The literal text of this token (e.g. "-aG")
  annotation?: string // Explanation shown in tooltip (e.g. "append to groups without removing existing ones")
}

interface AnnotatedCommandProps {
  tokens: CommandToken[]
  className?: string
}
```

Tokens without `annotation` render as plain monospace text. Tokens with `annotation` render as underlined/highlighted spans with a `@base-ui/react` Tooltip. The component registers in `mdx-components.tsx` and is called from MDX as `<AnnotatedCommand tokens={[...]} />`.

**`@shikijs/transformers` role (supplementary):**

The `transformers` option in `rehype-pretty-code` accepts `ShikiTransformer[]`. Adding `transformerNotationWordHighlight()` from `@shikijs/transformers` enables `[!code word:X]` syntax in regular fenced code blocks. This is useful for highlighting a flag or keyword in a multi-line bash block without needing the full `AnnotatedCommand` component. It is a lightweight addition that augments existing `CodeBlock` rendering.

**Integration point:** `next.config.ts` — add `transformers` array to the existing `rehypePrettyCode` options object.

### Feature 2: Challenge-Mode Exercises

**Approach: New `ChallengeCard` component**

`ChallengeCard` follows the same collapsible card pattern as `ExerciseCard` but renders a goal description and a reference sheet instead of numbered steps with commands. It uses:

- Existing `QuickReference` component for the reference sheet (already registered in MDX)
- Existing `Difficulty` type from `types/content.ts`
- Existing `shadcn/ui` styling tokens (border, muted, card)
- `@base-ui/react` Collapsible (already installed at v1.3.0) for the expandable reference section, or the same `useState` pattern as `ExerciseCard`

No new library required.

**Component API (design target):**

```typescript
interface ChallengeCardProps {
  title: string
  scenario: string
  difficulty: 'Intermediate' | 'Challenge'  // Foundation exercises don't use ChallengeCard
  goal: string                               // English description: "Configure nginx to..."
  hints?: string[]                           // Optional hints revealed on demand
  referenceSheet: ReferenceSection[]         // Passed to <QuickReference sections={...} />
  children?: React.ReactNode                 // Verification section
}
```

### Feature 3: Difficulty-Aware Rendering in ExerciseCard

**Approach: Conditional rendering within existing `ExerciseCard`**

`ExerciseCard` already receives `difficulty: Difficulty` as a required prop. The rendering branch is:

- `difficulty === 'Foundation'` → current behavior (numbered steps with optional `command` per step, annotated via `AnnotatedCommand` if needed)
- `difficulty === 'Intermediate' | 'Challenge'` → steps list is replaced by a goal statement; an expandable reference sheet appears instead of copy-paste commands

This avoids introducing a second card component and keeps the MDX authoring API consistent. The `steps` prop becomes optional for non-Foundation exercises; a new `goal` prop and `referenceSheet` prop are added.

**Alternative considered:** Two separate components (`ExerciseCard` + `ChallengeCard`). This is cleaner for authors but requires updating all 56 existing lessons to remain consistent. A single component with a rendering branch is preferred because existing Foundation exercises require zero MDX changes.

---

## Installation

```bash
# The one new npm package
npm install @shikijs/transformers@4.0.2
```

No other installation steps. `AnnotatedCommand` and `ChallengeCard` are authored components, not npm packages.

---

## What NOT to Add

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Code Hike (`codehike`) | Replaces rehype-pretty-code as the syntax pipeline — not a companion. Adding it would require removing `rehype-pretty-code` and rewriting the `CodeBlock` component and all 56 lesson code fences. The migration cost is out of scope for v1.1. | `@shikijs/transformers` for in-fence highlighting; `AnnotatedCommand` component for rich per-token explanations |
| `@radix-ui/react-tooltip` | Not installed; `@base-ui/react` Tooltip is already installed at v1.3.0 and provides equivalent functionality | `@base-ui/react` Tooltip (already available) |
| `framer-motion` | Animation for expand/collapse is handled by `tailwind-merge` utility classes (`transition-all`, `overflow-hidden`) already in the bundle; adding a motion library is unnecessary complexity for simple accordion behavior | CSS transitions via Tailwind |
| `react-syntax-highlighter` | Runtime syntax highlighting; the project uses build-time highlighting via `rehype-pretty-code` + `shiki` which is faster and produces no client JS | `rehype-pretty-code` (already configured) |
| `tippy.js` or `floating-ui` (direct) | `@base-ui/react` internally uses `@floating-ui/react` and wraps it in an accessible component API. Using floating-ui directly would duplicate that work. | `@base-ui/react` Tooltip / Popover |
| Any new state management library | Progress tracking uses `localStorage` via existing hooks; annotation state is component-local (`useState`); no global state needed | `useState` in component |

---

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Custom `AnnotatedCommand` component | Code Hike `codehike` v1 | Only if you are starting the project fresh or willing to replace the entire rehype-pretty-code pipeline. Code Hike's annotation system is powerful but not additive to an existing rehype-pretty-code setup. |
| `@shikijs/transformers` word highlight | rehype-pretty-code's native `/word/` meta string | The native meta string approach works for simple character highlighting but produces only CSS classes. Use the native approach for simple emphasis; use `@shikijs/transformers` for `[!code word:X]` inline notation which is more readable in multi-line blocks. |
| Difficulty branch inside `ExerciseCard` | Separate `ChallengeCard` component | Use a separate component if lesson authors want explicit MDX API clarity (no shared props) and are willing to audit all 56 existing lessons to decide which card type to use. |

---

## Integration Points in Existing Code

| File | Change Required | Why |
|------|----------------|-----|
| `next.config.ts` | Add `transformers: [transformerNotationWordHighlight()]` to `rehypePrettyCode` options | Enables `[!code word:X]` in code fences |
| `components/content/ExerciseCard.tsx` | Add `goal?`, `referenceSheet?` props; add difficulty-conditional render branch | Core of difficulty-aware feature |
| `components/content/AnnotatedCommand.tsx` | New file | Implements per-token tooltip component |
| `mdx-components.tsx` | Add `AnnotatedCommand` to the exports map | Makes `<AnnotatedCommand />` available in all MDX files |
| `types/content.ts` | No change required | `Difficulty` type already covers all three values |

---

## Version Compatibility

| Package | Version | Compatible With | Notes |
|---------|---------|-----------------|-------|
| `@shikijs/transformers` | 4.0.2 | `shiki` 4.0.2 (installed), `rehype-pretty-code` 0.14.3 | Must match `shiki` major version; 4.x aligns with installed shiki 4.0.2 |
| `@base-ui/react` Tooltip | 1.3.0 (installed) | React 19.2.4, Next.js 16.2 | Already verified — currently in use via `@base-ui/react` dialog; Tooltip subpackage follows same peer dep |
| `rehype-pretty-code` | 0.14.3 (installed) | `transformers: ShikiTransformer[]` option available since 0.13.x | No upgrade needed; `transformers` option is documented and stable |

---

## Sources

- `rehype-pretty.pages.dev` — Verified `transformers: ShikiTransformer[]` option in rehype-pretty-code Options API — HIGH confidence
- `shiki.style/packages/transformers` — Verified `@shikijs/transformers` 4.0.2 current version; `transformerNotationWordHighlight` API; `[!code word:X]` notation — HIGH confidence
- `base-ui.com/react/components/tooltip` — Verified `@base-ui/react` Tooltip component API (Provider, Root, Trigger, Positioner, Popup parts); accessibility constraints — HIGH confidence
- `codehike.org/docs` — Verified Code Hike v1 is a remark plugin replacing (not extending) rehype-pretty-code; ruled out as additive option — HIGH confidence
- Direct inspection of `/node_modules/shiki/package.json` — shiki 4.0.2 confirmed installed — HIGH confidence
- Direct inspection of `/node_modules/rehype-pretty-code/package.json` — 0.14.3 confirmed installed — HIGH confidence
- Direct inspection of `/node_modules/@base-ui/react/package.json` — 1.3.0, `./tooltip` export confirmed — HIGH confidence
- Direct inspection of `components/content/ExerciseCard.tsx` — existing `Difficulty` type usage, `steps` prop API confirmed — HIGH confidence
- Direct inspection of `mdx-components.tsx` — existing component registration pattern confirmed — HIGH confidence

---

*Stack research for: v1.1 Command Pedagogy — annotated command blocks, challenge-mode exercises, difficulty-aware rendering*
*Researched: 2026-03-20*
