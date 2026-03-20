# Architecture Research

**Domain:** MDX + React component architecture — command pedagogy features (v1.1 milestone)
**Researched:** 2026-03-20
**Confidence:** HIGH — based on direct codebase inspection of all relevant files, no external dependencies involved

---

## Context: What Exists

This is a subsequent-milestone document. All findings are based on inspecting the live codebase,
not prior-milestone research. The existing system is fully understood.

### Existing Component Inventory

| Component | File | What It Does |
|-----------|------|--------------|
| `CodeBlock` | `components/content/CodeBlock.tsx` | Wraps `<pre>` from rehype-pretty-code; shows language/filename tab, copy button |
| `ExerciseCard` | `components/content/ExerciseCard.tsx` | Collapsible card with difficulty badge; steps have optional `command` string |
| `TerminalBlock` | `components/content/TerminalBlock.tsx` | Simulated terminal with command/output/comment line types |
| `QuickReference` | `components/content/QuickReference.tsx` | Structured or freeform command reference table; exports `ReferenceSection`, `ReferenceItem` types |
| `VerificationChecklist` | `components/content/VerificationChecklist.tsx` | Interactive self-check list with optional hints |
| `Callout` | `components/content/Callout.tsx` | Tip/warning/info callout box |
| `LessonLayout` | `components/lesson/LessonLayout.tsx` | Wraps every lesson; renders frontmatter header with difficulty badge, ToC aside |
| `ProgressProvider` | `components/progress/ProgressProvider.tsx` | React context + localStorage for lesson/exercise completion; uses `useLocalStorage` SSR-safe hook |

### Existing Type Contracts

```typescript
// types/content.ts
export type Difficulty = 'Foundation' | 'Intermediate' | 'Challenge'

export interface LessonFrontmatter {
  difficulty: Difficulty   // per-lesson, from MDX frontmatter
  // ... title, description, moduleSlug, lessonSlug, order, etc.
}

// types/progress.ts
export interface ProgressState {
  lessons: Record<LessonId, LessonProgress>
  version: number
}
// PROGRESS_STORAGE_KEY = 'learn-systems-progress'
```

### Existing Data Flow

```
content/modules/[module]/[lesson].mdx
        | (import at build time via @next/mdx)
        v
app/modules/[moduleSlug]/[lessonSlug]/page.tsx
        | getLessonContent() — dynamic import + gray-matter for frontmatter
        v
LessonLayout (receives frontmatter.difficulty)
        | renders children
        v
<MDXContent /> — JSX routed through mdx-components.tsx useMDXComponents()
        |
        v
components/content/* (CodeBlock, ExerciseCard, TerminalBlock, etc.)
```

---

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         MDX Lesson Content                               │
│  <AnnotatedCommand command="..." tokens={[...]} />         (NEW)        │
│  <ExerciseCard difficulty="Foundation" mode="guided" .../>  (MODIFIED)  │
│  <ExerciseCard difficulty="Challenge" challengePrompt="..." .../>       │
│  <ChallengeReferenceSheet sections={[...]} />              (NEW)        │
└───────────────────────────────┬─────────────────────────────────────────┘
                                | React component tree (via mdx-components.tsx)
┌───────────────────────────────v─────────────────────────────────────────┐
│                     components/content/                                  │
│  ┌────────────────────┐  ┌────────────────────┐  ┌──────────────────┐  │
│  │  AnnotatedCommand  │  │  ExerciseCard       │  │ ChallengeRef-    │  │
│  │  (NEW)             │  │  (MODIFIED)         │  │ Sheet (NEW)      │  │
│  │                    │  │                     │  │                  │  │
│  │  Renders command   │  │  Reads explicit     │  │ Styled wrapper   │  │
│  │  + per-flag        │  │  mode prop OR       │  │ over existing    │  │
│  │  annotations in    │  │  ProgressContext     │  │ QuickReference   │  │
│  │  expandable panel  │  │  preferredMode;     │  │                  │  │
│  │                    │  │  gates render path  │  │                  │  │
│  └────────────────────┘  └─────────┬───────────┘  └──────────────────┘  │
└─────────────────────────────────────┼───────────────────────────────────┘
                                      | context read
┌─────────────────────────────────────v───────────────────────────────────┐
│                     components/progress/ProgressProvider.tsx             │
│                          (MODIFIED — add preferredMode)                  │
│                                                                          │
│  preferredMode: 'guided' | 'challenge' | null   (localStorage)          │
│  setPreferredMode: (mode: 'guided' | 'challenge' | null) => void        │
└─────────────────────────────────────────────────────────────────────────┘
                                      |
