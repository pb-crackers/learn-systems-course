# Phase 2: Linux Fundamentals - Research

**Researched:** 2026-03-19
**Domain:** MDX lesson content authoring, Docker-based lab environments, shell verification scripting
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Lesson Content Depth & Pedagogical Approach**
- Deep mechanism explanations covering internals (inodes, VFS, syscalls, kernel subsystems) before any commands — matches project core value "understand how machines actually work"
- Each lesson targets 15-25 min reading time — substantial enough for real understanding, not overwhelming
- Every lesson opens with a "Why This Matters" real-world scenario (e.g., "A deploy failed because file permissions blocked the app") — per CONT-08
- Commands and expected output shown together in TerminalBlock components — learner sees what to expect before running it themselves

**Docker Lab Environment Design**
- One shared base image (`learn-systems-linux`) with per-lesson setup scripts — less duplication, faster builds
- Learner launches labs via copy-paste `docker run` command from the lesson using TerminalBlock — simple, teaches Docker basics early
- Shell scripts (`verify.sh`) baked into each container check expected state and print explicit PASS/FAIL feedback — matches success criteria SC-3
- Labs are ephemeral (fresh container each time) — avoids stale state, teaches clean environment discipline

**Content Organization & Module Structure**
- Linear lesson ordering per REQUIREMENTS: computers → OS → filesystem → permissions → processes → shell → scripting → text processing → packages — each builds on the prior
- Cheat sheet (LNX-11) grouped by lesson topic with command + brief description + example — one quick-reference page using the QuickReference component
- Forward references as "coming up in Lesson X" callouts and back-references as prerequisite links — reinforces the progressive structure
- Difficulty progression: first 3 lessons (computers, OS, filesystem) are Foundation; middle 3 (permissions, processes, shell) mix Foundation/Intermediate; last 3 (scripting, text, packages) are Intermediate — matches CONT-07 labels

### Claude's Discretion
- Exact Docker base image selection (Ubuntu, Alpine, etc.) and Dockerfile specifics
- Specific real-world scenarios for each lesson's "Why This Matters" opener
- Depth of kernel internals per lesson (balance thorough with accessible)
- Exercise design specifics (what tasks, what verification checks)
- Callout placement and deep-dive content selection
- verify.sh script implementation details

### Deferred Ideas (OUT OF SCOPE)
- Embedded web-based terminal emulator (INT-01, v2) — for now, learners copy-paste Docker commands
- Interactive quizzes after lessons (INT-02, v2)
- Animated diagrams for kernel/process concepts (INT-03, v2)
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| LNX-01 | Lesson on how computers work — CPU, memory, storage, I/O | MDX template + TerminalBlock patterns for CPU/memory concepts; Docker lab for hands-on exploration |
| LNX-02 | Lesson on what an operating system does — kernel, userspace, system calls | strace, /proc, /sys exploration patterns; Docker provides isolated Linux kernel view |
| LNX-03 | Lesson on the Linux filesystem — hierarchy, mount points, inodes, everything is a file | inode deep-dive via stat, ls -i; mount/findmnt; /proc/mounts patterns |
| LNX-04 | Lesson on file permissions and ownership — users, groups, chmod, chown, sticky bits | chmod numeric/symbolic patterns; umask; sticky bit on /tmp; verify.sh checks with stat |
| LNX-05 | Lesson on processes — PID, fork/exec, process states, signals, ps, top, kill | /proc/[pid]/ exploration; kill -l; ps aux patterns; signal handling in shell |
| LNX-06 | Lesson on shell fundamentals — bash, environment variables, PATH, pipes, redirects | env, export, PATH manipulation; pipe/redirect demos; subshell patterns |
| LNX-07 | Lesson on shell scripting — variables, conditionals, loops, functions, error handling | set -euo pipefail; trap ERR; function patterns; verify.sh itself demonstrates these |
| LNX-08 | Lesson on text processing — grep, sed, awk, sort, uniq, cut, xargs | Pipeline composition patterns; real log file exercises; verify.sh uses these tools |
| LNX-09 | Lesson on package management — apt/yum, repositories, dependencies | Ubuntu apt patterns in Docker; /etc/apt/sources.list; dpkg -l; apt-cache show |
| LNX-10 | Hands-on exercises for each Linux lesson with Docker-based lab environments | Dockerfile + verify.sh patterns; docker run copy-paste commands; PASS/FAIL output format |
| LNX-11 | Module cheat sheet with essential Linux commands and concepts | QuickReference component pattern already established in template |
</phase_requirements>

