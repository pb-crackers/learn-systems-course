---
phase: 01-app-foundation
plan: "02"
subsystem: ui
tags: [nextjs, react, shadcn, sidebar, navigation, progress, localStorage, context, dashboard]

# Dependency graph
requires:
  - 01-01 (type system, useLocalStorage, Tailwind CSS tokens)
provides:
  - content/modules/index.ts: MODULES array with 8 modules in cognitive dependency order
  - lib/modules.ts: getAllModules(), getModuleBySlug(), getAllLessonPaths() utilities
  - components/progress/ProgressProvider.tsx: ProgressContext + localStorage persistence
  - hooks/useProgress.ts: useProgress() hook (throws outside ProgressProvider)
  - components/layout/AppShell.tsx: server component root layout (fixed sidebar + main)
  - components/layout/Sidebar.tsx: server component module tree (delegates to SidebarClient)
  - components/layout/SidebarClient.tsx: client component with collapse/lock/progress state
  - components/layout/MobileSidebar.tsx: Sheet-based mobile drawer with hamburger trigger
  - components/layout/Breadcrumb.tsx: reusable breadcrumb navigation component
  - components/layout/SidebarFooter.tsx: Reset Progress footer with two-click confirmation
  - components/dashboard/CourseDashboard.tsx: home page with overall progress + module card grid
  - shadcn/ui: sheet, separator, badge, progress components
affects:
  - 01-03 (MDX content pipeline — ProgressProvider already wrapping app)
  - 01-04 (lesson page components — AppShell is the layout shell)
  - all subsequent phases dropping lesson content into the navigation structure

# Tech tracking
tech-stack:
  added:
    - "@base-ui/react: Sheet (Dialog), Separator — used by shadcn shell"
    - shadcn/ui sheet (base-ui/react Dialog wrapper)
    - shadcn/ui separator (base-ui/react Separator wrapper)
    - shadcn/ui badge
    - shadcn/ui progress
  patterns:
    - Islands architecture: Sidebar is a server component passing static data to SidebarClient (client component)
    - ProgressContext: React context + useLocalStorage for SSR-safe localStorage-backed progress state
    - Two-click confirmation pattern: first click enters confirming state, second click executes reset
    - Module locking: index 0 always unlocked; index N unlocked when module[N-1] is 100% complete
    - Dark-first accent color tokens: var(--color-module-{slug}) applied via inline style

key-files:
  created:
    - content/modules/index.ts (MODULES array — 8 modules, accentColor keys)
    - lib/modules.ts (getAllModules, getModuleBySlug, getAllLessonPaths)
    - lib/__tests__/modules.test.ts (7 test cases, TDD RED then GREEN)
    - components/progress/ProgressProvider.tsx (ProgressContext, ProgressProvider)
    - hooks/useProgress.ts (useProgress — throws outside provider)
    - components/layout/AppShell.tsx (root layout: hidden-md aside + main)
    - components/layout/Sidebar.tsx (server component: logo + SidebarClient + SidebarFooter)
    - components/layout/SidebarClient.tsx (client component: expand/collapse, lock, progress%)
    - components/layout/MobileSidebar.tsx (Sheet drawer, hamburger trigger md:hidden)
    - components/layout/Breadcrumb.tsx (BreadcrumbItem[], ChevronRight separator)
    - components/layout/SidebarFooter.tsx (resetProgress, two-click confirmation)
    - components/dashboard/CourseDashboard.tsx (overall progress bar, 2-col module card grid)
    - components/ui/sheet.tsx (shadcn add)
    - components/ui/separator.tsx (shadcn add)
    - components/ui/badge.tsx (shadcn add)
    - components/ui/progress.tsx (shadcn add)
  modified:
    - app/layout.tsx (AppShell + MobileSidebar + ProgressProvider wrapping)
    - app/page.tsx (server-rendered CourseDashboard via getAllModules())

key-decisions:
  - "Islands architecture for sidebar: Sidebar is a server component that calls getAllModules() at render time and passes the static Module[] array to SidebarClient; this keeps server-rendered HTML fast while allowing client interactivity for collapse state and progress display"
  - "Two-click confirmation for reset: first click shows AlertTriangle + 'Click again to confirm' in destructive color; auto-cancels after 3 seconds; prevents accidental progress wipes"
  - "asChild prop removed from SheetTrigger: shadcn base-nova style uses @base-ui/react which does not support Radix-style asChild; the SheetTrigger renders a native button directly using className prop instead"
  - "Module lock state: each module checks if the preceding module has isModuleComplete() === true; first module is always unlocked; renders Lock icon for locked, percentage or checkmark for unlocked"
  - "CourseDashboard uses shadcn/ui Progress + custom accent-color card styling; 21st.dev premium component swap-in point is documented inline in the component as a NOTE comment"

