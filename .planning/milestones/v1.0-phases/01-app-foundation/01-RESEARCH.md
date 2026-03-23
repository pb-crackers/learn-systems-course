# Phase 1: App Foundation - Research

**Researched:** 2026-03-18
**Domain:** Next.js 16 App Router + Tailwind CSS v4 + shadcn/ui + MDX content pipeline
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Next.js App Router + TypeScript + Tailwind CSS + shadcn/ui + 21st.dev components
- Dark-first terminal aesthetic — dark mode is the default, light mode available
- Accent colors per module category (Linux = green, Networking = blue, Docker = cyan)
- Typography: Inter for prose, JetBrains Mono (or similar) for code/terminal blocks
- MDX for lesson content with syntax highlighting
- localStorage for progress tracking — no backend
- Collapsible sidebar with module sections; each module expands to show its lessons
- Checkmark icons with completion percentage per module in the sidebar
- Numbered modules with locked/unlocked visual state based on prerequisite completion
- Mobile: slide-out drawer with hamburger menu
- Breadcrumb navigation on lesson pages (Module > Lesson)
- Sticky sidebar on desktop, scrollable independently from content
- Section ordering: Overview → How It Works → Exercise → Verification → Quick Reference
- Prerequisites displayed as a banner at top of lesson with linked prerequisite lessons
- Exercise sections as expandable cards with clear objectives, numbered steps, copy-paste command blocks
- Scroll progress bar at top of lesson + estimated reading time
- "Mark as complete" button at the bottom of each lesson
- Table of contents for long lessons (auto-generated from headings)
- Code blocks: syntax highlighting + line numbers + copy button + filename/language header
- Terminal mockup component showing expected command/output pairs
- Exercise verification: checklist display with pass/fail indicators and expandable hints
- Mermaid diagrams rendered inline
- Callout components for tips, warnings, and "under the hood" deep dives
- Client-side full-text search across all lesson content
- Search results show lesson title, module, and matching snippet
- Keyboard shortcut (Cmd+K) to open search
- Track per-lesson completion and per-exercise completion separately
- Module completion = all lessons + exercises complete
- Overall course progress percentage on dashboard/home page
- Reset progress option in settings

### Claude's Discretion
- Exact Tailwind configuration and custom theme tokens
- shadcn/ui component customization details
- MDX plugin selection and configuration
- Search implementation approach (flexsearch, fuse.js, or similar)
- Animation and transition choices
- Exact responsive breakpoints
- Error boundary and 404 page design

### Deferred Ideas (OUT OF SCOPE)
- Embedded web-based terminal emulator (INT-01, v2)
- Interactive quizzes (INT-02, v2)
- Animated diagrams (INT-03, v2)
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| APP-01 | Next.js App Router application with TypeScript, Tailwind CSS, and shadcn/ui | `create-next-app` + `shadcn init` covers this; Tailwind v4 CSS-first config documented below |
| APP-02 | Modern, polished responsive design using shadcn/ui and 21st.dev components | shadcn CLI installs components; 21st.dev CLI-installable via shadcn command pattern |
| APP-03 | Course navigation with sidebar showing all modules and lessons with progress indicators | shadcn Sheet + custom sidebar pattern; progress indicators from localStorage context |
| APP-04 | Progress tracking persisted in localStorage (lesson completion, exercise completion) | React Context + useReducer + custom useLocalStorage hook; SSR hydration guard required |
| APP-05 | Dark mode support with system preference detection | next-themes 0.4.6 + Tailwind dark: variant; CSS-first approach with @theme in globals.css |
| APP-06 | Mobile-responsive layout that works on desktop and tablet | shadcn Sheet drawer for mobile nav; Tailwind breakpoints md:/lg: |
| APP-07 | Search functionality across all course content | MiniSearch 7.2.0 build-time index; shadcn Command + cmdk 1.1.1 for Cmd+K UI |
| APP-08 | Syntax-highlighted code blocks with copy-to-clipboard functionality | rehype-pretty-code 0.14.3 + shiki 4.0.2; copy button as client component wrapper |
| CONT-01 | MDX-based lesson content with rich formatting, diagrams, and interactive elements | @next/mdx 16.2.0 (same version as Next.js) is the official App Router approach |
| CONT-02 | Each lesson has thorough "How It Works" explanation sections before exercises | MDX custom components; content structure enforced by lesson template |
| CONT-03 | Each lesson has explicit prerequisites listed and linked | Frontmatter field `prerequisites: []`; renders as banner component at page top |
| CONT-04 | Interactive terminal/code components embedded in lessons | Custom TerminalBlock React component; NOT a real terminal emulator (deferred) |
| CONT-05 | Exercise sections with clear objectives, steps, and verification criteria | Custom ExerciseCard expandable component with difficulty label prop |
| CONT-06 | Quick reference/cheat sheet section per module | MDX page type = "reference"; renders with QuickReference layout |
| CONT-07 | Progressive difficulty labels (Foundation / Intermediate / Challenge) on exercises | Frontmatter or prop on ExerciseCard component |
| CONT-08 | Real-world scenario descriptions for every exercise | Content authoring convention; ExerciseCard has required `scenario` prop |
</phase_requirements>

---

## Summary