---

## Summary

Phase 2 is a content-authoring and Docker-infrastructure phase, not a platform phase. The Next.js application framework is fully built. This phase's work is: (1) write 9 MDX lesson files following the established template, (2) build a Dockerfile and per-lesson setup + verify scripts, and (3) update three code integration points so lessons appear in the sidebar, search index, and static routing.

The codebase has strict conventions established in Phase 1. MDX files in `content/modules/01-linux-fundamentals/` are auto-discovered by `getLessonContent()` but the static route generator `getAllLessonPaths()` and the search index route `app/api/search-index/route.ts` both return empty arrays with Phase 1 stubs that must be replaced. The sidebar's `getAllModules()` in `lib/modules.ts` also needs to return populated `lessons[]` arrays — currently it always returns empty arrays. These are the three integration seams Phase 2 must update.

Docker is available on the host (v27.4.0). Ubuntu 22.04 LTS is the correct base image choice: it has `apt`, `bash`, standard utilities pre-installed, is well-known to learners, and matches the exercise environments they will encounter in real work. Alpine is too minimal (uses `ash`, not `bash`; no `ps`, no `top` by default) and would confuse beginners.

**Primary recommendation:** Author MDX files first (they are the critical path for all 9 lessons), wire the three integration seams in a single plan to activate sidebar/search/routing, then build the Docker infrastructure as a focused plan, and deliver the cheat sheet last.

---

## Standard Stack

### Core — No new dependencies needed

Phase 2 adds zero new npm dependencies. All tools were installed in Phase 1.

| Tool | Version | Purpose | Notes |
|------|---------|---------|-------|
| `@next/mdx` | 16.2.0 | Compiles MDX at build time | Already configured in `next.config.ts` |
| `gray-matter` | 4.0.3 | Frontmatter parsing | Used in `lib/mdx.ts` |
| `rehype-pretty-code` | 0.14.3 | Syntax highlighting in code blocks | Configured with `one-dark-pro` theme |
| `remark-gfm` | 4.0.1 | GitHub Flavored Markdown tables, task lists | Already in MDX pipeline |
| Docker | 27.4.0 (host) | Lab environment runtime | Learners need Docker Desktop on macOS |

### Supporting — Docker image

| Image | Tag | Purpose | Why This Choice |
|-------|-----|---------|----------------|
| `ubuntu` | `22.04` | Base for `learn-systems-linux` | LTS, has apt/bash/coreutils/procps pre-installed; matches real-world servers learners will encounter |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `ubuntu:22.04` | `alpine:3.19` | Alpine uses musl libc + ash shell + no procps by default; teaches wrong muscle memory for this course |
| `ubuntu:22.04` | `debian:12` | Debian is fine but Ubuntu has slightly better tooling defaults and is more recognizable to beginners |
| `ubuntu:22.04` | `ubuntu:24.04` | Ubuntu 24.04 changes some defaults (e.g., pip behavior); 22.04 has broader familiarity |

**Installation:** No npm install step needed. Dockerfile will be created under `docker/linux/`.

---

## Architecture Patterns

### Recommended Project Structure additions