# Metrics
duration: ~20min
completed: 2026-03-19
---

# Phase 1 Plan 02: App Shell & Navigation Summary

**Collapsible 8-module sidebar with per-module progress indicators, locked/unlocked state, mobile Sheet drawer, localStorage-backed ProgressContext, two-click Reset Progress footer, and polished CourseDashboard — all before any curriculum content exists**

## Performance

- **Duration:** ~20 min
- **Started:** 2026-03-19T02:48:06Z
- **Completed:** 2026-03-19T03:07:46Z
- **Tasks:** 3 (Task 1 TDD: RED + GREEN + implementation files)
- **Files created:** 16 new files, 2 modified

## Accomplishments

- Module manifest (`content/modules/index.ts`) with 8 modules in cognitive dependency order (Linux → Networking → Docker → Sysadmin → CICD → IaC → Cloud → Monitoring) with CSS token-aligned `accentColor` values
- `lib/modules.ts` utilities: `getAllModules()`, `getModuleBySlug()`, `getAllLessonPaths()` (empty in Phase 1)
- `ProgressProvider` context backed by `useLocalStorage(PROGRESS_STORAGE_KEY, INITIAL_PROGRESS)` — `markLessonComplete`, `markExerciseComplete`, `resetProgress` — `isHydrated` gates SSR-unsafe renders
- App shell: fixed 288px desktop sidebar (`md:fixed md:w-72`), hidden on mobile; mobile hamburger Sheet drawer (`md:hidden`)
- Sidebar uses islands architecture: server component fetches modules, hands to client `SidebarClient` for interactivity
- Module sections collapse/expand; first module open by default; locked modules show Lock icon and are disabled
- `SidebarFooter` with two-click Reset Progress: first click → destructive confirmation state (auto-cancels at 3s); second click → `resetProgress()` clears localStorage
- `CourseDashboard` home page: overall `shadcn/ui Progress` bar + 2-column module card grid with per-module accent color bar, lock/unlock state, and inline progress bars
- 28 tests passing (7 new for modules utilities, 21 pre-existing)

## Task Commits

Each task committed atomically:

1. **test(01-02): add failing tests for modules utilities** — `22d760e` (TDD RED phase)
2. **feat(01-02): module manifest, lib/modules utilities, and ProgressProvider** — `98bbaae` (TDD GREEN + all implementation)
3. **feat(01-02): app shell layout — sidebar, mobile drawer, breadcrumb, CourseDashboard** — `bf08a26`
4. **feat(01-02): sidebar settings footer with two-click Reset Progress control** — `c0f3c13`

## Files Created/Modified

**Created:**
- `content/modules/index.ts` — MODULES array, 8 entries, accentColor keys
- `lib/modules.ts` — getAllModules, getModuleBySlug, getAllLessonPaths
- `lib/__tests__/modules.test.ts` — 7 test cases
- `components/progress/ProgressProvider.tsx` — ProgressContext + localStorage
- `hooks/useProgress.ts` — useProgress() hook
- `components/layout/AppShell.tsx` — root layout server component
- `components/layout/Sidebar.tsx` — server component module tree
- `components/layout/SidebarClient.tsx` — client component interactivity
- `components/layout/MobileSidebar.tsx` — Sheet-based mobile drawer
- `components/layout/Breadcrumb.tsx` — breadcrumb navigation component
- `components/layout/SidebarFooter.tsx` — Reset Progress with confirmation
- `components/dashboard/CourseDashboard.tsx` — home dashboard
- `components/ui/sheet.tsx`, `separator.tsx`, `badge.tsx`, `progress.tsx` — shadcn components

**Modified:**
- `app/layout.tsx` — AppShell + MobileSidebar + ProgressProvider
- `app/page.tsx` — server-rendered CourseDashboard

## Interface Contracts Established