This phase bootstraps a greenfield Next.js 16 application with the full UI, navigation, content pipeline, and progress tracking. The stack is stable and well-documented: Next.js 16.2.0 is the current stable release, Tailwind CSS 4.2.2 introduced CSS-first configuration (no `tailwind.config.ts`), and shadcn/ui has been fully updated for both Tailwind v4 and React 19. The primary integration complexity lives in three places: the MDX pipeline (must support custom React components for terminal blocks, callouts, and exercise cards), the client-side search index (must be built at compile time from MDX frontmatter/content), and the localStorage progress system (requires SSR hydration guard because Next.js renders server-side before localStorage is available).

The correct MDX approach for this project is `@next/mdx` (official Next.js package, same version as Next.js itself), not `next-mdx-remote`. The distinction matters: `@next/mdx` processes MDX files at build time as native React Server Components, supporting `import`/`export` within MDX files and avoiding client-side hydration costs. `next-mdx-remote` evaluates MDX at runtime and its App Router support is marked unstable. For Mermaid diagrams, `rehype-mermaid` renders diagrams to inline SVG at build time via `mermaid-isomorphic`; this avoids shipping the full Mermaid JS bundle to the client.

The dark-first terminal aesthetic is well-supported by the chosen stack. Tailwind v4's `@theme` directive in `globals.css` enables custom CSS variable tokens for module accent colors (green for Linux, blue for networking, cyan for Docker). The `next-themes` library handles system preference detection with a `ThemeProvider` wrapper component. All custom components should be authored with dark variants as the design default, with light mode as the override.

**Primary recommendation:** Bootstrap with `create-next-app@latest` (selects Next.js 16.2.0 + Tailwind 4 + TypeScript + App Router), then run `npx shadcn@latest init` immediately. This generates the correct `globals.css` with Tailwind v4 inline theming and creates `components/ui/`. Build the content pipeline, navigation shell, and progress context in that order before writing any lesson content.

---

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| next | 16.2.0 | App framework, routing, build system | Latest stable (verified npm 2026-03-18); App Router is the current standard |
| react | 19.2.4 | UI rendering | Required by Next.js 16; supports Server Components |
| react-dom | 19.2.4 | DOM renderer | Paired with react |
| typescript | 5.9.3 | Type safety | Enforced by create-next-app with --typescript |
| tailwindcss | 4.2.2 | Utility CSS | Latest stable with CSS-first config; shadcn/ui v4-compatible |
| @next/mdx | 16.2.0 | MDX processing for App Router | Official Next.js MDX package, same version pin as Next.js; Server Component support |
| @mdx-js/loader | 3.1.1 | Webpack MDX loader (used by @next/mdx) | Required peer dependency |
| @mdx-js/react | 3.1.1 | MDX React provider | Required for custom component overrides |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| shadcn (CLI) | 4.0.8 | Component scaffolding | `npx shadcn@latest add [component]` — use for all UI primitives |
| next-themes | 0.4.6 | Dark/light mode + system preference | Required for APP-05; wraps layout root |
| rehype-pretty-code | 0.14.3 | Code block syntax highlighting | Pairs with shiki; renders at build time |
| shiki | 4.0.2 | Syntax highlighter (used by rehype-pretty-code) | Required peer dep; do NOT use rehype-highlight (older, less capable) |
| remark-gfm | 4.0.1 | GitHub-flavored markdown in MDX | Tables, task lists, strikethrough |
| gray-matter | 4.0.3 | Frontmatter parsing | Used during build to extract lesson metadata for search index |
| reading-time | 1.5.0 | Estimated reading time | Used in lesson page header for CONT-02 |
| rehype-mermaid | 3.0.0 | Mermaid diagrams → inline SVG at build time | For CONT-01; avoids shipping mermaid.js to client |
| cmdk | 1.1.1 | Command palette primitive | Used by shadcn Command component for Cmd+K search (APP-07) |
| minisearch | 7.2.0 | Client-side full-text search index | Build-time index over MDX content; simpler API than flexsearch; adequate for course scale |
| lucide-react | 0.577.0 | Icon library | shadcn/ui default icon set |
| @tailwindcss/typography | 0.5.19 | Prose styling for MDX body content | Tailwind v4 compatible; apply `prose dark:prose-invert` to lesson content wrapper |
| tw-animate-css | 1.4.0 | CSS animations | shadcn/ui v4 default (replaces tailwindcss-animate) |
| clsx | 2.1.1 | Conditional class names | Used with tailwind-merge in `cn()` utility |
| tailwind-merge | 3.5.0 | Merge Tailwind classes without conflicts | Used in `cn()` utility generated by shadcn init |
| class-variance-authority | 0.7.1 | Component variant API | Used by shadcn component variants |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| @next/mdx | next-mdx-remote 6.0.0 | next-mdx-remote App Router support marked unstable; lacks import/export in MDX files; choose @next/mdx |
| minisearch | flexsearch 0.8.212 | flexsearch has more complex API; no beta-free ESM build; minisearch sufficient for ~50 lesson corpus |
| minisearch | fuse.js 7.1.0 | fuse.js is fuzzy-only, no full-text; weaker snippet extraction for CMD+K results |
| rehype-mermaid | mdx-mermaid | mdx-mermaid uses puppeteer and is less actively maintained; rehype-mermaid uses mermaid-isomorphic |
| rehype-pretty-code + shiki | rehype-highlight | rehype-highlight uses highlight.js (less capable themes, no line highlighting); shiki is current standard |