```
content/
└── modules/
    └── 01-linux-fundamentals/
        ├── 00-template.mdx          (exists — reference only)
        ├── 01-how-computers-work.mdx
        ├── 02-operating-systems.mdx
        ├── 03-linux-filesystem.mdx
        ├── 04-file-permissions.mdx
        ├── 05-processes.mdx
        ├── 06-shell-fundamentals.mdx
        ├── 07-shell-scripting.mdx
        ├── 08-text-processing.mdx
        ├── 09-package-management.mdx
        └── 10-cheat-sheet.mdx

docker/
└── linux/
    ├── Dockerfile
    ├── setup/
    │   ├── 01-computers.sh
    │   ├── 02-os.sh
    │   ├── 03-filesystem.sh
    │   ├── 04-permissions.sh
    │   ├── 05-processes.sh
    │   ├── 06-shell.sh
    │   ├── 07-scripting.sh
    │   ├── 08-text-processing.sh
    │   └── 09-packages.sh
    └── verify/
        ├── 01-computers.sh
        ├── 02-os.sh
        ├── 03-filesystem.sh
        ├── 04-permissions.sh
        ├── 05-processes.sh
        ├── 06-shell.sh
        ├── 07-scripting.sh
        ├── 08-text-processing.sh
        └── 09-packages.sh
```

### Pattern 1: MDX Lesson File Structure

Every lesson MDX file must follow this exact structure. The frontmatter fields are validated by `extractFrontmatter()` — missing any required field throws at build time.

```mdx
---
title: "How Computers Work"
description: "CPU, memory, storage, and I/O — the physical foundation everything else runs on"
module: "Linux Fundamentals"
moduleSlug: "01-linux-fundamentals"
lessonSlug: "01-how-computers-work"
order: 1
difficulty: "Foundation"
estimatedMinutes: 20
prerequisites: []
tags: ["hardware", "cpu", "memory", "storage"]
---

## Overview
...

## How It Works
...

<Callout type="deep-dive" title="Under the Hood">
...
</Callout>

## Hands-On Exercise

<ExerciseCard
  title="..."
  difficulty="Foundation"
  scenario="..."
  objective="..."
  steps={[...]}
>
  <VerificationChecklist title="Verify Your Work" items={[...]} />
</ExerciseCard>

## Quick Reference

<QuickReference sections={[...]} />
```

Required frontmatter fields (from `lib/mdx.ts`):
`title`, `description`, `module`, `moduleSlug`, `lessonSlug`, `order`, `difficulty`, `estimatedMinutes`, `prerequisites`, `tags`

### Pattern 2: Integration Seam Updates (three files)

Three existing stubs must be updated when MDX files are added. These are explicitly called out in the source code comments.

**`lib/modules.ts` — populate lessons from filesystem**

The current `getAllModules()` always returns `lessons: []`. It must be updated to scan MDX files and return populated `Lesson[]` arrays. The sidebar, progress percentages, and module-unlock logic all depend on this.

```typescript
// lib/modules.ts — updated for Phase 2
import fs from 'fs'
import path from 'path'
import matter from 'gray-matter'
import type { Module, Lesson } from '@/types/content'
import { MODULES } from '@/content/modules/index'

function getLessonsForModule(moduleSlug: string): Lesson[] {
  const dir = path.join(process.cwd(), 'content', 'modules', moduleSlug)
  if (!fs.existsSync(dir)) return []
  return fs
    .readdirSync(dir)
    .filter((f) => f.endsWith('.mdx') && !f.startsWith('00-'))
    .sort()
    .map((file) => {
      const raw = fs.readFileSync(path.join(dir, file), 'utf-8')
      const { data } = matter(raw)
      const slug = data.lessonSlug as string
      return {
        id: `${moduleSlug}/${slug}`,
        slug,
        moduleSlug,
        frontmatter: data as any,
      }
    })
}

export function getAllModules(): Module[] {
  return MODULES.map((mod) => ({
    ...mod,
    lessons: getLessonsForModule(mod.slug),
  }))
}
```

**`lib/modules.ts` — getAllLessonPaths**

```typescript
export function getAllLessonPaths(): { moduleSlug: string; lessonSlug: string }[] {
  return getAllModules().flatMap((mod) =>
    mod.lessons.map((lesson) => ({
      moduleSlug: mod.slug,
      lessonSlug: lesson.slug,
    }))
  )
}
```

