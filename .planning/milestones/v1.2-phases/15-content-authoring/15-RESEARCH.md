# Phase 15: Content Authoring - Research

**Researched:** 2026-03-22
**Domain:** MDX content authoring — quiz question writing and file editing
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- Question difficulty matches lesson difficulty tier — Foundation tests basic recall, Intermediate tests application, Challenge tests synthesis
- Distractors are plausible but clearly wrong — common misconceptions or adjacent concepts, not obviously absurd
- Explanations are 2-3 sentences explaining WHY the correct answer is right — reinforce the mechanism, not just restate the fact
- Questions scoped to that specific lesson only — never test content from other lessons or modules
- 7-10 questions per lesson quiz (per QUIZ-01 requirement)
- One plan per module (8 plans total) — each plan authors all lessons in that module
- tsc --noEmit after each module to catch type errors early
- 01-how-computers-work already has 3 test questions from Phase 14 — replace with full 7-10 question quiz

### Claude's Discretion

- Exact question wording and topic selection within each lesson's content
- Number of questions per quiz within the 7-10 range
- Order of questions within each quiz
- Specific distractor choices

### Deferred Ideas (OUT OF SCOPE)

None — discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| DATA-03 | All 56 lessons have quiz data with 7-10 questions covering key concepts and commands | Full lesson inventory documented below; quiz format and ID conventions established; 57 files confirmed (see lesson count note) |
</phase_requirements>

---

## Summary

Phase 15 is pure content authoring — no infrastructure changes, no new dependencies, no architectural decisions. The only work is appending `export const quiz = [...]` arrays to 57 MDX lesson files (56 per REQUIREMENTS.md, but the actual file count is 57 — see Lesson Count Note below). One file (`01-how-computers-work`) already has 3 placeholder questions that must be replaced with a full 7-10 question quiz.

The TypeScript schema is locked (`QuizQuestion` interface with `id`, `question`, `options: [string,string,string,string]`, `correctIndex: 0|1|2|3`, `explanation`). The quiz export format does NOT require a type annotation or import in the MDX file — the reference lesson uses an untyped array literal and the runtime guard in `getLessonContent` handles type extraction. The `tsc --noEmit` check is only meaningful for non-test source files; all 146 current TSC errors are confined to test files (`__tests__/`) and are pre-existing, not caused by quiz authoring.

**Primary recommendation:** Author 8 plans, one per module, each appending complete quiz arrays to every lesson in that module. After each module's plan completes, run `tsc --noEmit` to verify zero new non-test errors.

---

## Lesson Count Note

REQUIREMENTS.md states "56 lessons" but the actual file count (excluding `00-template.mdx` and `_exercise-template.mdx`) is **57 files across 8 modules**. The breakdown is 10+8+9+7+5+5+6+7 = 57. This phase should author quizzes for all 57 files. The "56" in requirements appears to be an off-by-one from an earlier module count. The planner should target 57 lessons, not 56.

---

## Lesson Inventory

### Module 01 — Linux Fundamentals (10 lessons, slug: `01-linux-fundamentals`)

| # | Slug | Title | Difficulty | Quiz Status |
|---|------|-------|------------|-------------|
| 1 | `01-how-computers-work` | How Computers Work | Foundation | Has 3 placeholder questions — REPLACE |
| 2 | `02-operating-systems` | What an Operating System Does | Foundation | Missing — CREATE |
| 3 | `03-linux-filesystem` | The Linux Filesystem | Foundation | Missing — CREATE |
| 4 | `04-file-permissions` | File Permissions and Ownership | Foundation | Missing — CREATE |
| 5 | `05-processes` | Processes | Intermediate | Missing — CREATE |
| 6 | `06-shell-fundamentals` | Shell Fundamentals | Intermediate | Missing — CREATE |
| 7 | `07-shell-scripting` | Shell Scripting | Intermediate | Missing — CREATE |
| 8 | `08-text-processing` | Text Processing | Intermediate | Missing — CREATE |
| 9 | `09-package-management` | Package Management | Intermediate | Missing — CREATE |
| 10 | `10-cheat-sheet` | Linux Fundamentals Cheat Sheet | Foundation | Missing — CREATE |