**Installation (all at once):**
```bash
npx create-next-app@latest learn-systems --typescript --tailwind --app --no-src-dir --import-alias "@/*"
cd learn-systems
npx shadcn@latest init
npm install @next/mdx @mdx-js/loader @mdx-js/react
npm install rehype-pretty-code shiki remark-gfm gray-matter reading-time
npm install rehype-mermaid
npm install minisearch
npm install next-themes
npm install @tailwindcss/typography tw-animate-css
```

**Version verification (confirmed 2026-03-18 via npm registry):**
- `next@latest` → 16.2.0
- `tailwindcss@latest` → 4.2.2
- `shadcn@latest` → 4.0.8
- `@next/mdx@latest` → 16.2.0
- `rehype-pretty-code@latest` → 0.14.3
- `shiki@latest` → 4.0.2
- `rehype-mermaid@latest` → 3.0.0
- `minisearch@latest` → 7.2.0
- `next-themes@latest` → 0.4.6
- `cmdk@latest` → 1.1.1

---

## Architecture Patterns

### Recommended Project Structure

```
learn-systems/
├── app/
│   ├── layout.tsx                    # Root layout: ThemeProvider, fonts, globals.css
│   ├── page.tsx                      # Dashboard/home: overall course progress
│   ├── globals.css                   # Tailwind v4 @theme inline config (no tailwind.config.ts)
│   ├── modules/
│   │   └── [moduleSlug]/
│   │       ├── page.tsx              # Module overview page
│   │       └── [lessonSlug]/
│   │           └── page.tsx          # Lesson page
│   └── (search)/
│       └── api/
│           └── search-index/
│               └── route.ts          # Serves pre-built search index JSON
│
├── components/
│   ├── ui/                           # shadcn/ui generated components (do NOT hand-edit)
│   ├── layout/
│   │   ├── AppShell.tsx              # Root layout wrapper (sidebar + main)
│   │   ├── Sidebar.tsx               # Collapsible course nav with progress
│   │   ├── MobileSidebar.tsx         # Sheet-based drawer for mobile
│   │   └── Breadcrumb.tsx            # Module > Lesson breadcrumb
│   ├── lesson/
│   │   ├── LessonLayout.tsx          # Wraps MDX content with TOC, progress bar, metadata
│   │   ├── TableOfContents.tsx       # Auto-generated from headings (client component)
│   │   ├── ScrollProgressBar.tsx     # Top-of-page scroll indicator (client component)
│   │   ├── PrerequisiteBanner.tsx    # Prerequisites warning/links at lesson top
│   │   └── MarkCompleteButton.tsx    # "Mark as complete" CTA (client component)
│   ├── content/
│   │   ├── CodeBlock.tsx             # Syntax-highlighted code with copy button + filename header
│   │   ├── TerminalBlock.tsx         # Styled terminal mockup (command/output pairs)
│   │   ├── ExerciseCard.tsx          # Expandable exercise with steps, difficulty label, scenario
│   │   ├── VerificationChecklist.tsx # Pass/fail checklist with expandable hints
│   │   ├── Callout.tsx               # tip | warning | deep-dive callout variants
│   │   ├── MermaidDiagram.tsx        # Wrapper for server-rendered SVG (from rehype-mermaid)
│   │   └── QuickReference.tsx        # Module cheat sheet section layout
│   ├── search/
│   │   ├── SearchCommand.tsx         # Cmd+K modal using shadcn Command (client component)
│   │   └── SearchProvider.tsx        # Loads and holds MiniSearch index
│   └── progress/
│       └── ProgressProvider.tsx      # React Context + localStorage persistence
│
├── content/
│   └── modules/
│       ├── index.ts                  # Module manifest: ordered array of module metadata
│       ├── 01-linux-fundamentals/
│       │   ├── _module.ts            # Module metadata: title, slug, accent color, lessons[]
│       │   ├── 01-how-computers-work.mdx
│       │   ├── 02-operating-systems.mdx
│       │   └── ...
│       ├── 02-networking/
│       └── ...
│
├── lib/
│   ├── mdx.ts                        # MDX compilation helpers, frontmatter extraction
│   ├── progress.ts                   # Progress state types and localStorage schema
│   ├── search.ts                     # MiniSearch index build + query helpers
│   ├── modules.ts                    # Module/lesson metadata loading from content/
│   └── utils.ts                      # cn() utility (generated by shadcn)
│
├── hooks/
│   ├── useProgress.ts                # Reads/writes from ProgressContext
│   ├── useLocalStorage.ts            # SSR-safe generic localStorage hook
│   └── useScrollProgress.ts          # Scroll position percentage for progress bar
│
├── types/
│   ├── content.ts                    # Module, Lesson, Frontmatter type definitions
│   └── progress.ts                   # ProgressState, LessonProgress types
│
├── mdx-components.tsx                # REQUIRED by @next/mdx — maps MDX elements to custom components
├── next.config.ts                    # @next/mdx plugin, createMDX() config
└── package.json
```

### Pattern 1: Tailwind v4 CSS-First Configuration

