# Phase 1: App Foundation - Context

**Gathered:** 2026-03-18
**Status:** Ready for planning

<domain>
## Phase Boundary

Build the Next.js application shell with full course navigation, localStorage progress tracking, MDX content pipeline, and a content framework that every subsequent curriculum module drops into. No curriculum content is written in this phase — only the platform.

</domain>

<decisions>
## Implementation Decisions

### Course Navigation Layout
- Collapsible sidebar with module sections — each module expands to show its lessons
- Checkmark icons with completion percentage per module in the sidebar
- Numbered modules with locked/unlocked visual state based on prerequisite completion
- Mobile: slide-out drawer with hamburger menu
- Breadcrumb navigation on lesson pages (Module > Lesson)
- Sticky sidebar on desktop, scrollable independently from content

### Lesson Page Structure
- Section ordering: Overview → How It Works (mechanism explanation) → Hands-On Exercise → Verification → Quick Reference
- Prerequisites displayed as a banner at top with linked prerequisite lessons; visual warning if prerequisites are incomplete
- Exercise sections presented as expandable cards with clear objectives, numbered steps, and copy-paste command blocks
- Scroll progress bar at top of lesson + estimated reading time
- "Mark as complete" button at the bottom of each lesson
- Table of contents for long lessons (auto-generated from headings)

### Visual Design Direction
- Dark-first terminal aesthetic — dark mode is the default, light mode available
- Accent colors per module category (e.g., Linux = green, Networking = blue, Docker = cyan)
- Typography: Inter for prose, JetBrains Mono (or similar) for code/terminal blocks
- Comfortable spacing optimized for long-form reading — not cramped
- Professional developer tool feel — inspired by Vercel docs and Linear
- shadcn/ui components as the base, 21st.dev components for hero/marketing-level polish

### Content Interactivity
- Code blocks: syntax highlighting + line numbers + copy button + filename/language header
- Terminal mockup component showing expected command/output pairs (styled like a real terminal)
- Exercise verification: checklist display with pass/fail indicators and expandable hints
- Mermaid diagrams rendered inline for architecture and data flow concepts
- Callout components for tips, warnings, and "under the hood" deep dives

### Search
- Client-side full-text search across all lesson content
- Search results show lesson title, module, and matching snippet
- Keyboard shortcut (Cmd+K) to open search

### Progress Tracking
- localStorage persistence — no backend needed
- Track per-lesson completion and per-exercise completion separately
- Module completion = all lessons + exercises complete
- Overall course progress percentage on the dashboard/home page
- Reset progress option in settings

### Claude's Discretion
- Exact Tailwind configuration and custom theme tokens
- shadcn/ui component customization details
- MDX plugin selection and configuration
- Search implementation approach (flexsearch, fuse.js, or similar)
- Animation and transition choices
- Exact responsive breakpoints
- Error boundary and 404 page design

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

No external specs — requirements are fully captured in decisions above and in `.planning/REQUIREMENTS.md` (APP-01 through APP-08, CONT-01 through CONT-08).

### Project context
- `.planning/PROJECT.md` — Project vision, core value, constraints (Next.js + shadcn/ui + 21st.dev)
- `.planning/REQUIREMENTS.md` — Full requirement definitions with REQ-IDs
- `.planning/research/SUMMARY.md` — Research findings on course architecture patterns
- `.planning/research/ARCHITECTURE.md` — Component boundaries and lesson/exercise/lab separation pattern

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- None — greenfield project, no existing code

### Established Patterns
- None yet — this phase establishes all patterns

### Integration Points
- This phase creates the foundation that all subsequent phases (2-7) build on
- MDX content pipeline must support the lesson structure that Phases 2-7 will populate
- Progress tracking must support the module/lesson/exercise hierarchy

</code_context>

<specifics>
## Specific Ideas

- User explicitly requested modern, polished UI — "make it look very modern"
- Use shadcn/ui and 21st.dev components — not generic or basic-looking
- Production-ready quality expected
- Dark-first aesthetic appropriate for a DevOps/systems engineering audience
- Course should feel like a premium developer tool, not a generic tutorial site
- Thorough explanations are the core differentiator — lesson template must enforce "How It Works" sections prominently

</specifics>

<deferred>
## Deferred Ideas

- Embedded web-based terminal emulator (INT-01, v2) — for now, terminal mockup components showing expected command/output pairs
- Interactive quizzes (INT-02, v2)
- Animated diagrams (INT-03, v2)

</deferred>

---

*Phase: 01-app-foundation*
*Context gathered: 2026-03-18*