**`app/api/search-index/route.ts` — populate search corpus**

The Phase 1 comment explicitly says: "When Phase 2+ adds MDX content, this route will dynamically scan content/modules/**/*.mdx".

```typescript
// app/api/search-index/route.ts — updated for Phase 2
import fs from 'fs'
import path from 'path'
import matter from 'gray-matter'
import { NextResponse } from 'next/server'
import { buildSearchIndex, type SearchDoc } from '@/lib/search'

export const dynamic = 'force-static'

export async function GET() {
  const contentDir = path.join(process.cwd(), 'content', 'modules')
  const docs: SearchDoc[] = []

  for (const moduleDir of fs.readdirSync(contentDir)) {
    const modPath = path.join(contentDir, moduleDir)
    if (!fs.statSync(modPath).isDirectory()) continue
    for (const file of fs.readdirSync(modPath).filter((f) => f.endsWith('.mdx') && !f.startsWith('00-'))) {
      const raw = fs.readFileSync(path.join(modPath, file), 'utf-8')
      const { data, content } = matter(raw)
      docs.push({
        id: `${data.moduleSlug}/${data.lessonSlug}`,
        title: data.title,
        module: data.module,
        moduleSlug: data.moduleSlug,
        body: content.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim(),
      })
    }
  }

  const index = buildSearchIndex(docs)
  return NextResponse.json(index, {
    headers: { 'Cache-Control': 'public, max-age=3600, stale-while-revalidate=86400' },
  })
}
```

### Pattern 3: Docker Lab Architecture

**Dockerfile** — single base image, all lessons' tools installed once:

```dockerfile
FROM ubuntu:22.04

# Prevent interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Install all tools needed across all Linux lessons
RUN apt-get update && apt-get install -y \
    # LNX-05 processes
    procps \
    # LNX-08 text processing
    gawk \
    # LNX-09 package management exploration
    apt-utils \
    # General utilities
    curl wget vim nano less tree \
    && rm -rf /var/lib/apt/lists/*

# Copy all lesson verification scripts
COPY verify/ /usr/local/lib/learn-systems/verify/
COPY setup/ /usr/local/lib/learn-systems/setup/
RUN chmod +x /usr/local/lib/learn-systems/verify/*.sh \
             /usr/local/lib/learn-systems/setup/*.sh

WORKDIR /home/student
CMD ["/bin/bash"]
```

**Per-lesson docker run command pattern** — shown in each lesson via TerminalBlock:

```
docker run --rm -it learn-systems-linux bash /usr/local/lib/learn-systems/setup/03-filesystem.sh
```

**verify.sh pattern** — baked-in, run from inside the container:

```bash
#!/usr/bin/env bash
# verify/04-permissions.sh
set -euo pipefail

PASS=0
FAIL=0

check() {
  local desc="$1"
  local cmd="$2"
  if eval "$cmd" &>/dev/null; then
    echo "  PASS: $desc"
    ((PASS++))
  else
    echo "  FAIL: $desc"
    ((FAIL++))
  fi
}

echo "=== Verifying: File Permissions Exercise ==="
check "test file exists at /tmp/exercise/secret.txt" "[ -f /tmp/exercise/secret.txt ]"
check "secret.txt is owner-read-only (600)" "[ \$(stat -c '%a' /tmp/exercise/secret.txt) = '600' ]"
check "scripts/ directory is executable by owner" "[ -x /tmp/exercise/scripts ]"

echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "RESULT: PASS — All $PASS checks passed."
else
  echo "RESULT: FAIL — $FAIL of $((PASS + FAIL)) checks failed."
  exit 1
fi
```

Learner runs from inside container:
```
bash /usr/local/lib/learn-systems/verify/04-permissions.sh
```

### Pattern 4: Lesson Prerequisite Chain

The `prerequisites` frontmatter field takes `LessonId[]` values. Phase 2 establishes the full chain:

```
LNX-01: prerequisites: []
LNX-02: prerequisites: ["01-linux-fundamentals/01-how-computers-work"]
LNX-03: prerequisites: ["01-linux-fundamentals/02-operating-systems"]
LNX-04: prerequisites: ["01-linux-fundamentals/03-linux-filesystem"]
LNX-05: prerequisites: ["01-linux-fundamentals/04-file-permissions"]
LNX-06: prerequisites: ["01-linux-fundamentals/05-processes"]
LNX-07: prerequisites: ["01-linux-fundamentals/06-shell-fundamentals"]
LNX-08: prerequisites: ["01-linux-fundamentals/07-shell-scripting"]
LNX-09: prerequisites: ["01-linux-fundamentals/06-shell-fundamentals"]
```

LNX-09 (packages) depends on shell fundamentals (LNX-06), not scripting — a learner needs to run commands, not write scripts, to understand package management.

The `PrerequisiteBanner` component already reads these IDs and checks progress context — no code changes needed.

### Anti-Patterns to Avoid

- **Skipping 00- prefix exclusion**: The template file `00-template.mdx` uses order: 0. Any glob of MDX files must exclude `00-` prefixed files or the template will appear as a lesson in the sidebar.
- **Using `order: 0` for real lessons**: Order 0 is reserved for the template. Real lessons start at order 1.
- **Exporting frontmatter from MDX**: `getLessonContent()` uses `gray-matter` on the raw file, not MDX exports. Don't add `export const frontmatter = ...` to MDX files — it is not the pattern used here.
- **Interactive apt operations in Dockerfile**: Always set `ENV DEBIAN_FRONTEND=noninteractive` before any `apt-get` call to prevent build hangs.
- **Mutable container state between exercises**: Each exercise uses `--rm` flag for ephemeral containers. Learners cannot rely on state from a previous run — this is by design.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Frontmatter parsing | Custom regex parser | `gray-matter` (already in project) | Handles edge cases: multi-line values, YAML types, special characters |
| Syntax highlighting | Custom PrismJS config | `rehype-pretty-code` (already configured) | Handles line numbers, diff highlighting, filename headers out of box |
| Reading time estimate | Word count / 200 wpm | `reading-time` (already in project) | Handles code blocks, MDX tags correctly |
| PASS/FAIL exit codes | Custom logic | `exit 1` on failure in verify.sh | Shell convention; Docker exit code propagates to host |
| MDX component registry | Per-file imports | `mdx-components.tsx` global registry | Already wired — `Callout`, `ExerciseCard`, etc. available in all MDX files without imports |

**Key insight:** Phase 2 is almost entirely content work. The platform is built. The trap is treating this as a platform phase and over-engineering the Docker infrastructure. Simple Dockerfile + shell scripts is correct.

---

## Common Pitfalls

### Pitfall 1: Static Params Not Updated

**What goes wrong:** New MDX files exist, but lessons 404 because `generateStaticParams()` in `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` calls `getAllLessonPaths()`, which still returns `[]` from Phase 1.

**Why it happens:** The Phase 1 stub was intentional and documented; forgetting to update it is an easy miss.

**How to avoid:** The integration seam update plan (02-02 or 02-03) must include updating `getAllLessonPaths()` alongside the MDX files. Test by running `next build` — missing static params cause 404s in production.

**Warning signs:** Lesson URL returns 404; sidebar shows "Coming soon..." despite MDX files existing.

### Pitfall 2: Template File Appears as Lesson

**What goes wrong:** `00-template.mdx` appears in the sidebar with order 0, breaking the lesson list.

**Why it happens:** Glob patterns that match `*.mdx` without excluding `00-` prefixed files.

**How to avoid:** Any file scan must include: `.filter((f) => f.endsWith('.mdx') && !f.startsWith('00-'))`. The `order` field in the template is 0, which also signals exclusion.

**Warning signs:** Sidebar shows "Lesson Title Here" as first item in Linux Fundamentals.