**What:** Tailwind v4 eliminates `tailwind.config.ts`. All theme tokens, custom colors, and animations live in `globals.css` using the `@theme` directive. Custom module accent colors are defined as CSS variables.

**When to use:** All styling. Never create `tailwind.config.ts` — `shadcn init` generates the correct CSS-first setup.

**Example:**
```css
/* app/globals.css — Source: shadcn/ui Tailwind v4 docs */
@import "tailwindcss";
@import "tw-animate-css";

@custom-variant dark (&:is(.dark *));

@theme inline {
  /* Base tokens */
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --font-sans: var(--font-inter);
  --font-mono: var(--font-jetbrains-mono);

  /* Module accent colors */
  --color-module-linux: oklch(0.65 0.18 145);     /* green */
  --color-module-networking: oklch(0.65 0.15 240); /* blue */
  --color-module-docker: oklch(0.70 0.15 195);     /* cyan */
  --color-module-sysadmin: oklch(0.70 0.15 60);    /* amber */
  --color-module-cicd: oklch(0.65 0.15 300);       /* purple */
  --color-module-iac: oklch(0.65 0.15 30);         /* orange */
  --color-module-cloud: oklch(0.65 0.15 200);      /* sky */
  --color-module-monitoring: oklch(0.65 0.15 350); /* rose */
}

:root {
  /* dark-first: these are the dark theme values */
  --background: oklch(0.09 0 0);
  --foreground: oklch(0.95 0 0);
  /* ... shadcn token set */
}

.light {
  --background: oklch(0.99 0 0);
  --foreground: oklch(0.09 0 0);
}
```

### Pattern 2: @next/mdx Configuration

**What:** Configure `@next/mdx` in `next.config.ts` with remark/rehype plugins. A required `mdx-components.tsx` at the project root maps MDX elements to custom React components.

**When to use:** The single MDX processing setup for the entire project. All lesson `.mdx` files are processed by this pipeline.

**Example:**
```typescript
// next.config.ts — Source: https://nextjs.org/docs/app/guides/mdx
import createMDX from '@next/mdx'
import remarkGfm from 'remark-gfm'
import rehypePrettyCode from 'rehype-pretty-code'
import rehypeMermaid from 'rehype-mermaid'

const withMDX = createMDX({
  options: {
    remarkPlugins: [remarkGfm],
    rehypePlugins: [
      [rehypePrettyCode, {
        theme: 'one-dark-pro',
        keepBackground: false,  // let CSS handle background
      }],
      [rehypeMermaid, {
        strategy: 'inline-svg',
      }],
    ],
  },
})

const nextConfig = {
  pageExtensions: ['js', 'jsx', 'md', 'mdx', 'ts', 'tsx'],
}

export default withMDX(nextConfig)
```

```typescript
// mdx-components.tsx — REQUIRED file at project root
import type { MDXComponents } from 'mdx/types'
import { CodeBlock } from '@/components/content/CodeBlock'
import { Callout } from '@/components/content/Callout'
import { ExerciseCard } from '@/components/content/ExerciseCard'
import { TerminalBlock } from '@/components/content/TerminalBlock'
import { VerificationChecklist } from '@/components/content/VerificationChecklist'

export function useMDXComponents(components: MDXComponents): MDXComponents {
  return {
    pre: CodeBlock,
    // Custom component names available in MDX files:
    Callout,
    ExerciseCard,
    TerminalBlock,
    VerificationChecklist,
    ...components,
  }
}
```

### Pattern 3: SSR-Safe localStorage Progress Context

**What:** Progress state lives in a React Context backed by localStorage. Because Next.js SSR runs on the server where `localStorage` does not exist, reading must be deferred to `useEffect`. A hydration guard prevents server/client mismatch.

**When to use:** All progress read/write operations throughout the app.

**Example:**
```typescript
// lib/progress.ts — types
export type LessonId = string  // e.g., "01-linux-fundamentals/01-how-computers-work"

export interface ProgressState {
  completedLessons: Set<LessonId>
  completedExercises: Record<LessonId, Set<string>>
  version: number
}

// hooks/useLocalStorage.ts — SSR-safe hook
import { useState, useEffect } from 'react'

export function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(initialValue)
  const [isHydrated, setIsHydrated] = useState(false)

  useEffect(() => {
    // Only runs client-side, after hydration
    try {
      const item = window.localStorage.getItem(key)
      if (item) setStoredValue(JSON.parse(item))
    } catch (err) {
      console.warn(`useLocalStorage read error for key "${key}":`, err)
    }
    setIsHydrated(true)
  }, [key])

  const setValue = (value: T) => {
    try {
      setStoredValue(value)
      window.localStorage.setItem(key, JSON.stringify(value))
    } catch (err) {
      console.warn(`useLocalStorage write error for key "${key}":`, err)
    }
  }

  return [storedValue, setValue, isHydrated] as const
}
```

### Pattern 4: Build-Time Search Index

**What:** During the build, extract frontmatter and content from all MDX files to build a MiniSearch index serialized to JSON. The JSON is served as a static API route or imported directly. The search UI loads it client-side when the search modal opens.

**When to use:** APP-07 (search). Do not load MiniSearch on every page — load lazily when the user opens Cmd+K.

