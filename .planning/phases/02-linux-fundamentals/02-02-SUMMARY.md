---
phase: 02-linux-fundamentals
plan: "02"
subsystem: content
tags: [mdx, lessons, linux, shell, scripting, text-processing, package-management]
dependency_graph:
  requires: [LNX-05-processes, 01-app-foundation]
  provides: [LNX-06, LNX-07, LNX-08, LNX-09]
  affects: [lesson-pages, sidebar-module-listing, search-index]
tech_stack:
  added: []
  patterns:
    - mechanism-first lesson structure (Overview → How It Works → Hands-On Exercise → Quick Reference)
    - MDX frontmatter read via gray-matter at render time (not compiled into module by @next/mdx)
    - server component passed as children to client component to avoid fs bundling in browser
key_files:
  created:
    - content/modules/01-linux-fundamentals/06-shell-fundamentals.mdx
    - content/modules/01-linux-fundamentals/07-shell-scripting.mdx
    - content/modules/01-linux-fundamentals/08-text-processing.mdx
    - content/modules/01-linux-fundamentals/09-package-management.mdx
  modified:
    - lib/mdx.ts
    - app/layout.tsx
    - components/layout/MobileSidebar.tsx
decisions:
  - "lib/mdx.ts: frontmatter read via gray-matter/fs.readFileSync at runtime — @next/mdx does not export frontmatter from compiled MDX modules"
  - "MobileSidebar: accepts children instead of importing Sidebar directly — prevents fs module bundling into client component graph"
metrics:
  duration: 12min
  completed: "2026-03-19"
  tasks_completed: 2
  files_created: 4
  files_modified: 3
---

# Phase 02 Plan 02: Shell, Scripting, Text Processing, Package Management Summary

4 MDX lesson files for the second half of the Linux Fundamentals module: shell environment internals (PATH algorithm, pipes as concurrent processes, redirect file-descriptor model), bash scripting patterns (set -euo pipefail, trap ERR cleanup, function return semantics), Unix text processing pipeline composition (grep/sed/awk/sort/uniq/cut/xargs), and the apt/dpkg two-layer package architecture.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Shell fundamentals and shell scripting | 7dcebbb | 06-shell-fundamentals.mdx, 07-shell-scripting.mdx, lib/mdx.ts, app/layout.tsx, MobileSidebar.tsx |
| 2 | Text processing and package management | 4e615e4 | 08-text-processing.mdx, 09-package-management.mdx |

## Verification

- Build passes with 21 static pages (18 before + 3 new lesson pages for lessons 07, 08, 09)
- All 4 lessons discoverable via generateStaticParams (scans content/modules/**/*.mdx)
- Prerequisite chain verified: 06→05-processes, 07→06, 08→07, 09→06 (not 07, per RESEARCH.md)
- All 4 lessons: difficulty "Intermediate", ExerciseCard with real-world scenario, VerificationChecklist, QuickReference

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed MobileSidebar client/server boundary causing fs module bundling error**
- **Found during:** Task 1 — first build attempt after adding lesson files
- **Issue:** `MobileSidebar` (a `'use client'` component) imported `Sidebar` directly. When webpack bundled the client component graph, it followed imports into `lib/modules.ts` which uses `import fs from 'fs'`. Browser bundles cannot include Node.js `fs` module — build failed with "Module not found: Can't resolve 'fs'".
- **Root cause:** The Phase 1 build succeeded because `lib/modules.ts` was a stub with no `fs` import. Plan 02-01 rewrote it to use `fs` for actual MDX scanning. The client/server boundary violation became a build failure only when real lesson files were added.
- **Fix:** Changed `MobileSidebar` to accept `children: React.ReactNode` instead of importing `Sidebar`. Updated `app/layout.tsx` to pass `<Sidebar />` as a child. This is the correct Next.js App Router pattern: server components passed as children to client components never enter the client bundle.
- **Files modified:** `components/layout/MobileSidebar.tsx`, `app/layout.tsx`
- **Commit:** 7dcebbb

**2. [Rule 1 - Bug] Fixed getLessonContent returning undefined frontmatter**
- **Found during:** Task 1 — build succeeded compilation but failed at static page generation with "Cannot read properties of undefined (reading 'moduleSlug')"
- **Issue:** `lib/mdx.ts`'s `getLessonContent` did `const { default: MDXContent, frontmatter } = await import(...)` expecting `frontmatter` to be exported from the MDX module. `@next/mdx` only exports the default React component — it does NOT auto-export frontmatter. The lesson page then called `frontmatter.moduleSlug` on `undefined`.
- **Fix:** Updated `getLessonContent` to read the raw MDX file with `fs.readFileSync` and extract frontmatter via the existing `extractFrontmatter` function (gray-matter). Returns `{ default: mod.default, frontmatter }` with frontmatter from the filesystem read.
- **Files modified:** `lib/mdx.ts`
- **Commit:** 7dcebbb

## Decisions Made

1. **@next/mdx frontmatter pattern:** Frontmatter is extracted at render time via `gray-matter` on the raw file, not from the compiled module. This is the correct approach since `@next/mdx` does not export frontmatter — that requires `remark-frontmatter` + `remark-mdx-frontmatter` plugins which are not in the project's dependencies.

2. **MobileSidebar children pattern:** Server components are passed as children to client components, never imported directly inside them. This prevents Node.js server APIs (`fs`, `path`) from entering the webpack client bundle.

## Self-Check: PASSED

- FOUND: 06-shell-fundamentals.mdx
- FOUND: 07-shell-scripting.mdx
- FOUND: 08-text-processing.mdx
- FOUND: 09-package-management.mdx
- FOUND commit: 7dcebbb (task 1)
- FOUND commit: 4e615e4 (task 2)
