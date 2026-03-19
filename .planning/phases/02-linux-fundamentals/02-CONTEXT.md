# Phase 2: Linux Fundamentals - Context

**Gathered:** 2026-03-19
**Status:** Ready for planning

<domain>
## Phase Boundary

Write all Linux Fundamentals lesson content (LNX-01 through LNX-09), build Docker-based lab environments with automated verification for each lesson (LNX-10), and create the module cheat sheet (LNX-11). This phase produces curriculum content that drops into the content framework established in Phase 1 — no platform changes.

</domain>

<decisions>
## Implementation Decisions

### Lesson Content Depth & Pedagogical Approach
- Deep mechanism explanations covering internals (inodes, VFS, syscalls, kernel subsystems) before any commands — matches project core value "understand how machines actually work"
- Each lesson targets 15-25 min reading time — substantial enough for real understanding, not overwhelming
- Every lesson opens with a "Why This Matters" real-world scenario (e.g., "A deploy failed because file permissions blocked the app") — per CONT-08
- Commands and expected output shown together in TerminalBlock components — learner sees what to expect before running it themselves

### Docker Lab Environment Design
- One shared base image (`learn-systems-linux`) with per-lesson setup scripts — less duplication, faster builds
- Learner launches labs via copy-paste `docker run` command from the lesson using TerminalBlock — simple, teaches Docker basics early
- Shell scripts (`verify.sh`) baked into each container check expected state and print explicit PASS/FAIL feedback — matches success criteria SC-3
- Labs are ephemeral (fresh container each time) — avoids stale state, teaches clean environment discipline

### Content Organization & Module Structure
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

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- 6 content components ready: CodeBlock (syntax highlight + copy), TerminalBlock (macOS-style terminal), ExerciseCard (expandable + difficulty), VerificationChecklist (pass/fail + hints), Callout (tip/warning/deep-dive), QuickReference (command table)
- LessonLayout server component: ScrollProgressBar, breadcrumb, lesson header, PrerequisiteBanner, MDX prose, MarkCompleteButton
- MDX pipeline: extractFrontmatter(), getReadingTime(), getLessonContent()
- MiniSearch index for client-side full-text search
- Progress tracking: useProgress hook, ProgressProvider, localStorage persistence
- Lesson template at content/modules/01-linux-fundamentals/00-template.mdx

### Established Patterns
- MDX frontmatter: title, description, module, moduleSlug, lessonSlug, order, difficulty, estimatedMinutes, prerequisites, tags
- Lesson section ordering: Overview → How It Works → Hands-On Exercise → Verification → Quick Reference
- Module routing: app/modules/[moduleSlug]/[lessonSlug]/page.tsx
- Content directory: content/modules/01-linux-fundamentals/

### Integration Points
- New MDX files drop into content/modules/01-linux-fundamentals/ and are auto-discovered
- Module index at content/modules/index.ts needs module metadata
- Sidebar auto-populates from module/lesson discovery
- Progress tracking hooks into lesson completion via MarkCompleteButton
- Search index rebuilds from all MDX content

</code_context>

<specifics>
## Specific Ideas

- "Explain the mechanism before the command" is the core teaching pattern — every lesson must have thorough How It Works before any hands-on
- Docker labs must work on macOS (Darwin) host — containers provide the Linux environment
- Verification scripts give explicit PASS/FAIL — no ambiguity about whether the learner succeeded
- Real-world scenarios are critical differentiator — no toy examples per PROJECT.md
- Content should feel like learning from a senior engineer, not reading a textbook

</specifics>

<deferred>
## Deferred Ideas

- Embedded web-based terminal emulator (INT-01, v2) — for now, learners copy-paste Docker commands
- Interactive quizzes after lessons (INT-02, v2)
- Animated diagrams for kernel/process concepts (INT-03, v2)

</deferred>

---

*Phase: 02-linux-fundamentals*
*Context gathered: 2026-03-19*