**Example:**
```typescript
// lib/search.ts
import MiniSearch from 'minisearch'

export interface SearchDoc {
  id: string           // lessonSlug
  title: string
  module: string
  moduleSlug: string
  body: string         // plain text (strip MDX markup)
}

export function buildSearchIndex(docs: SearchDoc[]) {
  const index = new MiniSearch<SearchDoc>({
    fields: ['title', 'module', 'body'],
    storeFields: ['title', 'module', 'moduleSlug', 'id'],
    searchOptions: {
      boost: { title: 3, module: 2 },
      fuzzy: 0.2,
      prefix: true,
    },
  })
  index.addAll(docs)
  return index.toJSON()
}
```

### Pattern 5: Lesson Frontmatter Schema

**What:** Every MDX lesson file begins with YAML frontmatter defining metadata consumed by the build pipeline, search index, and page layout.

**When to use:** Every `.mdx` file in `content/modules/`.

**Example:**
```yaml
---
title: "How Computers Work"
description: "CPU, memory, storage, I/O — the hardware layer before the OS"
module: "linux-fundamentals"
moduleSlug: "01-linux-fundamentals"
lessonSlug: "01-how-computers-work"
order: 1
difficulty: "Foundation"
estimatedMinutes: 25
prerequisites: []
tags: ["hardware", "cpu", "memory"]
---
```

### Pattern 6: Sidebar Navigation with Progress

**What:** The sidebar renders the full module/lesson tree from the module manifest. Per-module progress percentage is computed from the ProgressContext. Locked/unlocked state is determined by prerequisite completion.

**When to use:** All navigation rendering. The sidebar must be a Server Component at the outer level (reads module manifest at build time) with islands of client interactivity (collapse state, progress rendering).

**Key insight:** Use the "islands" pattern — the sidebar shell is a server component that receives static module tree data as props; a thin `SidebarClient` client component handles collapse state and reads from ProgressContext.

### Anti-Patterns to Avoid

- **Never call `window.localStorage` at module scope** — crashes during SSR. Always inside `useEffect`.
- **Never import `gray-matter` or MDX compilation code in client components** — Node.js dependencies will fail in the browser. Keep all MDX processing in `lib/mdx.ts` which only runs at build time.
- **Never use `next-mdx-remote` with App Router** — its RSC support is marked unstable. Use `@next/mdx` exclusively.
- **Never skip `mdx-components.tsx`** — `@next/mdx` silently fails to apply custom components without it.
- **Never use Tailwind `tailwind.config.ts`** — shadcn init generates CSS-first config for Tailwind v4; adding a config file breaks the theming.
- **Never ship `mermaid` JS to the client** — use `rehype-mermaid` with `strategy: 'inline-svg'` to render at build time.
- **Never put search index loading in SSR** — the MiniSearch index JSON is large; load it lazily inside the Cmd+K modal `useEffect`.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| UI component primitives | Custom Button, Dialog, Sheet | shadcn/ui `npx shadcn add` | Radix-based, accessible, dark mode ready |
| Cmd+K command palette | Custom modal + keyboard trap | shadcn Command (wraps cmdk) | Focus management, keyboard nav, fuzzy search wired |
| Dark mode toggle + system detect | Custom CSS class toggling | next-themes ThemeProvider | Handles SSR flash, system preference, localStorage |
| Syntax highlighting | Custom tokenizer | rehype-pretty-code + shiki | 100+ language grammars, line highlighting, copy-able |
| Mermaid SVG rendering | Client-side mermaid.js | rehype-mermaid (build time) | Zero JS bundle cost; works in RSC |
| Reading time estimate | Word counting logic | reading-time package | Handles code blocks, MDX, punctuation correctly |
| Class name conditionals | Manual string concat | `cn()` from shadcn (clsx + tailwind-merge) | Handles Tailwind class conflicts correctly |
| Component variants | Inline ternaries | class-variance-authority | Type-safe variant API used by all shadcn components |
| Icon set | Custom SVGs | lucide-react | 1000+ icons; tree-shakeable; matches shadcn visual weight |
| Font loading | Manual @font-face | Next.js `next/font` | Zero CLS, automatic subsetting, self-hosted |

**Key insight:** The shadcn/ui ecosystem (shadcn CLI + cmdk + Radix + lucide + tailwind-merge + cva) forms a complete, internally consistent component system. Custom-building any piece of it introduces inconsistencies in accessibility and dark mode handling that compound across the many interactive components this app needs.

---

## Common Pitfalls

### Pitfall 1: localStorage SSR Mismatch
**What goes wrong:** Component reads `localStorage` during SSR, throws `ReferenceError: localStorage is not defined`, or causes hydration mismatch (`Warning: Text content did not match`).
**Why it happens:** Next.js renders components on the server before shipping to client. `localStorage` only exists in the browser.
**How to avoid:** All localStorage reads must be inside `useEffect`. The `useLocalStorage` hook above handles this with an `isHydrated` flag — render a skeleton/null before `isHydrated` is true.
**Warning signs:** `ReferenceError: localStorage is not defined` in build logs; hydration warnings in browser console.