### Pitfall 3: Docker Build on ARM64 (Apple Silicon)

**What goes wrong:** `docker build` uses the host platform (arm64), but some apt packages behave slightly differently. Most common Ubuntu packages are fine, but any binary downloaded via `curl` in a RUN step must specify architecture.

**Why it happens:** macOS hosts with M1/M2/M3 chips are arm64; Docker Desktop runs arm64 containers by default.

**How to avoid:** Ubuntu 22.04 has full arm64 support. Use `apt-get install` for all tools (not manual binary downloads). If cross-platform build is needed: `docker build --platform linux/amd64`. For this course, native arm64 is fine.

**Warning signs:** `exec format error` when running a binary installed via curl; commands missing from PATH.

### Pitfall 4: MDX JSX Prop Type Mismatch

**What goes wrong:** TypeScript build error in MDX file because a JSX prop doesn't match the component's TypeScript type.

**Why it happens:** MDX files are compiled as TSX. `ExerciseCard` requires `difficulty: Difficulty` which is `'Foundation' | 'Intermediate' | 'Challenge'`. Passing `difficulty="foundation"` (lowercase) causes a TS error.

**How to avoid:** Copy exact string values from the type definition. Difficulty values are: `"Foundation"`, `"Intermediate"`, `"Challenge"` — PascalCase.

**Warning signs:** `next build` fails with "Type string is not assignable to type Difficulty".

### Pitfall 5: Search Index Still Empty After Adding MDX

**What goes wrong:** Cmd+K search returns no results for Linux lesson content despite files existing.

**Why it happens:** The search index is a static API route (`force-static`). After updating the route, the built artifact must be regenerated. In dev mode, Next.js may cache the old empty response.

**How to avoid:** After updating `app/api/search-index/route.ts`, restart the dev server (`npm run dev`). In production, a fresh `next build` regenerates the static JSON.

**Warning signs:** `/api/search-index` returns `{"documentCount":0}` after MDX files are added.

### Pitfall 6: verify.sh Scripts Assuming Tools Not in Base Image

**What goes wrong:** `verify.sh` calls `stat`, `awk`, `sort`, etc. — but the container doesn't have them installed.

**Why it happens:** `ubuntu:22.04` includes most coreutils but not everything. `procps` (provides `ps`, `top`) must be explicitly installed. `gawk` vs `mawk` behavior differences.

**How to avoid:** The Dockerfile must explicitly install `procps` for LNX-05 exercises. Prefer `bash` built-ins over external tools in verify.sh where possible. Test verify.sh inside a fresh container before baking it in.

**Warning signs:** `verify.sh: line X: stat: command not found` inside container.

---

## Code Examples

Verified from Phase 1 codebase:

### Frontmatter with prerequisites

```mdx
---
title: "File Permissions and Ownership"
description: "Users, groups, chmod, chown, sticky bits — controlling who can do what"
module: "Linux Fundamentals"
moduleSlug: "01-linux-fundamentals"
lessonSlug: "04-file-permissions"
order: 4
difficulty: "Foundation"
estimatedMinutes: 22
prerequisites: ["01-linux-fundamentals/03-linux-filesystem"]
tags: ["permissions", "chmod", "chown", "users", "groups"]
---
```

### TerminalBlock for Docker launch command

```mdx
<TerminalBlock
  title="Launch the lab"
  lines={[
    { type: 'comment', content: 'Build the image once (takes ~30 seconds)' },
    { type: 'command', content: 'docker build -t learn-systems-linux docker/linux/' },
    { type: 'comment', content: 'Start the permissions lab' },
    { type: 'command', content: 'docker run --rm -it learn-systems-linux bash /usr/local/lib/learn-systems/setup/04-permissions.sh' },
    { type: 'output', content: 'Lab ready. You are in /home/student' },
  ]}
/>
```

### TerminalBlock for verification

