---
phase: 01-app-foundation
plan: "03"
subsystem: ui
tags: [mdx, gray-matter, minisearch, search, lesson-routing, nextjs, react, typescript]

# Dependency graph
requires:
  - phase: 01-app-foundation/01-01
    provides: "@next/mdx MDX pipeline, LessonFrontmatter type, gray-matter and reading-time deps, Vitest infrastructure"
  - phase: 01-app-foundation/01-02
    provides: "lib/modules.ts (getAllModules, getModuleBySlug, getAllLessonPaths), content/modules/index.ts"
provides:
  - "lib/mdx.ts: extractFrontmatter() with required field validation, getReadingTime(), getLessonContent()"
  - "lib/search.ts: buildSearchIndex(docs) → serializable JSON, createSearchIndex(json) → MiniSearch instance, SearchDoc interface"
  - "app/api/search-index/route.ts: static GET endpoint pre-rendered at build time, returns MiniSearch index JSON"
  - "app/modules/[moduleSlug]/page.tsx: module overview page with generateStaticParams over 8 modules"
  - "app/modules/[moduleSlug]/[lessonSlug]/page.tsx: lesson page with MDX rendering and generateStaticParams"
  - "components/search/SearchCommand.tsx: Cmd+K modal with lazy fetch of /api/search-index"
  - "components/search/SearchProvider.tsx: global Cmd+K / Ctrl+K keyboard shortcut wiring"
  - "10 unit tests: 4 mdx tests, 6 search tests — all passing"
affects:
  - 01-04 (lesson page components extend the lesson page route)
  - all subsequent phases (lesson routing + search system used by all content)

# Tech tracking
tech-stack:
  added:
    - cmdk@1.1.1 (shadcn Command dependency — installed via npx shadcn add command)
  patterns:
    - "Server-only MDX helpers: lib/mdx.ts imports gray-matter (Node.js); never import in client components"
    - "Lazy search index loading: fetch /api/search-index inside useEffect only when Cmd+K modal opens"
    - "MiniSearch round-trip: buildSearchIndex() on server → JSON stored at API route → createSearchIndex() on client"
    - "Search index served as static pre-rendered JSON at /api/search-index with force-static"

key-files:
  created:
    - lib/mdx.ts (extractFrontmatter, getReadingTime, getLessonContent — server-only)
    - lib/search.ts (buildSearchIndex, createSearchIndex, SearchDoc, SearchResult)
    - app/api/search-index/route.ts (static GET endpoint returning MiniSearch JSON)
    - app/modules/[moduleSlug]/page.tsx (module overview page)
    - app/modules/[moduleSlug]/[lessonSlug]/page.tsx (lesson page with MDX rendering)
    - components/search/SearchCommand.tsx (Cmd+K modal, lazy index load)
    - components/search/SearchProvider.tsx (global keyboard shortcut wiring)
    - components/ui/command.tsx (shadcn Command component via shadcn CLI)
    - components/ui/dialog.tsx (shadcn Dialog component via shadcn CLI)
    - lib/__tests__/mdx.test.ts (4 test cases for extractFrontmatter and getReadingTime)
    - lib/__tests__/search.test.ts (6 test cases for index build, hydrate, and search)
  modified:
    - app/layout.tsx (SearchProvider added inside ProgressProvider)
    - package.json (cmdk dependency added)

key-decisions:
  - "Search index served as static API route with force-static: avoids bundling large JSON into page JS (MiniSearch Pitfall 5); index fetched lazily only when Cmd+K first opens"
  - "MiniSearch createSearchIndex uses MiniSearch.loadJSON with JSON.stringify: converts object back to string for the loadJSON API which expects a string, not an object"
  - "rawResults cast via 'as unknown as SearchResult[]': MiniSearch's generic SearchResult type doesn't overlap with the local interface — double cast is correct since storeFields guarantees the properties exist"
  - "Empty corpus for Phase 1: /api/search-index returns valid but empty MiniSearch JSON; populated in Phase 2+ when MDX lesson files are added"
  - "rehype-mermaid omitted from MDX pipeline: deferred to Phase 2+ per plan note; requires Playwright/chromium for build-time SVG rendering"

patterns-established:
  - "Lesson routing: /modules/[moduleSlug]/[lessonSlug] via dynamic import of MDX files at build time"
  - "Search pattern: build-time index → static API route → lazy client fetch on first modal open"
  - "Frontmatter validation: extractFrontmatter throws 'Missing required frontmatter field: [field]' for missing required fields"

requirements-completed: [CONT-01, APP-07, APP-08]

# Metrics
duration: 18min
completed: 2026-03-19
---

# Phase 1 Plan 03: MDX Content Pipeline and Cmd+K Search Summary

**MDX frontmatter extraction with gray-matter, MiniSearch index served as static API route, lazy-loaded Cmd+K search modal, and dynamic lesson/module page routes with generateStaticParams**

## Performance

- **Duration:** ~18 min
- **Started:** 2026-03-19T02:48:28Z
- **Completed:** 2026-03-19T03:07:13Z
- **Tasks:** 2 (Task 1: TDD — RED + GREEN phases; Task 2: Search UI)
- **Files modified:** 14 (11 created, 3 modified)

## Accomplishments