### Pitfall 2: Tailwind v4 + shadcn/ui Configuration Conflict
**What goes wrong:** Developer adds `tailwind.config.ts` or uses Tailwind v3 syntax (`theme.extend.colors`) alongside shadcn v4 CSS-first config. Custom tokens stop working or components lose their theme.
**Why it happens:** Tailwind v4 moved all configuration to `globals.css` `@theme` blocks. shadcn v4 generates CSS-variable-based tokens that expect this new system.
**How to avoid:** Run `npx shadcn@latest init` on a fresh Next.js 16 + Tailwind v4 project before writing any custom CSS. Add all custom tokens to the `@theme inline {}` block in `globals.css`.
**Warning signs:** Components appear with wrong background colors; dark mode doesn't apply to custom components.

### Pitfall 3: @next/mdx Missing mdx-components.tsx
**What goes wrong:** Custom components (`<Callout>`, `<ExerciseCard>`, `<TerminalBlock>`) used inside `.mdx` files render as unknown HTML or throw "element type is invalid" errors.
**Why it happens:** `@next/mdx` requires `mdx-components.tsx` at the project root to know which React components to inject into MDX scope. Without it, custom component names are undefined.
**How to avoid:** Create `mdx-components.tsx` at the project root (alongside `next.config.ts`) before writing any MDX content. This file is processed by `@next/mdx` at build time.
**Warning signs:** Custom MDX component names render as empty or throw runtime errors; `pre` elements don't use custom CodeBlock.

### Pitfall 4: rehype-pretty-code + Turbopack Incompatibility
**What goes wrong:** Development server throws "Cannot pass functions via Turbopack config" when using `rehype-pretty-code` with Next.js Turbopack dev mode.
**Why it happens:** Rehype/remark plugins that accept JavaScript functions (like rehype-pretty-code's transformer options) cannot be serialized by Turbopack's Rust-based compilation pipeline.
**How to avoid:** Use `next dev --no-turbopack` during development, or use the `next.config.ts` webpack bundler configuration (default). Avoid `--turbopack` flag until official support is confirmed.
**Warning signs:** `Error: [...] cannot be passed to Rust` in dev server output.

### Pitfall 5: MiniSearch Index Too Large to Inline
**What goes wrong:** The serialized MiniSearch index is embedded in the JavaScript bundle, increasing initial page load significantly (can be 500KB+ for 50+ lessons with full body text).
**Why it happens:** If `buildSearchIndex()` output is imported directly as a module constant, Next.js bundles it into the page JS.
**How to avoid:** Serve the search index as a static JSON file via a Route Handler (`app/api/search-index/route.ts`). Load it lazily in `SearchProvider` only when the Cmd+K modal first opens. Strip MDX syntax from body text before indexing (index plain text only).
**Warning signs:** Large JS bundle size; slow initial page load; Lighthouse warnings on script parse time.

### Pitfall 6: Mermaid Diagrams Requiring Playwright at Build Time
**What goes wrong:** `rehype-mermaid` with `strategy: 'inline-svg'` requires `mermaid-isomorphic` which uses Playwright to headlessly render diagrams. Playwright must be installed separately.
**Why it happens:** Mermaid renders diagrams in a browser context; `rehype-mermaid` automates this via Playwright.
**How to avoid:** Install Playwright browsers with `npx playwright install chromium` after `npm install`. Add this to any CI pipeline. Document in project README.
**Warning signs:** `Error: Failed to launch browser` during `next build`.

### Pitfall 7: Progress Context Rendering Skeleton Flash
**What goes wrong:** Before `isHydrated` is true (before localStorage loads), sidebar shows all lessons as incomplete — then flashes to actual progress state on hydration.
**Why it happens:** Server renders the progress-dependent UI with empty progress state; client hydrates with localStorage values.
**How to avoid:** In `SidebarClient`, render progress percentage only after `isHydrated` is true. Use a CSS opacity transition on the progress indicator (not a layout shift) to make the hydration invisible to users.
**Warning signs:** Visible flash of "0% complete" on page load even when user has made progress.

---

## Code Examples

### Next.js Root Layout with Fonts and Themes

```typescript
// app/layout.tsx
// Source: Next.js docs (nextjs.org/docs/app/building-your-application/optimizing/fonts)
import { Inter, JetBrains_Mono } from 'next/font/google'
import { ThemeProvider } from 'next-themes'
import { ProgressProvider } from '@/components/progress/ProgressProvider'
import { AppShell } from '@/components/layout/AppShell'
import './globals.css'

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap',
})

const jetbrainsMono = JetBrains_Mono({
  subsets: ['latin'],
  variable: '--font-jetbrains-mono',
  display: 'swap',
})

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={`${inter.variable} ${jetbrainsMono.variable} font-sans`}>
        <ThemeProvider attribute="class" defaultTheme="dark" enableSystem>
          <ProgressProvider>
            <AppShell>{children}</AppShell>
          </ProgressProvider>
        </ThemeProvider>
      </body>
    </html>
  )
}
```

### Lesson Page with MDX

```typescript
// app/modules/[moduleSlug]/[lessonSlug]/page.tsx
// Source: nextjs.org/docs/app/guides/mdx (App Router pattern)
import { notFound } from 'next/navigation'
import { getLessonContent } from '@/lib/mdx'
import { LessonLayout } from '@/components/lesson/LessonLayout'

interface Props {
  params: Promise<{ moduleSlug: string; lessonSlug: string }>
}

export default async function LessonPage({ params }: Props) {
  const { moduleSlug, lessonSlug } = await params
  const lesson = await getLessonContent(moduleSlug, lessonSlug)

  if (!lesson) notFound()

  const { default: MDXContent, frontmatter } = lesson

  return (
    <LessonLayout frontmatter={frontmatter}>
      <MDXContent />
    </LessonLayout>
  )
}

export async function generateStaticParams() {
  // Build all lesson paths at compile time
  const { getAllLessonPaths } = await import('@/lib/modules')
  return getAllLessonPaths()
}
```

### CodeBlock Component (with Copy Button)

```typescript
// components/content/CodeBlock.tsx
'use client'
import { useState } from 'react'
import { Check, Copy } from 'lucide-react'
import { cn } from '@/lib/utils'

interface CodeBlockProps {
  children: React.ReactNode
  'data-language'?: string    // injected by rehype-pretty-code
  'data-filename'?: string    // from MDX meta string: ```bash filename="deploy.sh"
}