### Module 02 — Networking Foundations (8 lessons, slug: `02-networking`)

| # | Slug | Title | Difficulty | Quiz Status |
|---|------|-------|------------|-------------|
| 1 | `01-how-networks-work` | How Networks Work: From Cables to Packets | Foundation | Missing — CREATE |
| 2 | `02-tcp-ip-stack` | The TCP/IP Stack | Foundation | Missing — CREATE |
| 3 | `03-dns` | DNS: The Internet's Phone Book | Foundation | Missing — CREATE |
| 4 | `04-http-https` | HTTP and HTTPS: How the Web Communicates | Foundation | Missing — CREATE |
| 5 | `05-ssh` | SSH: Secure Remote Access | Intermediate | Missing — CREATE |
| 6 | `06-firewalls` | Firewalls: Controlling Network Traffic | Intermediate | Missing — CREATE |
| 7 | `07-troubleshooting` | Network Troubleshooting | Intermediate | Missing — CREATE |
| 8 | `08-cheat-sheet` | Networking Foundations Cheat Sheet | Foundation | Missing — CREATE |

### Module 03 — Docker & Containerization (9 lessons, slug: `03-docker`)

| # | Slug | Title | Difficulty | Quiz Status |
|---|------|-------|------------|-------------|
| 1 | `01-what-are-containers` | What Are Containers? Namespaces, cgroups, and Overlay FS | Foundation | Missing — CREATE |
| 2 | `02-docker-images` | Docker Images: Layers, Dockerfiles, and the Build Process | Foundation | Missing — CREATE |
| 3 | `03-docker-containers` | Docker Containers: Lifecycle, Exec, Logs, and Resource Limits | Foundation | Missing — CREATE |
| 4 | `04-docker-volumes` | Docker Volumes: Data Persistence Across Container Restarts | Intermediate | Missing — CREATE |
| 5 | `05-docker-networking` | Docker Networking: Container-to-Container Communication | Intermediate | Missing — CREATE |
| 6 | `06-docker-compose` | Docker Compose: Declarative Multi-Service Applications | Intermediate | Missing — CREATE |
| 7 | `07-dockerfile-best-practices` | Dockerfile Best Practices | Intermediate | Missing — CREATE |
| 8 | `08-cheat-sheet` | Docker & Containerization Cheat Sheet | Foundation | Missing — CREATE |
| 9 | `09-foundation-capstone` | Foundation Capstone: Deploy a Dockerized App | Challenge | Missing — CREATE |

### Module 04 — System Administration (7 lessons, slug: `04-sysadmin`)

| # | Slug | Title | Difficulty | Quiz Status |
|---|------|-------|------------|-------------|
| 1 | `01-user-management` | User and Group Management | Foundation | Missing — CREATE |
| 2 | `02-systemd` | systemd: The Modern Linux Init System | Foundation | Missing — CREATE |
| 3 | `03-logging` | Linux Logging: journald, syslog, and Log Rotation | Foundation | Missing — CREATE |
| 4 | `04-disk-management` | Disk Management: Block Devices, Filesystems, and Mounts | Intermediate | Missing — CREATE |
| 5 | `05-scheduling` | Process Scheduling: cron, systemd Timers, and Job Priority | Intermediate | Missing — CREATE |
| 6 | `06-system-monitoring` | System Monitoring: Identifying Resource Bottlenecks | Intermediate | Missing — CREATE |
| 7 | `07-cheat-sheet` | System Administration Cheat Sheet | Foundation | Missing — CREATE |

### Module 05 — CI/CD Pipelines (5 lessons, slug: `05-cicd`)