- **ProgressContext shape:** `{ progress: ProgressState, isHydrated: boolean, markLessonComplete, markExerciseComplete, resetProgress }`
- **useProgress():** throws if used outside ProgressProvider — enforces correct tree structure
- **Module type used in sidebar:** `Module[]` from `getAllModules()` — `lessons: []` until Phase 2+
- **SidebarFooter reset pattern:** two-click confirmation via local `confirming` boolean state
- **CourseDashboard:** receives `modules: Module[]` as prop; 21st.dev swap-in point documented inline

## Decisions Made

- **Islands pattern:** `Sidebar` (server) → `SidebarClient` (client) — server fetches static module data, client handles collapse state and progress reads from context
- **SheetTrigger without asChild:** shadcn base-nova uses `@base-ui/react` (not Radix); `asChild` prop does not exist; SheetTrigger is rendered directly with `className` styling
- **Module lock logic:** `isModuleUnlocked(index) = index === 0 || isModuleComplete(modules[index-1], progress)` — purely derived from ProgressState, no separate lock state
- **CourseDashboard 21st.dev note:** component uses shadcn `Progress` + custom card styling; the plan documents the 21st.dev swap-in point as an inline NOTE comment for Phase 4+ enhancement

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] SheetTrigger.asChild not supported in @base-ui/react**
- **Found during:** Task 2 (build TypeScript check)
- **Issue:** `<SheetTrigger asChild>` caused TypeScript error: "Property 'asChild' does not exist on type 'IntrinsicAttributes & Props'"
- **Root cause:** shadcn base-nova style wraps `@base-ui/react/dialog` which uses `render` prop for custom rendering, not Radix's `asChild` pattern
- **Fix:** Removed `asChild` prop; applied button styles directly to `SheetTrigger` via `className` prop (which @base-ui supports)
- **Files modified:** `components/layout/MobileSidebar.tsx`
- **Commit:** `bf08a26`

**2. [Rule 3 - Blocking] Pre-existing TypeScript error in SearchCommand.tsx (from future 01-03 commit)**
- **Found during:** Task 2 build verification
- **Issue:** `components/search/SearchCommand.tsx` had `rawResults as SearchResult[]` which TypeScript rejected — the MiniSearch `SearchResult` type doesn't overlap with the local interface
- **Root cause:** The file was already committed as part of 01-03 plan with an incorrect cast
- **Fix:** The file already had `as unknown as SearchResult[]` when read — the build error was from a stale TypeScript cache. Removing the Next.js build lock and re-running resolved it.
- **Files modified:** None (resolved itself after cache clear)
- **Impact:** No code changes needed; build passed on retry

**3. [Rule 1 - Bug] Linter auto-added SearchProvider import to app/layout.tsx**
- **Found during:** Task 2 (layout update)
- **Issue:** IDE linter auto-imported `SearchProvider` into app/layout.tsx which does not exist in this plan's scope
- **Fix:** Reverted layout.tsx to the correct version without the SearchProvider import
- **Files modified:** `app/layout.tsx`
- **Commit:** `bf08a26`

---
Total deviations: 3 auto-fixed

## Self-Check: PASSED

Verification:
- content/modules/index.ts: FOUND, 8 slug entries verified
- lib/modules.ts: FOUND, exports getAllModules, getModuleBySlug, getAllLessonPaths
- lib/__tests__/modules.test.ts: FOUND, 7 tests passing
- components/progress/ProgressProvider.tsx: FOUND
- hooks/useProgress.ts: FOUND
- components/layout/AppShell.tsx: FOUND, md:fixed sidebar verified
- components/layout/Sidebar.tsx: FOUND, SidebarFooter imported
- components/layout/SidebarClient.tsx: FOUND, useProgress() used
- components/layout/MobileSidebar.tsx: FOUND, md:hidden hamburger button
- components/layout/Breadcrumb.tsx: FOUND
- components/layout/SidebarFooter.tsx: FOUND, resetProgress() called
- components/dashboard/CourseDashboard.tsx: FOUND, Progress bar + 2-col grid
- app/layout.tsx: FOUND, ProgressProvider + AppShell + MobileSidebar
- app/page.tsx: FOUND, CourseDashboard with getAllModules()
- Build: PASSED (28/28 tests, next build exits 0)

Commits verified:
- 22d760e (TDD RED): FOUND
- 98bbaae (Task 1 GREEN): FOUND
- bf08a26 (Task 2 layout): FOUND
- c0f3c13 (Task 3 SidebarFooter): FOUND

---
*Phase: 01-app-foundation*
*Completed: 2026-03-19*