export function CodeBlock({ children, ...props }: CodeBlockProps) {
  const [copied, setCopied] = useState(false)
  const language = props['data-language']
  const filename = props['data-filename']

  const handleCopy = () => {
    const code = (children as any)?.props?.children ?? ''
    navigator.clipboard.writeText(typeof code === 'string' ? code : String(code))
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  return (
    <div className="group relative rounded-lg border border-border bg-muted/40 overflow-hidden">
      {(filename || language) && (
        <div className="flex items-center justify-between px-4 py-2 border-b border-border bg-muted/60">
          <span className="text-xs font-mono text-muted-foreground">
            {filename ?? language}
          </span>
        </div>
      )}
      <button
        onClick={handleCopy}
        className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity p-1.5 rounded bg-muted hover:bg-muted/80"
        aria-label="Copy code"
      >
        {copied ? <Check className="h-3.5 w-3.5 text-green-400" /> : <Copy className="h-3.5 w-3.5" />}
      </button>
      <pre className="overflow-x-auto p-4 text-sm font-mono">{children}</pre>
    </div>
  )
}
```

### Callout Component

```typescript
// components/content/Callout.tsx
import { cn } from '@/lib/utils'
import { AlertCircle, Lightbulb, Microscope } from 'lucide-react'

type CalloutType = 'tip' | 'warning' | 'deep-dive'

interface CalloutProps {
  type: CalloutType
  title?: string
  children: React.ReactNode
}

const config: Record<CalloutType, { icon: typeof Lightbulb; classes: string }> = {
  tip: {
    icon: Lightbulb,
    classes: 'border-l-green-500 bg-green-500/5',
  },
  warning: {
    icon: AlertCircle,
    classes: 'border-l-amber-500 bg-amber-500/5',
  },
  'deep-dive': {
    icon: Microscope,
    classes: 'border-l-blue-500 bg-blue-500/5',
  },
}

export function Callout({ type, title, children }: CalloutProps) {
  const { icon: Icon, classes } = config[type]
  return (
    <div className={cn('my-6 border-l-4 px-4 py-3 rounded-r-lg', classes)}>
      <div className="flex items-center gap-2 mb-2">
        <Icon className="h-4 w-4 shrink-0" />
        <span className="text-sm font-semibold">{title ?? type}</span>
      </div>
      <div className="text-sm prose-sm">{children}</div>
    </div>
  )
}
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `tailwind.config.ts` with `theme.extend` | CSS-first `@theme` in `globals.css` | Tailwind v4 (2025) | No more JS config file; all tokens in CSS |
| `tailwindcss-animate` | `tw-animate-css` | shadcn/ui v4 (2025) | Drop-in replacement; use `@import "tw-animate-css"` |
| `next-mdx-remote` for RSC | `@next/mdx` | Next.js 13+ stabilized; now official | Stable, build-time, supports imports in MDX |
| `highlight.js` / rehype-highlight | shiki + rehype-pretty-code | 2024-2025 | TextMate grammars; line highlighting; VS Code themes |
| Client-side mermaid.js bundle | rehype-mermaid (build-time SVG) | 2024 | Zero client JS cost for diagrams |
| next 14 `params` as plain object | next 15/16 `params` as `Promise<{...}>` | Next.js 15 | Must `await params` in async Server Components |

**Deprecated/outdated:**
- `pages/` router: App Router is current standard; new projects should not use Pages Router
- `tailwindcss-animate`: replaced by `tw-animate-css` in shadcn v4
- `next-mdx-remote` for App Router: unstable RSC support; use `@next/mdx`
- `@next/font` (old import): now `next/font/google` — the `@next/font` package was merged into Next.js 13+

---

## Open Questions

1. **21st.dev component installation workflow**
   - What we know: 21st.dev components are shadcn-CLI-installable via `npx shadcn add [url]` or the 21st.dev site registry
   - What's unclear: Whether specific 21st.dev components (hero sections, nav bars) are needed for Phase 1, or just shadcn/ui primitives
   - Recommendation: Use shadcn/ui primitives for Phase 1 shell. Identify specific 21st.dev components during implementation when a "marketing-level polish" moment is needed (e.g., the dashboard home page).

2. **rehype-mermaid Playwright CI dependency**
   - What we know: `rehype-mermaid` requires Playwright chromium for build-time rendering
   - What's unclear: Whether this adds unacceptable build time or complexity for a local-only project
   - Recommendation: If Playwright adds friction, fall back to a client-side `MermaidDiagram` component that lazily loads mermaid.js only when a diagram is present on the page. Phase 1 has no diagram content anyway; defer the Playwright decision to when actual Mermaid content is authored.

3. **Content directory location: `app/` vs `content/`**
   - What we know: `@next/mdx` can process `.mdx` files in the `app/` directory as pages, OR files can live in a `content/` directory and be imported into page components
   - What's unclear: For a course with dynamic `[lessonSlug]` routing, the `content/` + dynamic import approach is more flexible; but `app/` directory MDX has simpler routing
   - Recommendation: Use `content/modules/` directory with dynamic routes in `app/modules/[moduleSlug]/[lessonSlug]/page.tsx`. This keeps content separate from routing and makes Phase 2-7 content authoring predictable.

---

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None installed yet — greenfield project |
| Config file | None — Wave 0 task |
| Quick run command | `npm test` (after setup) |
| Full suite command | `npm run test:ci` (after setup) |

For a Next.js UI-heavy project, the appropriate test strategy is:
- **Unit tests** for pure logic (progress calculations, search index building, frontmatter parsing): Vitest
- **Component tests** for interactive components (MarkCompleteButton, SearchCommand, Sidebar collapse): React Testing Library + Vitest
- **E2E tests** are out of scope for Phase 1 (no Playwright for testing; reserved for build-time Mermaid if adopted)

### Phase Requirements to Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| APP-04 | `useLocalStorage` reads/writes/hydrates safely | unit | `vitest run hooks/useLocalStorage.test.ts` | Wave 0 |
| APP-04 | Progress context correctly tracks lesson + exercise completion | unit | `vitest run lib/progress.test.ts` | Wave 0 |
| APP-07 | MiniSearch index builds from lesson data and returns expected results | unit | `vitest run lib/search.test.ts` | Wave 0 |
| CONT-01 | MDX frontmatter parsing extracts required fields | unit | `vitest run lib/mdx.test.ts` | Wave 0 |
| APP-03 | Module completion % calculation is correct | unit | `vitest run lib/modules.test.ts` | Wave 0 |
| APP-05 | Dark mode default is set correctly | manual | verify in browser | manual-only |
| APP-06 | Mobile sidebar opens/closes on hamburger click | manual | verify on mobile viewport | manual-only |
| APP-08 | Code blocks render with copy button | manual | verify in browser | manual-only |

### Sampling Rate

- **Per task commit:** `vitest run` (unit tests only, < 10 seconds)
- **Per wave merge:** `vitest run --reporter=verbose` (all unit tests)
- **Phase gate:** All unit tests green + manual visual check of dark mode, mobile layout, and code block copy button before `/gsd:verify-work`

### Wave 0 Gaps

- [ ] `vitest.config.ts` — install `vitest @testing-library/react @testing-library/user-event jsdom`
- [ ] `hooks/__tests__/useLocalStorage.test.ts` — covers APP-04 SSR guard behavior
- [ ] `lib/__tests__/progress.test.ts` — covers APP-04 completion calculations
- [ ] `lib/__tests__/search.test.ts` — covers APP-07 index build and query
- [ ] `lib/__tests__/mdx.test.ts` — covers CONT-01 frontmatter extraction

---

## Sources

### Primary (HIGH confidence)
- npm registry (2026-03-18) — all package versions verified via `npm view [package] version` and `dist-tags`
- https://nextjs.org/docs/app/guides/mdx — @next/mdx App Router setup, mdx-components.tsx requirement, params as Promise
- https://ui.shadcn.com/docs/tailwind-v4 — shadcn/ui Tailwind v4 migration, tw-animate-css, CSS-first config
- https://ui.shadcn.com/docs/installation/next — shadcn/ui Next.js installation
- https://rehype-pretty.pages.dev/ — rehype-pretty-code configuration, ESM-only, Turbopack limitation
- https://github.com/remcohaszing/rehype-mermaid — rehype-mermaid inline-svg strategy, Playwright dependency

### Secondary (MEDIUM confidence)
- https://lucaong.github.io/minisearch/ — MiniSearch API, toJSON serialization, search options
- https://github.com/pacocoursey/cmdk — cmdk "use client" requirement for App Router
- https://www.richardhnguyen.com/blogs/how-to-use-shiki-in-next-with-mdx — shiki + rehype-pretty-code Next.js integration patterns
- WebSearch: shadcn/ui v4 + Tailwind v4 compatibility confirmation (multiple sources 2025-2026)

### Tertiary (LOW confidence)
- WebSearch: 21st.dev installation via shadcn CLI — no official docs URL found, described via community sources only
- rehype-mermaid Playwright build time impact — not benchmarked; theoretical concern

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all versions verified directly against npm registry 2026-03-18
- Architecture: HIGH — patterns derived from official Next.js docs + shadcn official docs + verified stack behavior
- Pitfalls: HIGH — localStorage SSR and Tailwind v4 conflicts are documented; rehype-pretty-code/Turbopack is confirmed in official docs
- Search approach: MEDIUM — MiniSearch recommendation is well-reasoned but not benchmarked against actual lesson corpus size

**Research date:** 2026-03-18
**Valid until:** 2026-06-18 (90 days — Next.js and shadcn move fast; re-verify before any major version bumps)
