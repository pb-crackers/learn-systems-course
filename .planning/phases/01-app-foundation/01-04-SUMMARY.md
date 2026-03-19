---
phase: 01-app-foundation
plan: "04"
subsystem: ui
tags: [nextjs, mdx, tailwind, react, shadcn, typescript, lucide, content-components]

requires:
  - phase: 01-app-foundation-01
    provides: Next.js 16 scaffold, Tailwind v4, type system (types/content.ts), Vitest
  - phase: 01-app-foundation-02
    provides: ProgressProvider, useProgress hook, useLocalStorage, sidebar, AppShell
  - phase: 01-app-foundation-03
    provides: MDX pipeline (@next/mdx), getLessonContent, getAllLessonPaths, lesson page route
provides:
  - CodeBlock component with copy button and filename/language header (maps pre in MDX)
  - TerminalBlock component for command/output pairs styled as terminal mockup
  - ExerciseCard expandable component with difficulty label and required scenario prop
  - VerificationChecklist with pass/fail per item and expandable hints
  - Callout component with tip/warning/deep-dive variants
  - QuickReference component for module cheat sheet tables
  - LessonLayout full page wrapper with scroll progress bar, ToC, prerequisites banner, mark-complete button
  - ScrollProgressBar, TableOfContents, PrerequisiteBanner, MarkCompleteButton components
  - mdx-components.tsx with full registry mapping pre to CodeBlock and all custom components
  - Canonical lesson template MDX at content/modules/01-linux-fundamentals/00-template.mdx
affects:
  - Phase 2+ (all curriculum modules use these components)
  - Every lesson MDX file authored in Phase 2-7

tech-stack:
  added: [shadcn/collapsible]
  patterns:
    - CodeBlock wraps rehype-pretty-code pre output as 'use client' component
    - TerminalBlock is a pure server-renderable component (no client state)
    - ExerciseCard uses local useState for open/closed — no ProgressContext
    - VerificationChecklist uses local useState — exercise completion tracked separately
    - LessonLayout derives lessonId as moduleSlug/lessonSlug for MarkCompleteButton
    - mdx-components.tsx uses `pre: CodeBlock as any` to satisfy MDXComponents type

key-files:
  created:
    - components/content/CodeBlock.tsx
    - components/content/TerminalBlock.tsx
    - components/content/ExerciseCard.tsx
    - components/content/VerificationChecklist.tsx
    - components/content/Callout.tsx
    - components/content/QuickReference.tsx
    - components/lesson/LessonLayout.tsx
    - components/lesson/ScrollProgressBar.tsx
    - components/lesson/TableOfContents.tsx
    - components/lesson/PrerequisiteBanner.tsx
    - components/lesson/MarkCompleteButton.tsx
    - content/modules/01-linux-fundamentals/00-template.mdx
    - content/modules/_exercise-template.mdx
  modified:
    - mdx-components.tsx (full registry update from placeholder)
    - app/modules/[moduleSlug]/[lessonSlug]/page.tsx (wrapped in LessonLayout)

key-decisions:
  - "CodeBlock copy implementation uses data-copy-target attribute on pre element to extract text; avoids React tree traversal issues with rehype-pretty-code nested spans"
  - "TerminalBlock is a server component (no use client directive) since it has no interactive state — only display"
  - "ExerciseCard and VerificationChecklist use local useState — not tied to ProgressContext. ProgressContext tracks lesson/exercise completion at a higher level"
  - "mdx-components.tsx uses `pre: CodeBlock as any` cast to satisfy MDXComponents type — CodeBlock accepts additional data- props not in the HTMLPreElement type"
  - "LessonLayout lessonId derived as moduleSlug/lessonSlug — matches the LessonId type convention established in types/content.ts"
  - "TableOfContents only renders when 3+ headings exist — prevents unnecessary sidebar chrome on short lessons"
  - "PrerequisiteBanner renders null when prerequisites.length === 0 — no visual noise for lessons without prerequisites"

patterns-established:
  - "Pattern: Content components in components/content/, lesson layout components in components/lesson/"
  - "Pattern: Lesson template MDX structure — Overview → How It Works → Hands-On Exercise → Quick Reference"
  - "Pattern: ExerciseCard wraps VerificationChecklist as children — verification lives inside exercise context"
  - "Pattern: use client at file level for components with useState; omit for pure display components"

requirements-completed: [APP-08, CONT-02, CONT-03, CONT-04, CONT-05, CONT-06, CONT-07, CONT-08]

duration: 14min
completed: 2026-03-18
---

# Phase 1 Plan 04: Content Components and Lesson Layout Summary

**Six interactive content components (CodeBlock/TerminalBlock/ExerciseCard/VerificationChecklist/Callout/QuickReference), full LessonLayout wrapper with scroll progress bar and sticky ToC, and a canonical lesson template MDX file that enforces the How-It-Works-before-exercises structure for all Phase 2+ lesson authors**

## Performance

- **Duration:** 14 min
- **Started:** 2026-03-18T23:10:34Z
- **Completed:** 2026-03-18T23:24:00Z
- **Tasks:** 2 auto + 1 checkpoint (auto-approved)
- **Files modified:** 16

## Accomplishments