┌─────────────────────────────────────v───────────────────────────────────┐
│                     components/lesson/LessonLayout.tsx                   │
│                          (MODIFIED — add DifficultyToggle)               │
│                                                                          │
│  Reads frontmatter.difficulty to gate toggle display.                   │
│  Calls setPreferredMode via ProgressContext.                             │
└─────────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Status |
|-----------|----------------|--------|
| `AnnotatedCommand` | Render a single CLI command with per-token annotations in an expandable panel | NEW |
| `ChallengeReferenceSheet` | Always-visible command reference for challenge-mode exercises | NEW |
| `ExerciseCard` | Add mode-aware render branching; guided path vs challenge path | MODIFIED |
| `ProgressProvider` | Add `preferredMode` preference alongside existing progress state | MODIFIED |
| `LessonLayout` | Add `DifficultyToggle` UI in lesson header when lesson supports challenge mode | MODIFIED |
| `mdx-components.tsx` | Register two new components so MDX can use them without explicit imports | MODIFIED |

---

## Recommended Project Structure (new files only)

```
components/
└── content/
    ├── AnnotatedCommand.tsx          # NEW — per-flag command annotation component
    └── ChallengeReferenceSheet.tsx   # NEW — challenge mode command reference panel

hooks/
└── useDifficultyPreference.ts        # NEW (optional) — thin hook wrapper for clean DX
```

No new routes, no new API endpoints, no new lib utilities. This is entirely a component-layer addition.

### Structure Rationale

- **`components/content/`:** All new components are content primitives used in MDX. They belong with existing content components, not in a new directory. The existing content component set has clear precedent for this organization.
- **`hooks/useDifficultyPreference.ts`:** Optional extraction. If multiple components read `preferredMode` from context, a named hook is cleaner than calling `useProgress()` and destructuring everywhere.

---

## Architectural Patterns

### Pattern 1: Props-in-MDX for Content Data

**What:** All annotation data and challenge prompts live entirely in MDX JSX props. No external JSON, no fetched data, no content database.

**When to use:** Always, for both `AnnotatedCommand` and `ExerciseCard` challenge props. The annotation belongs adjacent to the command it describes in the same file.

**Trade-offs:** Verbose MDX authoring. Correct trade-off because: annotations live with their commands (no sync problem), works with the static build, no runtime fetch, author intent is explicit.

**Example:**
```mdx
<AnnotatedCommand
  command="find /var/log -name '*.log' -mtime +7 -delete"
  tokens={[
    { token: "-name '*.log'", annotation: "Filter by filename pattern — glob syntax, quoted to prevent shell expansion before find sees it" },
    { token: "-mtime +7", annotation: "Modified more than 7 days ago. + means more than, - means less than, no prefix means exactly N days" },
    { token: "-delete", annotation: "Primary action — deletes matched files. Must come after all filters or it runs on everything" }
  ]}
/>
```

### Pattern 2: Context-Driven Render Branching

**What:** `ExerciseCard` reads `preferredMode` from `ProgressContext` to choose between guided and challenge render paths. The MDX author does not decide at read-time — the learner's preference does.

**When to use:** Any component that must respond to a persistent learner preference.

**Trade-offs:** ExerciseCard becomes a context consumer. It already is ('use client' directive exists). The context re-render touches every ExerciseCard on the page when the preference changes. Acceptable: at most 3-5 exercises per lesson page, React reconciliation handles this with no perceptible cost.

**Example:**
```typescript
// Inside ExerciseCard
const { preferredMode } = useProgress()
const effectiveMode = mode ?? preferredMode ?? difficultyDefault(difficulty)
```

### Pattern 3: Explicit Mode Override for Pedagogy Requirements

**What:** The `mode` prop on `ExerciseCard` lets the MDX author pin a specific render mode regardless of the learner's global preference. Used for exercises where pedagogy absolutely requires one path.

