---
gsd_state_version: 1.0
milestone: v1.0
milestone_name: milestone
status: executing
stopped_at: Completed 06-infrastructure-as-code-cloud-03-PLAN.md
last_updated: "2026-03-19T14:00:59.409Z"
last_activity: "2026-03-19 — Plan 01-01 complete: Next.js 16 bootstrap, Tailwind v4, MDX pipeline, type system, Vitest"
progress:
  total_phases: 7
  completed_phases: 5
  total_plans: 24
  completed_plans: 22
  percent: 25
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-03-18)

**Core value:** Every lesson must be hands-on and interactive with thorough explanations — the learner practices real skills and understands how machines actually work. Delivered as a modern, production-ready Next.js web application.
**Current focus:** Phase 1 — App Foundation

## Current Position

Phase: 1 of 7 (App Foundation)
Plan: 1 of 4 in current phase
Status: In progress
Last activity: 2026-03-19 — Plan 01-01 complete: Next.js 16 bootstrap, Tailwind v4, MDX pipeline, type system, Vitest

Progress: [███░░░░░░░] 25%

## Performance Metrics

**Velocity:**
- Total plans completed: 1
- Average duration: 6min
- Total execution time: 6min

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 01-app-foundation | 1/4 | 6min | 6min |

**Recent Trend:**
- Last 5 plans: 01-01 (6min)
- Trend: Baseline established

