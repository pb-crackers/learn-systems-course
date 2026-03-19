---
phase: 02-linux-fundamentals
plan: "01"
subsystem: content
tags: [mdx, gray-matter, filesystem-scanning, linux, curriculum]

requires:
  - phase: 01-app-foundation
    provides: "MDX pipeline, LessonLayout, content components (ExerciseCard/VerificationChecklist/Callout/TerminalBlock/QuickReference), lib/mdx.ts, lib/search.ts"

provides:
  - "5 Linux Fundamentals lesson MDX files (LNX-01 through LNX-05)"
  - "lib/modules.ts filesystem-based lesson discovery (getLessonsForModule)"
  - "app/api/search-index/route.ts MDX corpus indexing with gray-matter"
  - "lib/mdx.ts frontmatter extraction fix for @next/mdx without remark-mdx-frontmatter"

affects:
  - 02-linux-fundamentals
  - all future content phases

tech-stack:
  added: []
  patterns:
    - "MDX lesson files: YAML frontmatter parsed by gray-matter server-side, not from @next/mdx compiled module"
    - "Lesson discovery: filesystem scan of content/modules/<slug>/*.mdx, filter out 00-prefixed templates"
    - "Search index: built at build time by scanning all MDX files, stripping JSX tags with regex, returning static JSON"

key-files:
  created:
    - content/modules/01-linux-fundamentals/01-how-computers-work.mdx
    - content/modules/01-linux-fundamentals/02-operating-systems.mdx
    - content/modules/01-linux-fundamentals/03-linux-filesystem.mdx
    - content/modules/01-linux-fundamentals/04-file-permissions.mdx
    - content/modules/01-linux-fundamentals/05-processes.mdx
  modified:
    - lib/modules.ts
    - app/api/search-index/route.ts
    - lib/mdx.ts

key-decisions:
  - "MDX frontmatter extracted via gray-matter fs.readFileSync in getLessonContent() — @next/mdx does not auto-export YAML frontmatter without remark-mdx-frontmatter plugin"
  - "Lesson discovery uses fs.readdirSync filtering .mdx files and excluding 00- prefixed templates; sorted alphabetically"
  - "Search index body text cleaned by stripping JSX tags with regex replace /<[^>]+>/g before indexing"

patterns-established:
  - "Lesson MDX structure: frontmatter → ## Overview (Why This Matters scenario) → ## How It Works (mechanism-first) → ## Hands-On Exercise (ExerciseCard + VerificationChecklist) → ## Quick Reference"
  - "ExerciseCard scenarios use real-world DevOps/SRE contexts, not toy examples"
  - "Callout deep-dive for internals, Callout tip for practical monitoring tie-ins, Callout warning for dangerous operations"

requirements-completed: [LNX-01, LNX-02, LNX-03, LNX-04, LNX-05]

duration: 11min
completed: "2026-03-19"
---

# Phase 2 Plan 1: Linux Fundamentals Lessons 1-5 Summary

**5 mechanism-first Linux lessons (LNX-01 through LNX-05) covering CPU/memory/I/O, kernel/syscalls, filesystem/inodes, file permissions/SUID, and fork/exec/signals — integrated into sidebar and search index via filesystem-scanning lib/modules.ts and gray-matter search index route**

## Performance

- **Duration:** 11 min
- **Started:** 2026-03-19T10:35:58Z
- **Completed:** 2026-03-19T10:46:00Z
- **Tasks:** 2
- **Files modified:** 8

## Accomplishments
- 5 lesson MDX files covering the foundational half of the Linux module, each with mechanism-first "How It Works" section before any commands or exercises
- lib/modules.ts updated to scan the filesystem (getLessonsForModule) so all 5 lessons appear in the sidebar automatically
- app/api/search-index/route.ts updated to index all MDX content with gray-matter, replacing the Phase 1 empty stub
- Prerequisite chain established: LNX-01 → LNX-02 → LNX-03 → LNX-04 → LNX-05
- Build passes clean: 22 static pages generated including all 5 lesson pages

## Task Commits

Each task was committed atomically:

1. **Task 1: Integration seams and lessons LNX-01 through LNX-03** - `886ed4c` (feat)
2. **Task 2: Lessons LNX-04 (permissions) and LNX-05 (processes)** - `77ef356` (feat)