```mdx
<TerminalBlock
  title="Run verification"
  lines={[
    { type: 'command', content: 'bash /usr/local/lib/learn-systems/verify/04-permissions.sh' },
    { type: 'output', content: '=== Verifying: File Permissions Exercise ===' },
    { type: 'output', content: '  PASS: test file exists at /tmp/exercise/secret.txt' },
    { type: 'output', content: '  PASS: secret.txt is owner-read-only (600)' },
    { type: 'output', content: '' },
    { type: 'output', content: 'RESULT: PASS — All 2 checks passed.' },
  ]}
/>
```

### Callout usage in mechanism section

```mdx
<Callout type="deep-dive" title="Inodes Under the Hood">
When you run `ls -la`, the kernel doesn't read filenames directly from the inode.
Filenames live in *directory entries* (dentries) which map name → inode number.
The inode itself stores: permissions, owner UID/GID, timestamps, file size,
and block pointers. This separation is why hard links work — two directory entries
can point to the same inode number.
</Callout>

<Callout type="warning">
`rm` decrements the inode's link count by 1. The data blocks are only freed when
the link count reaches 0 AND no process has the file open. A running process can
keep a "deleted" file's data alive in disk until it closes the file descriptor.
</Callout>
```

### verify.sh PASS/FAIL pattern

```bash
#!/usr/bin/env bash
# Portable: works on bash 3.2+ (macOS default) and bash 5 (Ubuntu)
set -euo pipefail

PASS=0
FAIL=0

check() {
  local desc="$1"
  local result="$2"  # "pass" or "fail"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"
    FAIL=$((FAIL + 1))
  fi
}

# Example check
if [ -f /tmp/exercise/secret.txt ]; then
  check "secret.txt exists" "pass"
else
  check "secret.txt exists — run: touch /tmp/exercise/secret.txt" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
```

Note: Use `$((PASS + 1))` arithmetic, not `((PASS++))` — the latter exits with status 1 when result is 0, which kills the script under `set -e`.

---

## State of the Art

| Old Approach | Current Approach | Relevant To |
|--------------|------------------|-------------|
| MDX files import their own components | Global `mdx-components.tsx` registry | All lesson MDX files — no imports needed |
| `getAllLessonPaths()` returns `[]` (Phase 1 stub) | Filesystem scan returning real paths | Must update in Phase 2 |
| Search index returns empty corpus | Scan MDX files at build time | Must update in Phase 2 |
| `getAllModules()` always returns empty lessons | Returns populated `Lesson[]` from filesystem | Must update in Phase 2 |
| `next dev` (Turbopack) | `next dev --webpack` | rehype-pretty-code incompatible with Turbopack; enforced via package.json scripts |

**Key constraint from Phase 1 decisions:**
- Build scripts use `--webpack` flag: `"dev": "next dev --webpack"` — this is already in `package.json`. Never remove this flag.

---

## Open Questions

1. **Docker build step in development workflow**
   - What we know: Learners need to run `docker build -t learn-systems-linux docker/linux/` once before any lab. The lesson will show this command.
   - What's unclear: Should the image be pushed to Docker Hub so learners can `docker pull` instead of building locally? Reduces first-lesson friction.
   - Recommendation: For v1, local build is fine and teaches Docker basics. Add a note in the first lesson that the build step is a one-time cost. Pre-built image is a v2 enhancement.

2. **Lesson ordering in sidebar vs. content directory**
   - What we know: `SidebarClient` renders lessons in the order they come from `getAllModules()`. The filesystem scan sorts files alphabetically (`01-`, `02-`, etc.).
   - What's unclear: If `order` frontmatter and filename order diverge, which wins?
   - Recommendation: Always keep filename prefix (01-, 02-) in sync with `order` frontmatter. Use filename sort as the canonical order — it's simpler and prevents bugs.