| # | Slug | Title | Difficulty | Quiz Status |
|---|------|-------|------------|-------------|
| 1 | `01-cicd-concepts` | CI/CD: Automating the Path from Code to Production | Foundation | Missing — CREATE |
| 2 | `02-github-actions` | GitHub Actions: Workflows, Triggers, Jobs, and Steps | Foundation | Missing — CREATE |
| 3 | `03-building-testing` | Building and Testing in Pipelines | Intermediate | Missing — CREATE |
| 4 | `04-deployment-strategies` | Deployment Strategies: Blue/Green, Rolling, and Canary | Intermediate | Missing — CREATE |
| 5 | `05-cheat-sheet` | CI/CD Cheat Sheet and Pipeline Reference | Intermediate | Missing — CREATE |

### Module 06 — Infrastructure as Code (5 lessons, slug: `06-iac`)

| # | Slug | Title | Difficulty | Quiz Status |
|---|------|-------|------------|-------------|
| 1 | `01-iac-concepts` | Infrastructure as Code: Why Declaring Infrastructure Beats Scripting It | Foundation | Missing — CREATE |
| 2 | `02-hcl-basics` | HCL Syntax: Providers, Resources, Variables, and Outputs | Foundation | Missing — CREATE |
| 3 | `03-terraform-state` | Terraform State: How OpenTofu Tracks Your Infrastructure | Intermediate | Missing — CREATE |
| 4 | `04-modules` | Terraform Modules: Reusable Infrastructure Components | Intermediate | Missing — CREATE |
| 5 | `05-cheat-sheet` | Infrastructure as Code Cheat Sheet | Foundation | Missing — CREATE |

### Module 07 — Cloud Fundamentals (6 lessons, slug: `07-cloud`)

| # | Slug | Title | Difficulty | Quiz Status |
|---|------|-------|------------|-------------|
| 1 | `01-cloud-concepts` | Cloud Computing: What It Actually Is | Foundation | Missing — CREATE |
| 2 | `02-compute` | Cloud Compute: VMs, Containers, and Serverless | Foundation | Missing — CREATE |
| 3 | `03-cloud-networking` | Cloud Networking: VPCs, Subnets, and Load Balancers | Intermediate | Missing — CREATE |
| 4 | `04-cloud-storage` | Cloud Storage: Object, Block, and File Storage | Intermediate | Missing — CREATE |
| 5 | `05-iam` | Cloud IAM: Identity, Policies, and Least Privilege | Intermediate | Missing — CREATE |
| 6 | `06-cheat-sheet` | Cloud Fundamentals Cheat Sheet | Foundation | Missing — CREATE |

### Module 08 — Monitoring & Observability (7 lessons, slug: `08-monitoring`)

| # | Slug | Title | Difficulty | Quiz Status |
|---|------|-------|------------|-------------|
| 1 | `01-observability-concepts` | Observability: Metrics, Logs, and Traces | Foundation | Missing — CREATE |
| 2 | `02-prometheus` | Prometheus: How Metrics Collection Actually Works | Foundation | Missing — CREATE |
| 3 | `03-grafana` | Grafana: Building Dashboards That Tell a Story | Intermediate | Missing — CREATE |
| 4 | `04-log-aggregation` | Log Aggregation: Centralizing Logs from Every Service | Intermediate | Missing — CREATE |
| 5 | `05-incident-response` | Incident Response: From Alert to Resolution | Intermediate | Missing — CREATE |
| 6 | `06-cheat-sheet` | Monitoring & Observability Cheat Sheet | Foundation | Missing — CREATE |
| 7 | `07-advanced-capstone` | Advanced Capstone: Full-Stack Monitoring Pipeline | Challenge | Missing — CREATE |

---

## Quiz Export Format

### Canonical Pattern (from `01-how-computers-work.mdx`, established in Phase 14)

The quiz export lives at the **bottom of the MDX file**, after all prose and component JSX.