*Updated after each plan completion*
| Phase 01-app-foundation P03 | 18min | 2 tasks | 14 files |
| Phase 01-app-foundation P02 | 20min | 3 tasks | 16 files |
| Phase 01-app-foundation P04 | 14min | 2 tasks | 16 files |
| Phase 02-linux-fundamentals P02 | 12min | 2 tasks | 7 files |
| Phase 02-linux-fundamentals P01 | 11min | 2 tasks | 8 files |
| Phase 02-linux-fundamentals P04 | 5min | 1 tasks | 1 files |
| Phase 02-linux-fundamentals P03 | 5min | 2 tasks | 19 files |
| Phase 03-networking-foundations P01 | 6min | 2 tasks | 3 files |
| Phase 03-networking-foundations P02 | 7min | 2 tasks | 4 files |
| Phase 03-networking-foundations P04 | 4min | 1 tasks | 1 files |
| Phase 03-networking-foundations P03 | 4min | 2 tasks | 22 files |
| Phase 04-docker-foundation-capstone P01 | 7min | 2 tasks | 7 files |
| Phase 04-docker-foundation-capstone P02 | 9min | 2 tasks | 5 files |
| Phase 04-docker-foundation-capstone P03 | 12min | 2 tasks | 9 files |
| Phase 04-docker-foundation-capstone P04 | 5min | 2 tasks | 8 files |
| Phase 05-system-administration-ci-cd P03 | 7min | 2 tasks | 4 files |
| Phase 05-system-administration-ci-cd P01 | 9min | 2 tasks | 6 files |
| Phase 05-system-administration-ci-cd P04 | 2min | 2 tasks | 2 files |
| Phase 05-system-administration-ci-cd P02 | 10min | 2 tasks | 16 files |
| Phase 06-infrastructure-as-code-cloud P01 | 5 | 2 tasks | 4 files |
| Phase 06-infrastructure-as-code-cloud P03 | 7min | 2 tasks | 5 files |

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- Roadmap: Standard granularity yields 7 phases — app foundation first, then modules in cognitive dependency order (Linux → Networking → Docker → Sysadmin/CICD → IaC/Cloud → Monitoring), capstones placed after their respective tiers
- Roadmap: CAP-01 (foundation capstone) placed in Phase 4 with Docker module (after the three foundation modules are complete); CAP-02 placed in Phase 7 with monitoring
- Roadmap: SYS + CICD combined in Phase 5 per research — sysadmin context (systemd, services) directly informs what CI/CD pipelines are doing when they deploy
- Roadmap: IAC + CLD combined in Phase 6 — cloud fundamentals are lightweight in a local-first course when learners already understand networking and IaC
- [Phase 01-app-foundation]: Build/dev scripts use --webpack flag: Next.js 16 defaults to Turbopack incompatible with rehype-pretty-code
- [Phase 01-app-foundation]: vitest@4.1.0 used instead of plan-specified 2.2.0: version 2.2.0 does not exist on npm registry
- [Phase 01-app-foundation]: Dark-first CSS pattern: :root defines dark values, .light class overrides to light; ThemeProvider defaultTheme=dark
- [Phase 01-app-foundation]: Search index served as static API route with force-static: avoids bundling large MiniSearch JSON into page JS; loaded lazily on first Cmd+K open
- [Phase 01-app-foundation]: Empty corpus for Phase 1 search index: /api/search-index returns valid but empty JSON; populated in Phase 2+ when MDX lesson files are added
- [Phase 01-app-foundation]: Islands architecture for sidebar: Sidebar is a server component passing static Module[] to SidebarClient client component for interactivity without extra server round-trips
- [Phase 01-app-foundation]: SheetTrigger without asChild: @base-ui/react (shadcn base-nova) does not support Radix-style asChild; SheetTrigger uses className prop directly for styling
- [Phase 01-app-foundation]: Two-click confirmation for Reset Progress: first click enters confirming=true state (3s auto-cancel), second click calls resetProgress() — prevents accidental data loss
- [Phase 01-app-foundation]: CodeBlock copy uses data-copy-target attribute on pre element to extract text without traversing rehype-pretty-code nested span structure
- [Phase 01-app-foundation]: ExerciseCard/VerificationChecklist use local useState — not ProgressContext. ProgressContext tracks lesson/exercise completion at a higher level
- [Phase 01-app-foundation]: TableOfContents renders null when fewer than 3 headings — prevents unnecessary sidebar chrome on short lessons
- [Phase 02-linux-fundamentals]: @next/mdx does not export frontmatter — getLessonContent reads raw MDX via fs/gray-matter at render time
- [Phase 02-linux-fundamentals]: MobileSidebar accepts children instead of importing Sidebar — prevents fs module bundling into client component graph
- [Phase 02-linux-fundamentals]: @next/mdx frontmatter: getLessonContent() reads raw .mdx file via fs.readFileSync for frontmatter since @next/mdx does not auto-export YAML frontmatter without remark-mdx-frontmatter plugin
- [Phase 02-linux-fundamentals]: Lesson discovery: filesystem scan of content/modules/<slug>/*.mdx via readdirSync; filter out 00- templates; sort alphabetically — adding MDX files requires no code changes
- [Phase 02-linux-fundamentals]: Search body cleaning: JSX tags stripped with /<[^>]+>/g before indexing — sufficient for full-text search without installing additional remark plugins
- [Phase 02-linux-fundamentals]: One QuickReference component per lesson topic (9 components) in cheat sheet — not a single mega-component — matches per-lesson pattern and keeps sections independently scannable
- [Phase 02-linux-fundamentals]: sysstat added to Dockerfile for iostat (referenced in lesson 1 content but omitted from plan tool list)
- [Phase 02-linux-fundamentals]: 08-text-processing generates 500-line access log at container startup using pure bash — no external Python/Node dependency needed
- [Phase 03-networking-foundations]: moduleSlug: '02-networking' used in all networking MDX files — confirmed against content/modules/index.ts registry slug (not '02-networking-foundations')
- [Phase 03-networking-foundations]: DNS lesson references docker/networking/03-dns/compose.yml Compose lab which will be created in plan 02
- [Phase 03-networking-foundations]: 07-troubleshooting: What's Next callout bridges to Docker networking Phase 4
- [Phase 03-networking-foundations]: 05-ssh: ProxyJump recommended over agent forwarding for bastion access — prevents key exposure on shared machines
- [Phase 03-networking-foundations]: Cheat sheet follows Phase 2 (Linux Fundamentals) pattern: one QuickReference component per lesson, each with the lesson's most essential commands and concepts
- [Phase 03-networking-foundations]: CoreDNS hosts plugin for learn.local zone: simpler than zone file, no extra mount required, PTR records served from same hosts block
- [Phase 03-networking-foundations]: Troubleshooting lab fault: app on port 8080 not 80 — forces learner through full layer-by-layer checklist (ping/nc/curl/ss), unambiguous discovery
- [Phase 04-docker-foundation-capstone]: Progressive app uses node:20 (full) in Dockerfile.basic — intentionally oversized for DOC-07 before/after multi-stage build comparison
- [Phase 04-docker-foundation-capstone]: CMD ['node', 'app.js'] not CMD ['npm', 'start'] in progressive app Dockerfile — node as PID 1 for direct SIGTERM handling
- [Phase 04-docker-foundation-capstone]: [Phase 04-docker-foundation-capstone P02]: HEALTHCHECK in Dockerfile.optimized uses wget not curl — Alpine includes wget by default; curl is not pre-installed
- [Phase 04-docker-foundation-capstone]: [Phase 04-docker-foundation-capstone P02]: DOC-05 networking: Docker embedded DNS 127.0.0.11 explicitly bridged to Phase 3 DNS resolution chain knowledge
- [Phase 04-docker-foundation-capstone]: [Phase 04-docker-foundation-capstone P02]: Dockerfile.optimized adds chown -R appuser:appgroup /app after COPY --from=builder — files from builder stage are owned by root
- [Phase 04-docker-foundation-capstone]: 09-foundation-capstone.mdx stub created in plan 04-03 so integration test passes immediately — plan 04-04 overwrites with full capstone content
- [Phase 04-docker-foundation-capstone]: verify-volumes.sh write/read persistence test uses busybox:latest to avoid dependency on exercise app image being built
- [Phase 04-docker-foundation-capstone]: verify.sh splits 'all services running' into 3 separate checks for granular diagnostics per service
- [Phase 05-system-administration-ci-cd]: CICD-01-02 Foundation, CICD-03-04 Intermediate difficulty labels per locked decision in CONTEXT.md
- [Phase 05-system-administration-ci-cd]: ghcr.io over Docker Hub in pipeline YAML: uses GITHUB_TOKEN, no extra secret, integrated with GitHub packages
- [Phase 05-system-administration-ci-cd]: build-push job main-branch guard (if: github.ref == refs/heads/main) — PRs run lint+test but never push images to registry
- [Phase 05-system-administration-ci-cd]: jrei/systemd-ubuntu:22.04 requires --privileged --tmpfs flags — documented as warning callout in SYS-02 lesson
- [Phase 05-system-administration-ci-cd]: Loopback device pattern for disk labs: truncate -s 512M + losetup /dev/loop0 — requires --privileged container
- [Phase 05-system-administration-ci-cd]: Pipeline YAML in cheat sheet matches lesson 3 exactly (same action versions: checkout@v6, setup-buildx@v4, login-action@v4, build-push-action@v7) — single source of truth for the learner
- [Phase 05-system-administration-ci-cd]: 05-scheduling verify: systemd timer check is conditional on file existence — avoids false fail on containers without systemd
- [Phase 05-system-administration-ci-cd]: 06-monitoring verify: load average file check is SKIP not FAIL — learner may observe interactively without saving to file
- [Phase 06-infrastructure-as-code-cloud]: IAC-01-02 Foundation, IAC-03-04 Intermediate difficulty labels — matches locked decision from CONTEXT.md
- [Phase 06-infrastructure-as-code-cloud]: terraform{} block taught (not opentofu{}) — works in both tools, what job postings show; HCL variable validation block included showing safety-net pattern
- [Phase 06-infrastructure-as-code-cloud]: State file shown as actual JSON excerpt in IAC-03; remote backends covered conceptually with S3/GCS/Azure examples without requiring cloud accounts
- [Phase 06-infrastructure-as-code-cloud]: Module-as-function analogy: variables.tf = function signature, main.tf = implementation, outputs.tf = return value
- [Phase 06-infrastructure-as-code-cloud]: CLD-01-02 Foundation, CLD-03-05 Intermediate difficulty — matches CONTEXT.md locked decision for cloud module
- [Phase 06-infrastructure-as-code-cloud]: Object storage has no Docker equivalent — the gap is explicit in lesson 4 as a cloud-native concept (what cloud adds over local infra)
- [Phase 06-infrastructure-as-code-cloud]: IAM policy JSON shown side-by-side with chmod command — explicit syntax comparison for strongest conceptual bridge

### Pending Todos

None yet.

### Blockers/Concerns

- Research flags Phase 4 capstone scenario design as needing careful scoping — needs deliberate design during plan-phase to avoid scope creep into Phase 5 tools
- Research flags Phase 6 IaC — OpenTofu 1.11.0 is recent; verify exercise patterns against current docs during plan-phase
- Research flags Phase 7 monitoring labs — multi-service Docker Compose stack has performance traps on macOS; needs resource-limit research during plan-phase

## Session Continuity

Last session: 2026-03-19T14:00:59.405Z
Stopped at: Completed 06-infrastructure-as-code-cloud-03-PLAN.md
Resume file: None