3. **Cheat sheet lesson slug**
   - What we know: LNX-11 is the module cheat sheet. The template uses `lessonSlug` for routing.
   - What's unclear: Should the cheat sheet be a lesson page at `/modules/01-linux-fundamentals/10-cheat-sheet` or a separate route?
   - Recommendation: Treat it as a regular lesson MDX file (`10-cheat-sheet.mdx`, order: 10) — it drops into the existing routing with zero extra work. Use `difficulty: "Foundation"` and `estimatedMinutes: 5` to signal it's a reference page, not a study lesson.

---

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.0 |
| Config file | `vitest.config.ts` (project root) |
| Quick run command | `npm test` |
| Full suite command | `npm run test:ci` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| LNX-01 through LNX-09 | MDX files render without build errors | smoke | `npm run build` | ❌ Wave 0: MDX files don't exist yet |
| LNX-10 | verify.sh scripts exit 0 on correct state, 1 on incorrect | unit | `bash docker/linux/verify/0N-*.sh` (inside container) | ❌ Wave 0 |
| LNX-11 | Cheat sheet MDX file renders all QuickReference sections | smoke | `npm run build` | ❌ Wave 0 |
| Integration | `getAllLessonPaths()` returns 9 lesson paths after MDX files added | unit | `npm test` | ❌ Wave 0: needs `lib/__tests__/modules.test.ts` |
| Integration | Search index contains 9+ documents after MDX files added | unit | `npm test` | ❌ Wave 0: needs `lib/__tests__/search.test.ts` |
| Integration | Sidebar receives populated lessons from `getAllModules()` | unit | `npm test` | ❌ Wave 0: needs `lib/__tests__/modules.test.ts` |

Note: MDX content correctness (lesson quality, explanation depth) is manual-review-only — not automatable.

### Sampling Rate

- **Per task commit:** `npm test` (unit tests, fast)
- **Per wave merge:** `npm run build` (full build verifies MDX compilation and static params)
- **Phase gate:** Full suite green + manual review of all 9 lessons before `/gsd:verify-work`

### Wave 0 Gaps

- [ ] `lib/__tests__/modules.test.ts` — covers `getAllLessonPaths()` and `getAllModules()` integration seam. Mock the filesystem or use real fixture MDX files.
- [ ] `lib/__tests__/search.test.ts` — covers search index population from MDX content. Mock filesystem with sample MDX frontmatter.
- [ ] Docker verify.sh tests are manual (run inside container) — no automated harness needed for v1.

---

## Sources

### Primary (HIGH confidence)

- Phase 1 codebase — direct inspection of `lib/modules.ts`, `lib/mdx.ts`, `lib/search.ts`, `app/api/search-index/route.ts`, `components/lesson/LessonLayout.tsx`, `components/layout/SidebarClient.tsx`, `mdx-components.tsx`, `content/modules/01-linux-fundamentals/00-template.mdx`, `types/content.ts`, `package.json`, `vitest.config.ts`
- `.planning/phases/02-linux-fundamentals/02-CONTEXT.md` — locked user decisions
- `.planning/REQUIREMENTS.md` — LNX-01 through LNX-11 definitions

### Secondary (MEDIUM confidence)

- Docker version confirmed: `docker --version` → 27.4.0 on host
- Ubuntu 22.04 base image: well-established LTS, `procps` package requirement for `ps`/`top` confirmed from Ubuntu package manifests

### Tertiary (LOW confidence)

- `$((VAR + 1))` vs `((VAR++))` under `set -e` — confirmed by Bash manual behavior; the increment returning 0 triggers `set -e` exit. Verified as a real pitfall.

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all dependencies are already installed; confirmed from package.json
- Architecture: HIGH — integration seams confirmed by reading Phase 1 stubs with explicit "Phase 2+" comments in source
- Pitfalls: HIGH for integration seams (confirmed from source); MEDIUM for Docker arm64 (known macOS behavior)
- Content topics: HIGH — LNX-01 through LNX-09 topics are stable Linux fundamentals; no tool churn risk

**Research date:** 2026-03-19
**Valid until:** 2026-06-19 (stable domain — Linux fundamentals do not change; Next.js 16 MDX pipeline unlikely to change within 90 days)