```mdx
export const quiz = [
  {
    id: 'lesson-slug-q1',
    question: 'Question text here?',
    options: ['Option A', 'Option B', 'Option C', 'Option D'],
    correctIndex: 2,
    explanation: 'Two to three sentences explaining WHY option C is correct — reinforce the mechanism.',
  },
  {
    id: 'lesson-slug-q2',
    question: 'Second question?',
    options: ['Option A', 'Option B', 'Option C', 'Option D'],
    correctIndex: 0,
    explanation: 'Two to three sentences explaining the mechanism.',
  },
]
```

### Critical Format Details

- **No import required** — the export is an untyped array literal; `getLessonContent` extracts it with `Array.isArray(mod.quiz)` and casts to `QuizQuestion[]` at runtime. The CONTEXT.md notation `export const quiz: QuizQuestion[]` is aspirational — the reference lesson does NOT include this type annotation and TypeScript does not type-check MDX named exports through `tsc --noEmit`.
- **ID convention** — use `{lesson-slug}-q{N}` where `{lesson-slug}` is the `lessonSlug` frontmatter value. Example: `01-how-computers-work` → `hw-q1`. The reference uses `hw-q1` (abbreviation), but a consistent pattern like `how-computers-work-q1` is also acceptable.
- **Options are exactly 4 strings** — `QuizQuestion.options` is typed as `[string,string,string,string]` (4-tuple). When TypeScript eventually type-checks these files, a 3- or 5-element array will be a compile error.
- **correctIndex is 0–3** — zero-based index into the options array; value must be exactly 0, 1, 2, or 3.
- **Placement** — the export block goes after the last MDX component (`</QuickReference>`, `</ExerciseCard>`, or equivalent closing tag). It is the last content in the file.
- **01-how-computers-work special case** — this file already has 3 questions with IDs `hw-q1`, `hw-q2`, `hw-q3`. Replace the entire `export const quiz = [...]` block with a new 7-10 question quiz.

---

## Architecture Patterns

### File Editing Pattern

Each quiz is appended to an existing MDX file. The operation per lesson is:

1. Read the lesson's MDX file to understand the topics covered
2. Author 7-10 questions appropriate to the difficulty tier
3. Append the `export const quiz = [...]` block after the final closing JSX tag
4. Verify the file is syntactically valid MDX (no unclosed strings, correct brackets)

### ID Naming Convention

Use the lesson slug as the question prefix. For brevity, abbreviate common prefixes:

| Lesson Slug | Suggested ID Prefix |
|-------------|-------------------|
| `01-how-computers-work` | `hw` |
| `02-operating-systems` | `os` |
| `03-linux-filesystem` | `fs` |
| `04-file-permissions` | `perm` |
| `05-processes` | `proc` |
| `06-shell-fundamentals` | `shell` |
| `07-shell-scripting` | `script` |
| `08-text-processing` | `text` |
| `09-package-management` | `pkg` |
| `10-cheat-sheet` (mod 01) | `linux-ref` |

Alternatively, use the full slug prefix: `how-computers-work-q1`. Either approach is acceptable as long as IDs are unique within each lesson.

### Question Quality Tiers

| Difficulty | What to Test | Example Pattern |
|------------|-------------|-----------------|
| Foundation | Recall: define terms, identify what a tool/concept IS | "What does X do?", "Which command does Y?" |
| Intermediate | Application: predict behavior, select correct tool for scenario | "Given situation X, what would happen?", "Which option achieves Y?" |
| Challenge | Synthesis: combine multiple concepts, diagnose a problem | "Given symptoms X, Y, Z — what is the root cause?", "What is wrong with this config?" |

### Module-Scoping Rule

Each question must test only content from that specific lesson. Do not ask about concepts from other lessons, even within the same module.

---

## TypeScript Verification

### Current State

`tsc --noEmit` currently produces **146 errors** — all in test files (`__tests__/` directories). There are **zero errors in source files**. This is the baseline.

### Post-Quiz Verification Target

After authoring quizzes for a module, run:
```bash
npx tsc --noEmit 2>&1 | grep -v "__tests__\|\.test\.\|\.spec\." | grep "error TS"
```

