---
phase: 01-app-foundation
plan: "01"
subsystem: ui
tags: [nextjs, tailwind, shadcn, mdx, next-themes, vitest, typescript, react]

# Dependency graph
requires: []
provides:
  - Next.js 16.2.0 App Router application compiling with TypeScript
  - Tailwind v4 CSS-first theming with 8 module accent color variables
  - Dark-first ThemeProvider (next-themes) with defaultTheme="dark"
  - Inter + JetBrains Mono fonts via next/font with CSS variable binding
  - "@next/mdx + rehype-pretty-code MDX pipeline (webpack mode)"
  - types/content.ts: Module, Lesson, LessonFrontmatter, LessonId, Difficulty
  - types/progress.ts: ProgressState, LessonProgress, INITIAL_PROGRESS, PROGRESS_STORAGE_KEY
  - lib/progress.ts: moduleCompletionPercent, courseCompletionPercent, isModuleComplete
  - hooks/useLocalStorage.ts: SSR-safe [value, setValue, isHydrated] tuple hook
  - Vitest 4.1.0 test suite with jsdom, React Testing Library, 11 passing tests
affects:
  - 01-02 (navigation shell and layout)
  - 01-03 (MDX content pipeline)
  - 01-04 (lesson page components)
  - all subsequent phases that build on the type system and progress tracking

# Tech tracking
tech-stack:
  added:
    - next@16.2.0
    - react@19.2.4
    - react-dom@19.2.4
    - tailwindcss@4 (CSS-first, no tailwind.config.ts)
    - "@next/mdx@16.2.0"
    - "@mdx-js/loader@3.1.1"
    - "@mdx-js/react@3.1.1"
    - rehype-pretty-code@0.14.3
    - shiki@4.0.2
    - remark-gfm@4.0.1
    - gray-matter@4.0.3
    - reading-time@1.5.0
    - rehype-mermaid@3.0.0
    - minisearch@7.2.0
    - next-themes@0.4.6
    - "@tailwindcss/typography@0.5.19"
    - tw-animate-css@1.4.0
    - clsx@2.1.1
    - tailwind-merge@3.5.0
    - class-variance-authority@0.7.1
    - lucide-react@0.577.0
    - vitest@4.1.0 (plan specified 2.2.0 which no longer exists)
    - "@vitejs/plugin-react@6.0.1"
    - "@testing-library/react@16.3.2"
    - "@testing-library/user-event@14.6.1"
    - "@testing-library/jest-dom@6.6.3"
    - jsdom@25.0.1
  patterns:
    - Tailwind v4 CSS-first configuration (all tokens in @theme inline block in globals.css)
    - Dark-first theming (":root defines dark values, .light overrides to light")
    - next/font font loading with CSS variable binding
    - "@next/mdx for App Router MDX (not next-mdx-remote)"
    - SSR-safe localStorage via useEffect hydration guard
    - Pure function progress calculations in lib/progress.ts
    - Vitest + React Testing Library for unit and component tests

key-files:
  created:
    - mdx-components.tsx (required by @next/mdx; MDX component registry)
    - types/content.ts (Module, Lesson, LessonFrontmatter, LessonId, Difficulty)
    - types/progress.ts (ProgressState, LessonProgress, INITIAL_PROGRESS, PROGRESS_STORAGE_KEY)
    - lib/progress.ts (moduleCompletionPercent, courseCompletionPercent, isModuleComplete)
    - hooks/useLocalStorage.ts (SSR-safe [value, setValue, isHydrated] hook)
    - vitest.config.ts (jsdom env, @/ alias, @vitejs/plugin-react)
    - vitest.setup.ts (@testing-library/jest-dom)
    - hooks/__tests__/useLocalStorage.test.ts (4 test cases)
    - lib/__tests__/progress.test.ts (7 test cases)
  modified:
    - next.config.ts (createMDX with rehype-pretty-code + remark-gfm)
    - app/globals.css (@theme inline with 8 module accent colors, dark-first :root)
    - app/layout.tsx (Inter + JetBrains Mono fonts, ThemeProvider defaultTheme="dark")
    - app/page.tsx (minimal placeholder homepage)
    - package.json (all dependencies, scripts updated with --webpack flag)