**Plan metadata:** (docs commit — see below)

## Files Created/Modified

- `lib/modules.ts` — getLessonsForModule() scans content/modules/<slug>/*.mdx, returns Lesson[]; getAllModules/getModuleBySlug/getAllLessonPaths use it
- `app/api/search-index/route.ts` — iterates all module directories, parses MDX with gray-matter, builds MiniSearch index from lesson body text
- `lib/mdx.ts` — getLessonContent() now reads raw file for frontmatter extraction since @next/mdx doesn't auto-export YAML frontmatter
- `content/modules/01-linux-fundamentals/01-how-computers-work.mdx` — CPU fetch-decode-execute, memory hierarchy (latency table), HDD vs SSD mechanics, I/O interrupts and DMA
- `content/modules/01-linux-fundamentals/02-operating-systems.mdx` — kernel responsibilities, ring 0 vs ring 3, system call table and mechanism, strace, boot process, /proc and /sys
- `content/modules/01-linux-fundamentals/03-linux-filesystem.mdx` — FHS directory purposes, inodes (no filenames in inodes), hard vs soft links, mount points, everything-is-a-file table, VFS
- `content/modules/01-linux-fundamentals/04-file-permissions.mdx` — UID/GID identity, rwx bits for files vs directories, octal notation table, chmod symbolic and numeric, chown, setuid/setgid/sticky, umask
- `content/modules/01-linux-fundamentals/05-processes.mdx` — process anatomy (PID/PPID/UID/FDs), fork/exec two-step model, PID 1 and container signal handling, process states (R/S/D/T/Z), signals table, kill -0 idiom, job control

## Decisions Made

- **@next/mdx frontmatter**: @next/mdx does not export YAML frontmatter as a named module export without remark-mdx-frontmatter. Rather than install a new plugin, getLessonContent() now reads the raw .mdx file via fs.readFileSync and calls extractFrontmatter(). This is the pattern the original lib/mdx.ts comment already anticipated.
- **Lesson discovery**: Filesystem scan (readdirSync + filter) chosen over a static manifest — adding a new .mdx file to the directory automatically adds it to the sidebar and search index without code changes.
- **Search body cleaning**: JSX component tags are stripped with `/<[^>]+>/g` before indexing. This is approximate but sufficient for full-text search; structured content like TerminalBlock command/output text is preserved as prose.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] lib/mdx.ts getLessonContent() returned undefined frontmatter**
- **Found during:** Task 1 (build verification after writing lessons 1-3)
- **Issue:** Build failed with `TypeError: Cannot read properties of undefined (reading 'moduleSlug')` — the lesson page tried to access `lesson.frontmatter.moduleSlug` but frontmatter was undefined because @next/mdx compiled MDX modules do not export YAML frontmatter as a named export without remark-mdx-frontmatter
- **Fix:** Updated getLessonContent() in lib/mdx.ts to read the raw .mdx file via fs.readFileSync and call extractFrontmatter() for frontmatter, using the dynamic import only for the React component default export
- **Files modified:** lib/mdx.ts
- **Verification:** Build passed — all 5 lesson pages rendered without errors
- **Committed in:** 886ed4c (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (Rule 1 — Bug)
**Impact on plan:** Essential fix — the lesson page architecture requires frontmatter at render time. No scope creep.

## Issues Encountered

- Build process showed intermittent "Another next build process is already running" due to stale lock files from the previous failed build. Resolved by killing stale processes and clearing .next directory.

## User Setup Required

None — no external service configuration required. Docker lab container builds from `docker/linux/` which already exists.

## Next Phase Readiness

- All 5 Linux Fundamentals foundational lessons (LNX-01 through LNX-05) are published and discoverable in the sidebar and search index
- Prerequisite chain wired correctly: LNX-01 → LNX-02 → LNX-03 → LNX-04 → LNX-05
- Lessons 6+ (shell, scripting, text tools, packages) can proceed in Phase 2 Plans 2+
- The filesystem-scanning pattern in lib/modules.ts means future lesson files need no code changes — just add the MDX file to the correct directory

---
*Phase: 02-linux-fundamentals*
*Completed: 2026-03-19*
