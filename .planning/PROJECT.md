# Learn Systems: Interactive DevOps & Systems Engineering Course

## What This Is

A production-ready Next.js web application that delivers a comprehensive, hands-on interactive course teaching DevOps and systems engineering from the ground up, starting with Linux fundamentals. The course is designed for someone who knows programming basics but wants to deeply understand how machines work — from the kernel to the cloud. Every lesson is structured around real-world exercises with difficulty-aware command pedagogy: Foundation exercises annotate every flag, Intermediate exercises require recall, and Challenge exercises give only the goal. The app features a modern UI built with shadcn/ui and 21st.dev components.

## Core Value

Every lesson must be hands-on and interactive — the learner practices real skills on real systems, not just reads about them. Understanding comes through doing. Commands have context: "I am running this command so I can answer THIS question." The web app must be polished, modern, and production-ready.

## Requirements

### Validated

- ✓ Next.js web application with modern UI (shadcn/ui, 21st.dev components) — v1.0
- ✓ Complete Linux fundamentals curriculum (filesystem, permissions, processes, shell scripting) — v1.0
- ✓ Networking foundations (TCP/IP, DNS, HTTP, firewalls, troubleshooting) — v1.0
- ✓ System administration (users, packages, services, logging, monitoring) — v1.0
- ✓ Containerization with Docker (images, containers, volumes, networking, Compose) — v1.0
- ✓ CI/CD pipelines (build, test, deploy automation) — v1.0
- ✓ Infrastructure as Code (OpenTofu/Terraform) — v1.0
- ✓ Cloud fundamentals (compute, storage, networking mapped to local Docker equivalents) — v1.0
- ✓ Monitoring, observability, and incident response (Prometheus, Grafana, Loki) — v1.0
- ✓ Hands-on exercises for every topic with real-world scenarios — v1.0
- ✓ Interactive code/terminal components embedded in lessons — v1.0
- ✓ Progress tracking across modules and lessons — v1.0
- ✓ Progressive difficulty from beginner to intermediate/advanced — v1.0
- ✓ Thorough explanations of "why" and "how things work under the hood" — v1.0
- ✓ Responsive, modern design that works on desktop and tablet — v1.0
- ✓ Two capstone projects integrating cross-module skills — v1.0
- ✓ Per-flag command annotations for Foundation exercises — v1.1
- ✓ Difficulty-aware exercise rendering (guided/recall/compose modes) — v1.1
- ✓ Scenario-contextualized questions connecting commands to exercise goals — v1.1
- ✓ Challenge-mode capstone exercises with reference sheets — v1.1
- ✓ Global difficulty preference toggle with localStorage persistence — v1.1
- ✓ Consistent command pedagogy across all 8 modules (56 lessons) — v1.1
- ✓ Multiple-choice knowledge quizzes (7-10 questions per lesson) with retrieval practice — v1.2
- ✓ Quiz-gated progression: 100% score required to unlock next lesson — v1.2
- ✓ Wrong answers show "Incorrect" with full retake, correct answers show mechanism explanations — v1.2
- ✓ Attempt counter, pass screen with "Continue to Next Lesson" navigation — v1.2
- ✓ Quiz type system with compile-time tuple enforcement and grandfather rule for existing progress — v1.2
- ✓ ~500 quiz questions across all 57 lessons with difficulty-tiered content — v1.2

### Active

### Future

- [ ] Kubernetes basics — pods, deployments, services, configmaps
- [ ] Configuration management with Ansible — playbooks, inventory, idempotency
- [ ] Security hardening module — SSH hardening, secrets management, vulnerability scanning
- [ ] Embedded web-based terminal emulator for in-browser exercises

### Out of Scope

- Video content — text and code-based curriculum only
- Certification prep — focused on practical skills, not exam cramming
- Multi-user auth/LMS — single-learner local app
- Advanced Kubernetes orchestration — cover basics, defer advanced topics
- Cost-incurring cloud labs — use local VMs/containers where possible
- Backend API/database — static content served by Next.js, progress stored in localStorage

## Context