This command filters out pre-existing test-file errors and shows only errors in source files. The target after each module is zero output from this command.

### What Would Cause Errors

TypeScript does type-check MDX files that contain `export` statements when those files fall under `tsconfig.json` include patterns. The tsconfig includes `**/*.ts` and `**/*.tsx` but NOT `**/*.mdx` — MDX files are compiled by `@next/mdx`, not by `tsc` directly. Therefore, `tsc --noEmit` does NOT validate quiz question structure in MDX files at the language level.

The "zero errors after full authoring" success criterion means: no new source-file errors introduced by the authoring work (which would only happen if a non-MDX file were accidentally edited).

---

## Common Pitfalls

### Pitfall 1: Breaking MDX Syntax with the Export Block

**What goes wrong:** The quiz export contains an unclosed string, unescaped apostrophe in a string, or a mismatched bracket. This breaks the MDX compilation for that lesson entirely — the page renders a build error instead of content.

**Why it happens:** MDX is JSX + Markdown. String literals inside JSX must use valid JS string syntax. Apostrophes inside single-quoted strings will break the parse.

**How to avoid:** Use double-quoted strings throughout the quiz array. Avoid apostrophes in question or option text, or escape them if necessary (`don\'t` → use `do not`).

**Warning signs:** Build error on `next build`, or a lesson page fails to render.

### Pitfall 2: Wrong correctIndex Value

**What goes wrong:** The correctIndex points to the wrong option (off by one, or the option order was rearranged after setting the index).

**Why it happens:** Manual authoring of arrays with positional indexing. Writing options then setting correctIndex, then rearranging options without updating correctIndex.

**How to avoid:** Write the options, identify the correct one, count its zero-based position, set correctIndex last. Do not rearrange options after setting correctIndex.

**Warning signs:** Learners pass quizzes by selecting obviously wrong answers, or correct answers are marked incorrect.

### Pitfall 3: Testing Content Outside the Lesson Scope

**What goes wrong:** A question in lesson 3 asks about content that is only covered in lesson 5.

**Why it happens:** Authors draw on broad knowledge of the domain rather than reading the specific lesson file.

**How to avoid:** Read the lesson's MDX content before authoring questions. Every correct answer must be findable in that lesson's "How It Works" and "Hands-On Exercise" sections.

### Pitfall 4: Trivially Easy Distractors

**What goes wrong:** Distractors are obviously absurd, making the quiz a free pass rather than a retrieval practice exercise.

**Why it happens:** Fast authoring without thinking about what a learner who half-understood the lesson would plausibly believe.

**How to avoid:** Use misconceptions from the lesson's Callout blocks as distractor inspiration. Use adjacent terms from the lesson that sound similar but are not correct answers.

### Pitfall 5: Explanations That Just Restate the Answer

**What goes wrong:** Explanation says "The correct answer is X because X is correct." No mechanism reinforced.

**Why it happens:** Minimal effort explanation writing.

**How to avoid:** Write the explanation by answering "why does this mechanism work this way?" — the same question the lesson's Callout blocks and narrative address. Target 2-3 sentences that teach something.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead |
|---------|-------------|-------------|
| Type-safe quiz validation | Custom validation script | `tsc --noEmit` plus the existing `QuizQuestion` interface in `types/quiz.ts` |
| Quiz rendering | New component | Existing `QuizSection` + `QuizComponent` from Phase 13 — already wired in `LessonLayout` |
| Quiz data extraction | New loader | Existing `getLessonContent` in `lib/mdx.ts` which already extracts `mod.quiz` |
| Progress gating | New logic | Existing `markQuizPassed` / `isLessonComplete` from Phase 12 — already connected in Phase 14 |

**Key insight:** Phase 15 has zero infrastructure work. Every concern about rendering, gating, and data loading is already solved. The only deliverable is MDX content.