**When to use:** Foundation exercises that must always be annotated/guided (learner's first encounter with a command). Challenge capstone exercises that must never degrade to step-by-step.

**Example:**
```mdx
{/* Always guided — first encounter with chmod, annotations are essential */}
<ExerciseCard mode="guided" difficulty="Foundation" ... />

{/* Always challenge — final module capstone */}
<ExerciseCard mode="challenge" difficulty="Challenge" ... />
```

---

## New Component Specifications

### `AnnotatedCommand`

**File:** `components/content/AnnotatedCommand.tsx`

**Props:**
```typescript
interface CommandToken {
  token: string          // exact substring from command, e.g. "-R", "--format=json"
  annotation: string     // educational explanation of this token
  type?: 'flag' | 'argument' | 'subcommand' | 'option-value'
}

interface AnnotatedCommandProps {
  command: string         // full command string, displayed verbatim
  tokens: CommandToken[]  // tokens to annotate (can be a subset)
  language?: string       // for display hint, defaults to 'bash'
  copyable?: boolean      // show copy button, default true
}
```

**Rendering contract:**
- Base command always renders in full, in monospace, with copy button
- Annotated tokens are visually highlighted in the command display (underline or subtle color)
- Annotations panel below the command, collapsed by default
- Each annotation row links visually to its token
- Collapsed state is correct default: advanced learners can skip; Foundation learners expand

**'use client' required:** Yes — interactive collapse/expand state.

### `ChallengeReferenceSheet`

**File:** `components/content/ChallengeReferenceSheet.tsx`

**Props:** Extends `QuickReferenceProps` from the existing QuickReference component:
```typescript
interface ChallengeReferenceSheetProps extends QuickReferenceProps {
  collapsible?: boolean  // default false — always visible during a challenge
}
```

**Rendering contract:**
- Thin wrapper over existing `QuickReference` with distinct visual treatment: different border accent color, "Command Reference" header label, slightly elevated bg to signal "this is your toolkit"
- Reuses `ReferenceSection` and `ReferenceItem` types already exported from `QuickReference.tsx`
- `collapsible=false` (default): never hidden, always visible as the learner works
- No separate state management needed

**'use client' required:** Only if `collapsible=true` is implemented. Start with server component; add 'use client' if collapse behavior is added later.

### `ExerciseCard` Additions

**New props:**
```typescript
interface ExerciseCardProps {
  // existing props unchanged — no breaking changes
  title: string
  scenario: string
  difficulty: Difficulty
  objective: string
  steps: ExerciseStep[]
  children?: React.ReactNode
  // NEW:
  mode?: 'guided' | 'challenge'          // explicit author override
  challengePrompt?: string               // English goal description for challenge mode
  challengeReference?: ReferenceSection[] // commands available in challenge mode
}
```

**Mode resolution inside ExerciseCard:**
```
1. explicit `mode` prop — beats everything (author override)
2. ProgressContext.preferredMode (learner's global preference)
3. difficulty default:
     'Foundation'    -> 'guided'
     'Intermediate'  -> 'guided'
     'Challenge'     -> 'challenge'
```

**Guided render path:** Existing behavior. Steps list unchanged. If a step's command is in an `AnnotatedCommand` placed as children, it renders there; plain `step.command` strings continue to render as inline code.

**Challenge render path (new):** Shows `challengePrompt` paragraph, renders `ChallengeReferenceSheet` if `challengeReference` is provided, renders `children` (which includes `VerificationChecklist`). Hides the numbered step list.

### `ProgressProvider` Additions

**Context value additions:**
```typescript
interface ProgressContextValue {
  // existing fields unchanged
  progress: ProgressState
  isHydrated: boolean
  markLessonComplete: (lessonId: LessonId) => void
  markExerciseComplete: (lessonId: LessonId, exerciseId: string) => void
  resetProgress: () => void
  // NEW:
  preferredMode: 'guided' | 'challenge' | null
  setPreferredMode: (mode: 'guided' | 'challenge' | null) => void
}
```

**Storage:** Use a separate localStorage key `'learn-systems-preferences'` rather than extending `ProgressState`. Mode preference is a UI setting, not progress data. Keeping them in separate keys means a progress reset does not wipe the learner's mode preference, and the storage shapes stay cohesive.

### `LessonLayout` Additions

**What changes:** Render a difficulty toggle control in the lesson metadata row when the lesson supports challenge mode.

**Gate condition:** Render the toggle only when `frontmatter.difficulty === 'Challenge'`. This is a simple heuristic: Challenge-difficulty lessons are the ones where the challenge render path is meaningful. Foundation and Intermediate lessons always show guided.

**Toggle placement:** In the existing metadata row (same line as difficulty badge and estimated time), after the difficulty badge. A compact two-option control: `Guided | Challenge` with active option highlighted.

**Wire-up:** Toggle calls `setPreferredMode` from `useProgress()`. The toggle is a client component ('use client'). Extract it as a small `DifficultyToggle.tsx` component in `components/lesson/` to keep LessonLayout server-friendly.

---

## Data Flow

### Annotated Command Rendering

```
MDX author writes <AnnotatedCommand command="..." tokens={[...]} />
        | mdx-components.tsx maps JSX element to AnnotatedCommand component
        v
AnnotatedCommand renders:
  - Full command string in monospace (copyable)
  - Highlighted tokens in command display
  - Collapsible annotation panel (collapsed by default)
  (no external data source — all data is in MDX props, static at build time)
```

### Challenge Mode Toggle

```
Learner clicks "Challenge" in DifficultyToggle (in LessonLayout header)
        |
        v
DifficultyToggle calls setPreferredMode('challenge') via useProgress()
        |
        v
ProgressProvider writes 'challenge' to localStorage key 'learn-systems-preferences'
        | (React context re-render propagates to all consumers)
        v
Every ExerciseCard on the page re-reads context
        | resolves effectiveMode via fallback chain
        v
Cards with challengePrompt + effective challenge mode -> render challenge UI
Cards without challengePrompt -> remain in guided mode (graceful fallback)
Foundation cards with explicit mode="guided" -> unaffected by toggle
```

### Exercise Card Mode Resolution

```
ExerciseCard renders:
  effectiveMode = mode (explicit prop)
               ?? context.preferredMode (learner preference)
               ?? (difficulty === 'Challenge' ? 'challenge' : 'guided')

  effectiveMode === 'guided':
    render numbered steps list (existing)
    step.command -> inline code block (existing)
    children -> VerificationChecklist etc. (existing)

  effectiveMode === 'challenge':
    render challengePrompt paragraph
    if challengeReference -> render <ChallengeReferenceSheet sections={challengeReference} />
    render children (VerificationChecklist, etc.)
    hide step list
```

---

## Integration Points

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| MDX content → `AnnotatedCommand` | JSX props in MDX body | All annotation data is static at build time; no runtime fetch |
| MDX content → `ExerciseCard` | JSX props in MDX body | `challengePrompt` and `challengeReference` are new optional props; existing MDX files need no changes |
| `ExerciseCard` → `ProgressContext` | React context read via `useProgress()` | ExerciseCard already 'use client'; adding a context read is zero friction |
| `DifficultyToggle` → `ProgressContext` | React context write via `setPreferredMode` | New client component in `components/lesson/`; thin — just a toggle UI |
| `ChallengeReferenceSheet` → `QuickReference` | Composition — wraps QuickReference | Reuse `ReferenceSection` and `ReferenceItem` types already exported from QuickReference.tsx |
| `LessonLayout` → `DifficultyToggle` | Renders DifficultyToggle conditionally on frontmatter.difficulty | LessonLayout stays server-friendly; DifficultyToggle is the only client piece added |

### What Does NOT Change

These are confirmed no-touch from code inspection:

- `getLessonContent()` in `lib/mdx.ts` — no change; frontmatter already has `difficulty`
- `generateStaticParams()` in lesson page — no change
- `LessonFrontmatter` type in `types/content.ts` — no change
- `ProgressState` shape in `types/progress.ts` — mode preference stored in a separate key
- `TerminalBlock` — no change; used for expected output display, not exercises
- `QuickReference` — no change to existing component; ChallengeReferenceSheet wraps it
- `VerificationChecklist` — no change; still used as ExerciseCard children in both render paths
- `Callout` — no change
- `CodeBlock` — no change; AnnotatedCommand is a separate primitive, not a CodeBlock variant

---

## Anti-Patterns

### Anti-Pattern 1: Reading Lesson-Level Difficulty Inside ExerciseCard

**What people do:** Pass `frontmatter.difficulty` down through props or context into ExerciseCard and use it to determine mode.

**Why it's wrong:** A lesson has one difficulty in frontmatter but may contain exercises of multiple effective difficulties. A Foundation lesson can include a bonus Challenge exercise. The ExerciseCard's own `difficulty` prop is the correct signal, not the lesson-level field.

**Do this instead:** Use the card's `difficulty` prop for the default fallback, and `ProgressContext.preferredMode` for the learner override. The lesson-level frontmatter difficulty only controls whether the DifficultyToggle renders in the header.

### Anti-Pattern 2: Annotating Inside TerminalBlock

**What people do:** Add annotation metadata to TerminalBlock's line types.

**Why it's wrong:** TerminalBlock shows what you would see in a real terminal session — command + output sequences. Annotations are pedagogical metadata. Mixing them creates a component with two jobs and makes neither work well.

**Do this instead:** Use `AnnotatedCommand` for a single command with educational breakdown. Use `TerminalBlock` for showing a session with multiple commands and their expected output. These are intentionally distinct primitives.

### Anti-Pattern 3: Per-Lesson or Per-Exercise Toggle UI Instead of Global Preference

**What people do:** Put a small toggle on each exercise card, or in a per-lesson route.

**Why it's wrong:**
- Per-exercise toggle: clutters every card with mode-switch UI; learner has to set it N times per lesson.
- Per-lesson URL query string (`?mode=challenge`): creates shareable URLs with mode baked in, breaks back-button expectation, requires query-param parsing on every render.

**Do this instead:** Global preference in `ProgressProvider`, stored in localStorage. Set once, affects all exercises on all pages. Consistent with how the app handles all other persistent state.

### Anti-Pattern 4: Building ChallengeReferenceSheet from Scratch

**What people do:** Write ChallengeReferenceSheet with its own table rendering.

**Why it's wrong:** `QuickReference` already renders a well-styled, tested command reference table. Duplicating the rendering logic creates two components to maintain for the same presentation.

**Do this instead:** `ChallengeReferenceSheet` wraps `QuickReference` and applies distinct visual treatment (border accent, header label). Reuse `ReferenceSection` and `ReferenceItem` types already exported from `QuickReference.tsx`.

---

## Build Order

Dependencies determine order. Build bottom-up.

**Step 1 — Type and context contracts (no component dependencies)**
- Extend `ProgressContextValue` with `preferredMode` and `setPreferredMode`
- Extend `ProgressProvider` with localStorage persistence for mode preference (separate key)

**Step 2 — Leaf components (no context reads, no dependencies on new components)**
- Build `AnnotatedCommand` — standalone, all data from props
- Build `ChallengeReferenceSheet` — wraps existing `QuickReference`, no context reads

**Step 3 — ExerciseCard modification (depends on Steps 1 and 2)**
- Add `mode`, `challengePrompt`, `challengeReference` props
- Add `useProgress()` context read for `preferredMode`
- Add mode resolution logic and render branching

**Step 4 — LessonLayout integration (depends on Step 1)**
- Build `DifficultyToggle` client component (reads and writes `preferredMode`)
- Add DifficultyToggle to LessonLayout header, gated on `frontmatter.difficulty === 'Challenge'`

**Step 5 — Registration**
- Register `AnnotatedCommand` and `ChallengeReferenceSheet` in `mdx-components.tsx`

**Step 6 — Content authoring**
- Add `<AnnotatedCommand>` to Foundation exercises across all 8 modules
- Add `challengePrompt` and `challengeReference` to Challenge difficulty exercises
- No changes needed to existing MDX for Intermediate exercises (graceful fallback)

---

## Scaling Considerations

This is a local single-learner app. The relevant scaling axis is content volume — 56 lessons across 8 modules.

| Concern | Reality | Approach |
|---------|---------|----------|
| 56 lessons need annotation | All content is static MDX | Add AnnotatedCommand incrementally per lesson; no migration required on unmodified MDX |
| Context re-render on mode switch | 3-5 ExerciseCards per lesson page max | No optimization needed; React reconciliation handles this trivially |
| localStorage key management | Two keys currently exist | Add `'learn-systems-preferences'` as third key, isolated from progress state |
| MDX authoring verbosity | AnnotatedCommand props are detailed | Acceptable tradeoff — annotations are editorial content, not boilerplate |

---

## Sources

All findings are HIGH confidence — based on direct codebase inspection (2026-03-20):

- `components/content/CodeBlock.tsx`
- `components/content/ExerciseCard.tsx`
- `components/content/TerminalBlock.tsx`
- `components/content/QuickReference.tsx`
- `components/content/VerificationChecklist.tsx`
- `components/lesson/LessonLayout.tsx`
- `components/progress/ProgressProvider.tsx`
- `hooks/useLocalStorage.ts`
- `hooks/useProgress.ts`
- `types/content.ts`
- `types/progress.ts`
- `mdx-components.tsx`
- `app/modules/[moduleSlug]/[lessonSlug]/page.tsx`
- `lib/mdx.ts`
- `content/modules/01-linux-fundamentals/04-file-permissions.mdx` (representative lesson)
- `.planning/PROJECT.md`

---

*Architecture research for: command pedagogy features (v1.1 milestone)*
*Researched: 2026-03-20*