Shipped v1.2 with TypeScript, React, MDX, and CSS.
Tech stack: Next.js 16.2 (App Router), React 19, Tailwind v4, shadcn/ui, MDX with rehype-pretty-code + remark-frontmatter.
8 curriculum modules with 57 lessons, Docker-based labs, and 2 capstone projects.
All exercises have verification scripts with PASS/FAIL feedback.
v1.2 added quiz infrastructure: QuizQuestion type system, 5-phase state machine Quiz component, RSC-safe QuizSection wrapper, and ~500 quiz questions across all lessons.
Quiz gating: lessons with quiz data require 100% pass to mark complete; lessons without quiz retain MarkCompleteButton. Grandfather rule preserves pre-v1.2 progress.

- Learner knows programming fundamentals but wants to understand how machines work at a deeper level
- Course runs locally as a Next.js web app on localhost
- Real-life examples and scenarios are critical — no toy examples
- Progressive structure: each module builds on previous knowledge
- Emphasis on "learn by doing" pedagogy — minimal passive reading
- UI must look modern and polished — not a generic tutorial site
- Commands must have context — learner should understand WHY they're running each command

## Constraints

- **Tech Stack**: Next.js (App Router), React, TypeScript, Tailwind CSS, shadcn/ui, 21st.dev components
- **Platform**: macOS development machine (Darwin) — exercises reference Docker/VMs for Linux-specific content
- **Cost**: No cloud dependencies for the app itself — runs entirely locally
- **Interactivity**: Exercises must include verification steps so learner knows they succeeded
- **Quality**: Production-ready code, clean architecture, responsive design

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Next.js App Router + shadcn/ui | Modern React stack, great DX, beautiful components out of the box | ✓ Good — clean architecture, responsive UI |
| Local-first labs using Docker/VMs | Avoid cloud costs, instant feedback, repeatable environments | ✓ Good — all labs work locally with Docker Compose |
| Content as MDX with rehype-pretty-code | Rich content with embedded interactive components | ✓ Good — 56 lessons with syntax highlighting and custom components |
| localStorage for progress | No backend needed, simple single-user persistence | ✓ Good — works reliably, SSR-safe hook |
| Progressive module structure | Each module builds on previous, mirrors real learning path | ✓ Good — 69 prerequisite links validated |
| Mechanism-first pedagogy | Explain how things work before showing commands | ✓ Good — established in Phase 2, followed through Phase 7 |
| OpenTofu over Terraform | Open-source, registry.opentofu.org, same HCL | ✓ Good — kreuzwerker/docker provider works locally |
| Loki/Promtail as Compose profile | Not always-on, opt-in for log aggregation lesson | ✓ Good — reduces default resource usage |
| Difficulty-aware exercise rendering | Foundation = annotated commands, Intermediate = recall, Challenge = compose-your-own | ✓ Good — 3-tier mode resolution with Foundation safety net |
| Design lock before implementation | All type contracts, schemas, content policies locked in Phase 8 before code | ✓ Good — zero redesign needed in Phases 9-11 |
| Prototype before bulk migration | Linux Fundamentals migrated first in Phase 10, validated pattern before 7-module Phase 11 | ✓ Good — caught annotation schema issues early |
| Separate localStorage keys for preferences | Preferences survive progress reset, separate concern from completion tracking | ✓ Good — clean separation, compound hydration guard |
| Quiz as MDX named export | Quiz data lives alongside lesson content, extracted via existing dynamic import | ✓ Good — no build pipeline changes, clean data flow |
| useReducer state machine for quiz | 5-phase discriminated union (idle/active/answering/failed/passed), pure reducer testable without DOM | ✓ Good — 16 tests, clear state transitions |
| QuizSection RSC wrapper | Bridges Server Component → Client Component boundary for router.push navigation | ✓ Good — LessonLayout stays Server Component |
| One plan per module for content authoring | 8 parallel plans, each authors all lessons in one module independently | ✓ Good — maximum parallelization, 8 agents completed simultaneously |

---
*Last updated: 2026-03-23 after v1.2 milestone complete*