key-decisions:
  - "Build/dev scripts use --webpack flag: Next.js 16 defaults to Turbopack which is incompatible with rehype-pretty-code (function serialization error); --webpack flag forces webpack bundler"
  - "vitest@4.1.0 used instead of plan-specified 2.2.0: version 2.2.0 does not exist on npm registry (latest is 4.x)"
  - "shadcn init used --defaults flag selecting base-nova style with @base-ui/react: shadcn 4.0.8 changed default styles; globals.css was completely overwritten with plan-specified dark-first design anyway"
  - "rehype-mermaid omitted from next.config.ts per plan note: requires Playwright/chromium; deferred to Phase 2+ when actual diagram content is authored"

patterns-established:
  - "Dark-first CSS: :root block contains dark values (near-black backgrounds), .light class overrides to light values"
  - "Module accent color naming: --color-module-{slug} CSS variables in @theme inline block"
  - "Font CSS variables: --font-inter and --font-jetbrains-mono bound in @theme inline, applied via font-sans/font-mono utility classes"
  - "useLocalStorage tuple: returns [storedValue, setValue, isHydrated] where isHydrated gates SSR-unsafe renders"
  - "Progress calculations: pure functions operating on Module + ProgressState, no React dependency, easily testable"
  - "Test structure: __tests__/ subdirectory per feature directory (hooks/__tests__, lib/__tests__)"

requirements-completed: [APP-01, APP-02, APP-05]

# Metrics
duration: 6min
completed: 2026-03-19
---

# Phase 1 Plan 01: App Foundation Bootstrap Summary

**Next.js 16.2.0 App Router with Tailwind v4 CSS-first dark theming, @next/mdx pipeline, Inter + JetBrains Mono fonts, full type system for content/progress, SSR-safe useLocalStorage hook, and 11-test Vitest suite**

## Performance

- **Duration:** ~6 min
- **Started:** 2026-03-19T02:38:10Z
- **Completed:** 2026-03-19T02:44:31Z
- **Tasks:** 2
- **Files modified:** 16 (9 created, 7 modified)

## Accomplishments
- Next.js 16.2.0 with TypeScript, Tailwind v4 CSS-first config, and shadcn/ui bootstrapped and compiling
- Dark-first terminal aesthetic: `:root` defines dark values (near-black backgrounds), `.light` overrides; ThemeProvider defaults to dark
- MDX pipeline: `@next/mdx` + rehype-pretty-code + remark-gfm configured with webpack bundler (Turbopack incompatible with function-based rehype plugins)
- Inter and JetBrains Mono fonts via `next/font/google` with CSS variable binding (`--font-inter`, `--font-jetbrains-mono`)
- Full type system: `Module`, `Lesson`, `LessonFrontmatter`, `ProgressState`, `LessonProgress`, `LessonId`, `Difficulty` exported from `types/`
- SSR-safe `useLocalStorage` hook: localStorage reads deferred to `useEffect`, returns `[value, setValue, isHydrated]` tuple
- 11 unit tests passing: 4 for `useLocalStorage` (initial value, hydration read, write, corrupt data recovery), 7 for progress functions (empty module, 0%, 67%, 100%, isModuleComplete variants)

## Task Commits

Each task was committed atomically:

1. **Task 1: Bootstrap Next.js 16 project, install dependencies, configure Tailwind v4 theming and MDX** - `208e5bd` (feat)
2. **Task 2: Create type system, SSR-safe localStorage hook, and Vitest test infrastructure** - `da80a53` (feat)

**Plan metadata:** (docs commit — added after state update)

## Files Created/Modified

- `next.config.ts` - @next/mdx with createMDX(), pageExtensions includes md/mdx
- `mdx-components.tsx` - Required MDX component registry; placeholder for Plan 04 components
- `app/globals.css` - Tailwind v4 @theme inline with 8 module accent colors, dark-first :root
- `app/layout.tsx` - Inter + JetBrains Mono fonts, ThemeProvider defaultTheme="dark" enableSystem
- `app/page.tsx` - Minimal placeholder homepage
- `package.json` - All dependencies installed; scripts updated with --webpack flag
- `types/content.ts` - Module, Lesson, LessonFrontmatter, LessonId, Difficulty, ModuleSlug, LessonSlug
- `types/progress.ts` - ProgressState, LessonProgress, INITIAL_PROGRESS, PROGRESS_STORAGE_KEY
- `lib/progress.ts` - moduleCompletionPercent, courseCompletionPercent, isModuleComplete
- `lib/utils.ts` - cn() utility (created by shadcn init)
- `hooks/useLocalStorage.ts` - SSR-safe generic localStorage hook
- `vitest.config.ts` - jsdom environment, @vitejs/plugin-react, @/ alias
- `vitest.setup.ts` - @testing-library/jest-dom import
- `hooks/__tests__/useLocalStorage.test.ts` - 4 test cases
- `lib/__tests__/progress.test.ts` - 7 test cases