---

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.0 |
| Config file | `vitest.config.ts` |
| Quick run command | `npx vitest run` |
| Full suite command | `npx vitest run --reporter=verbose` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DATA-03 | All 57 lesson MDX files export a `quiz` array | smoke | `find content/modules -name "*.mdx" ! -name "00-*" ! -name "_*" -exec grep -l "export const quiz" {} \; \| wc -l` (target: 57) | ❌ Wave 0 |
| DATA-03 | Every quiz has 7-10 questions | manual review | Module-by-module count during authoring | — |
| DATA-03 | tsc --noEmit has zero non-test errors after authoring | type-check | `npx tsc --noEmit 2>&1 \| grep -v "__tests__\|\.test\.\|\.spec\." \| grep "error TS" \| wc -l` (target: 0) | ✅ (command) |

### Sampling Rate

- **Per plan commit:** `npx vitest run` (55 existing tests must remain passing)
- **Per module (after each plan):** `npx tsc --noEmit 2>&1 | grep -v "__tests__\|\.test\." | grep "error TS"` (zero non-test errors)
- **Phase gate:** All 57 files have `export const quiz`, vitest green, zero non-test tsc errors

### Wave 0 Gaps

- [ ] Smoke test script to count `export const quiz` occurrences across all lesson MDX files — covers DATA-03 completeness check. Can be a shell one-liner in the verification plan rather than a new test file.

---

## Code Examples

### Appending a Quiz to a Lesson File

```mdx
{/* ...existing lesson content... */}

</QuickReference>

export const quiz = [
  {
    id: 'os-q1',
    question: 'What is the primary role of the kernel in a modern operating system?',
    options: [
      'Run user applications directly',
      'Manage hardware resources and arbitrate access between processes',
      'Store files on disk',
      'Provide the graphical user interface'
    ],
    correctIndex: 1,
    explanation: 'The kernel is the privileged core of the OS that manages CPU time, memory allocation, and device access. User programs cannot touch hardware directly — they request services from the kernel via system calls, which the kernel validates and executes on their behalf.',
  },
]
```

### Replacing the Existing Placeholder Quiz in `01-how-computers-work`

The existing export block starts at line 260 of that file. The entire block from `export const quiz = [` through the closing `]` must be replaced with a new 7-10 question quiz. Do not leave any orphaned `]` or stray characters.

---

## Sources

### Primary (HIGH confidence)

- Direct file inspection of all 57 MDX lesson files — title, description, difficulty, lessonSlug
- `types/quiz.ts` — `QuizQuestion` interface (id, question, options 4-tuple, correctIndex 0|1|2|3, explanation)
- `lib/mdx.ts` — `getLessonContent` showing `Array.isArray(mod.quiz)` extraction pattern
- `content/modules/01-linux-fundamentals/01-how-computers-work.mdx` — canonical reference for the untyped `export const quiz = [...]` format
- `tsconfig.json` — confirms MDX files are NOT in `include` patterns, explaining why tsc does not directly type-check quiz exports
- `vitest.config.ts` + `package.json` — test framework is Vitest 4.1.0, `npx vitest run` runs all 55 tests currently passing
- `.planning/phases/15-content-authoring/15-CONTEXT.md` — locked authoring decisions
- `.planning/REQUIREMENTS.md` — DATA-03 requirement definition

### Secondary (MEDIUM confidence)

- `npx tsc --noEmit` output — 146 errors confirmed all in `__tests__/` files; zero non-test errors in current codebase

---

## Metadata

**Confidence breakdown:**
- Lesson inventory: HIGH — direct file system scan, all 57 files confirmed with exact slugs and difficulty tiers
- Quiz format: HIGH — confirmed from working reference lesson and type definitions
- TypeScript behavior: HIGH — confirmed by running tsc and examining tsconfig include patterns
- Authoring quality standards: HIGH — locked decisions in CONTEXT.md

**Research date:** 2026-03-22
**Valid until:** 2026-06-22 (content structure is stable; no dependencies on external libraries)