- MDX pipeline utilities: `extractFrontmatter()` with required-field validation, `getReadingTime()` via reading-time, and `getLessonContent()` for dynamic MDX imports in Server Components
- MiniSearch index system: `buildSearchIndex()` produces serializable JSON at build time; `createSearchIndex()` hydrates on the client; round-trip tested with title/body search and boost ranking
- Lesson routing: `/modules/[moduleSlug]` (module overview) and `/modules/[moduleSlug]/[lessonSlug]` (lesson page) both compile with `generateStaticParams` — 8 module paths pre-rendered at build time
- Search API route: `/api/search-index` serves pre-built MiniSearch JSON as static content with `force-static` and cache headers; lazy-loaded by the Cmd+K modal
- Cmd+K search modal: `SearchCommand` fetches index only on first open (not at page load); `SearchProvider` wires keyboard shortcut globally in layout
- 28 total tests passing (10 new in this plan)

## Task Commits

Each task was committed atomically:

1. **TDD RED: Failing tests for MDX pipeline and search index** - `118e8b2` (test)
2. **Task 1: MDX content pipeline, search index, and lesson page routes** - `d79d621` (feat)
3. **Task 2: Search UI — Cmd+K modal with shadcn Command and lazy index loading** - `2422b82` (feat)

## Files Created/Modified

- `lib/mdx.ts` - extractFrontmatter (required field validation), getReadingTime, getLessonContent (dynamic MDX import)
- `lib/search.ts` - buildSearchIndex, createSearchIndex, SearchDoc and SearchResult interfaces
- `app/api/search-index/route.ts` - static GET handler returning pre-built MiniSearch JSON
- `app/modules/[moduleSlug]/page.tsx` - module overview page with generateStaticParams
- `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` - lesson page with MDX rendering and generateStaticParams
- `components/search/SearchCommand.tsx` - Cmd+K modal with lazy /api/search-index fetch
- `components/search/SearchProvider.tsx` - global Cmd+K / Ctrl+K keyboard shortcut
- `components/ui/command.tsx` - shadcn Command component (wraps cmdk)
- `components/ui/dialog.tsx` - shadcn Dialog component (wraps @base-ui/react/dialog)
- `components/ui/input.tsx`, `textarea.tsx`, `input-group.tsx` - shadcn dependencies installed by `shadcn add command`
- `lib/__tests__/mdx.test.ts` - 4 tests: valid frontmatter parse, missing title throw, missing estimatedMinutes throw, getReadingTime
- `lib/__tests__/search.test.ts` - 6 tests: empty corpus, serializable object, title search, body search, empty query, boost ranking
- `app/layout.tsx` - SearchProvider import and usage added inside ProgressProvider

## Decisions Made

- **Lazy search index pattern:** Index JSON served via `/api/search-index` with `force-static` (not bundled into page JS). Loaded inside `useEffect` only when Cmd+K modal first opens. Follows research Pitfall 5 — avoids 500KB+ JS bundle cost for 50+ lessons.
- **Empty corpus for Phase 1:** The API route returns a valid but empty MiniSearch index. Phase 2+ will scan `content/modules/**/*.mdx` to build the real index when lesson files exist.
- **MiniSearch type cast:** `rawResults as unknown as SearchResult[]` — MiniSearch's generic `SearchResult` type doesn't overlap with the local interface since `storeFields` fields aren't reflected in the generic type. The double cast is safe because the stored fields are guaranteed by the index configuration.
- **rehype-mermaid deferred:** No Mermaid diagrams in Phase 1; Playwright dependency adds complexity. Deferred to Phase 2+ per plan decision.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed MiniSearch type cast incompatibility**
- **Found during:** Task 2 (build verification)
- **Issue:** `rawResults as SearchResult[]` failed TypeScript compilation — MiniSearch's generic `SearchResult` type and local `SearchResult` interface don't overlap (neither extends the other)
- **Fix:** Changed to `rawResults as unknown as SearchResult[]` — safe double cast since storeFields guarantees the properties exist at runtime
- **Files modified:** `components/search/SearchCommand.tsx`
- **Verification:** `npm run build` exits 0 with TypeScript check passing
- **Committed in:** `2422b82` (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 bug)
**Impact on plan:** Type cast fix required for TypeScript compilation. Semantically equivalent behavior — storeFields guarantee the fields exist at runtime.

## Issues Encountered

- Initial build attempt used `npx next build` which defaults to Turbopack; the `package.json` scripts correctly use `--webpack` flag. Subsequent builds used `npm run build` which applies the webpack flag correctly.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- Lesson page route at `/modules/[moduleSlug]/[lessonSlug]/page.tsx` is ready for Plan 04 to wrap with `LessonLayout`
- `lib/mdx.ts` exports are ready — Plan 04 will use `getLessonContent()` from the lesson page
- Search system complete — when Phase 2+ adds MDX lesson files, `app/api/search-index/route.ts` only needs to scan and index the files
- No blockers for Plan 04

## Self-Check: PASSED

All key files verified present on disk:
- lib/mdx.ts: FOUND
- lib/search.ts: FOUND
- app/api/search-index/route.ts: FOUND
- app/modules/[moduleSlug]/page.tsx: FOUND
- app/modules/[moduleSlug]/[lessonSlug]/page.tsx: FOUND
- components/search/SearchCommand.tsx: FOUND
- components/search/SearchProvider.tsx: FOUND
- lib/__tests__/mdx.test.ts: FOUND
- lib/__tests__/search.test.ts: FOUND

All commits verified:
- 118e8b2 (test RED: failing tests): FOUND
- d79d621 (Task 1: MDX pipeline and routes): FOUND
- 2422b82 (Task 2: Search UI): FOUND

---
*Phase: 01-app-foundation*
*Completed: 2026-03-19*