## Decisions Made

- **--webpack build flag required:** Next.js 16 defaulted to Turbopack for all builds, which throws a serialization error with rehype-pretty-code's function-based options. Updated `package.json` build and dev scripts to use `--webpack` flag per the plan's research Pitfall 4.
- **shadcn init selected base-nova style:** shadcn 4.0.8 selected a different style than expected ("base-nova" with `@base-ui/react` rather than Radix-based). The `app/globals.css` was completely overwritten with the plan's dark-first design, making this a non-issue for the theming system.
- **vitest@4.1.0 vs 2.2.0:** Plan specified vitest@2.2.0 which does not exist on npm (jumped from 1.x to 3.x in versioning). Used latest stable (4.1.0).
- **@vitejs/plugin-react@6.0.1 vs 4.3.4:** Plan specified 4.3.4; latest stable is 6.0.1. Used latest.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] vitest@2.2.0 does not exist on npm**
- **Found during:** Task 1 (dependency installation)
- **Issue:** `npm install --save-dev vitest@2.2.0` returned ETARGET — version does not exist (npm jumped from 1.x to 3.x+)
- **Fix:** Installed `vitest@latest` (4.1.0) and `@vitejs/plugin-react@latest` (6.0.1)
- **Files modified:** package.json, package-lock.json
- **Verification:** `npx vitest run` exits 0 with 11 tests passing
- **Committed in:** 208e5bd (Task 1 commit)

**2. [Rule 3 - Blocking] Next.js 16 defaults to Turbopack; incompatible with rehype-pretty-code**
- **Found during:** Task 1 (first build attempt)
- **Issue:** `npx next build` ran with Turbopack by default and threw "loader does not have serializable options" — rehype-pretty-code passes JavaScript functions as plugin options which Turbopack's Rust pipeline cannot serialize
- **Fix:** Added `--webpack` flag to `build` and `dev` scripts in package.json; build passes immediately with webpack
- **Files modified:** package.json
- **Verification:** `npx next build --webpack` exits 0
- **Committed in:** 208e5bd (Task 1 commit)

---

**Total deviations:** 2 auto-fixed (2 blocking)
**Impact on plan:** Both auto-fixes essential for project to build and test. No scope creep. The webpack workaround is consistent with the plan's own research (Pitfall 4: "Use `next dev --no-turbopack`").

## Issues Encountered

- shadcn init 4.0.8 uses "base-nova" style by default (not Radix-based "default" style). This installed `@base-ui/react` instead of standard Radix primitives. Since `app/globals.css` was completely overwritten with the plan's dark-first design anyway, this had no impact on the CSS theming. Future plans should be aware that `components/ui/button.tsx` uses `@base-ui/react` API — if Plan 02 adds shadcn components, verify they use consistent API.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- All foundation types exported and ready for Plan 02 (navigation shell)
- useLocalStorage hook ready for Plan 02 progress context
- MDX pipeline configured; mdx-components.tsx ready for Plan 04 component additions
- Vitest infrastructure ready for additional test files in Plans 02-04
- No blockers for Plan 02

## Self-Check: PASSED

All key files verified present on disk:
- next.config.ts: FOUND
- mdx-components.tsx: FOUND
- app/globals.css: FOUND
- app/layout.tsx: FOUND
- types/content.ts: FOUND
- types/progress.ts: FOUND
- lib/progress.ts: FOUND
- hooks/useLocalStorage.ts: FOUND
- vitest.config.ts: FOUND
- vitest.setup.ts: FOUND

All commits verified:
- 208e5bd (Task 1: Bootstrap Next.js 16 project): FOUND
- da80a53 (Task 2: Type system, hooks, Vitest): FOUND
- 64de28f (docs: complete plan): FOUND

---
*Phase: 01-app-foundation*
*Completed: 2026-03-19*