- All 6 content components built and typed: CodeBlock (copy button, filename/language header), TerminalBlock (macOS-style title bar, command/output/comment lines), ExerciseCard (expandable, difficulty label, required scenario prop), VerificationChecklist (pass/fail per item, expandable hints), Callout (tip/warning/deep-dive variants), QuickReference (structured command table)
- LessonLayout wires ScrollProgressBar, breadcrumb, lesson header (title/description/time/difficulty), PrerequisiteBanner, MDX prose, and MarkCompleteButton into a single server component wrapper
- mdx-components.tsx updated from placeholder to full registry — maps pre to CodeBlock and registers all 6 custom components for all MDX files
- Canonical lesson template at content/modules/01-linux-fundamentals/00-template.mdx demonstrates every component in correct section ordering (Overview → How It Works → Hands-On Exercise → Quick Reference)
- Production build passes: 13 routes generated (all module and lesson paths), 28 tests pass

## Task Commits

1. **Task 1: Interactive content components** - `33fd10c` (feat)
2. **Task 2: LessonLayout, lesson page wiring, mdx-components registry, and lesson template MDX** - `6259b0b` (feat)

## Files Created/Modified

- `components/content/CodeBlock.tsx` - Syntax-highlighted pre with copy button, filename/language header, 'use client'
- `components/content/TerminalBlock.tsx` - Terminal mockup with command/output/comment line types, macOS title bar
- `components/content/ExerciseCard.tsx` - Expandable card with required scenario/difficulty, numbered steps, optional command per step
- `components/content/VerificationChecklist.tsx` - Pass/fail checklist with expandable per-item hints
- `components/content/Callout.tsx` - tip (Lightbulb/green), warning (AlertCircle/amber), deep-dive (Microscope/blue) variants
- `components/content/QuickReference.tsx` - Table layout for command/description/example cheat sheets
- `components/lesson/LessonLayout.tsx` - Full lesson page wrapper (breadcrumb, header, prereqs, content, mark-complete, ToC)
- `components/lesson/ScrollProgressBar.tsx` - Fixed-position scroll indicator using scaleX transform
- `components/lesson/TableOfContents.tsx` - IntersectionObserver-driven active heading tracking; shows when 3+ h2/h3 headings
- `components/lesson/PrerequisiteBanner.tsx` - Reads ProgressContext; shows incomplete prereqs with amber warning, complete with green success
- `components/lesson/MarkCompleteButton.tsx` - Calls markLessonComplete(lessonId); hidden before hydration to prevent flash
- `mdx-components.tsx` - Full registry: pre→CodeBlock + Callout/ExerciseCard/TerminalBlock/VerificationChecklist/QuickReference
- `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` - Updated to wrap MDXContent in LessonLayout with frontmatter prop
- `content/modules/01-linux-fundamentals/00-template.mdx` - Canonical lesson template with all components
- `content/modules/_exercise-template.mdx` - Exercise/checklist component reference
- `components/ui/collapsible.tsx` - shadcn collapsible component (installed via CLI)

## Decisions Made

- CodeBlock copy uses `data-copy-target` attribute on pre to extract textContent — avoids traversing rehype-pretty-code's deeply-nested span structure
- `TerminalBlock` is a pure display component without `'use client'` — renders server-side with no interactive state
- Local `useState` for ExerciseCard open/close and VerificationChecklist checked items — these are UI state, not progress state; ProgressContext tracks lesson/exercise completion at a higher level
- `pre: CodeBlock as any` cast in mdx-components.tsx — CodeBlock accepts data-language/data-filename props that HTMLPreElement types don't include
- `TableOfContents` renders null when fewer than 3 headings — prevents unnecessary sidebar chrome on short lessons
- `PrerequisiteBanner` renders null when prerequisites array is empty — zero visual noise for the majority of Phase 1 lessons

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

Initial `npx next build` triggered Turbopack mode (from cached state) and failed with rehype-pretty-code serialization error. Running `npx next build --webpack` and `npm run build` both succeed — `npm run build` uses the `--webpack` flag from package.json scripts. This is a known pre-existing behavior documented in STATE.md decisions.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Phase 1 is complete. The full platform shell is ready for Phase 2+ curriculum content:
- All 8 modules in sidebar (1 unlocked, 7 locked)
- Cmd+K search (returns empty results until Phase 2 lesson content is indexed)
- LessonLayout ready to wrap any MDX file with the correct metadata and UI chrome
- Content components registered in mdx-components.tsx — any .mdx file can use Callout, ExerciseCard, TerminalBlock, VerificationChecklist, QuickReference immediately
- Canonical lesson template shows Phase 2+ authors exactly the structure, section ordering, and component usage expected

---
*Phase: 01-app-foundation*
*Completed: 2026-03-18*

## Self-Check: PASSED

Files verified:
- components/content/CodeBlock.tsx: FOUND
- components/content/TerminalBlock.tsx: FOUND
- components/content/ExerciseCard.tsx: FOUND
- components/content/VerificationChecklist.tsx: FOUND
- components/content/Callout.tsx: FOUND
- components/content/QuickReference.tsx: FOUND
- components/lesson/LessonLayout.tsx: FOUND
- components/lesson/ScrollProgressBar.tsx: FOUND
- components/lesson/TableOfContents.tsx: FOUND
- components/lesson/PrerequisiteBanner.tsx: FOUND
- components/lesson/MarkCompleteButton.tsx: FOUND
- content/modules/01-linux-fundamentals/00-template.mdx: FOUND
- mdx-components.tsx: maps pre → CodeBlock CONFIRMED
- app/modules/[moduleSlug]/[lessonSlug]/page.tsx: LessonLayout used CONFIRMED

Commits verified:
- 33fd10c: feat(01-04): interactive content components FOUND
- 6259b0b: feat(01-04): LessonLayout, lesson page wiring, mdx-components registry FOUND

Build: PASSED (13 routes, 0 errors)
Tests: PASSED (28/28)
