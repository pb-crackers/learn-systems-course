# Learn Systems: Interactive DevOps & Systems Engineering Course

## What This Is

A production-ready Next.js web application that delivers a comprehensive, hands-on interactive course teaching DevOps and systems engineering from the ground up, starting with Linux fundamentals. The course is designed for someone who knows programming basics but wants to deeply understand how machines work — from the kernel to the cloud. Every lesson is structured around real-world exercises where the learner practices actual skills, with thorough conceptual explanations. The app features a modern UI built with shadcn/ui and 21st.dev components.

## Core Value

Every lesson must be hands-on and interactive — the learner practices real skills on real systems, not just reads about them. Understanding comes through doing. The web app must be polished, modern, and production-ready.

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

### Active

- [ ] Kubernetes basics — pods, deployments, services, configmaps
- [ ] Configuration management with Ansible — playbooks, inventory, idempotency
- [ ] Security hardening module — SSH hardening, secrets management, vulnerability scanning
- [ ] Embedded web-based terminal emulator for in-browser exercises
- [ ] Interactive quizzes after each lesson

### Out of Scope

- Video content — text and code-based curriculum only
- Certification prep — focused on practical skills, not exam cramming
- Multi-user auth/LMS — single-learner local app
- Advanced Kubernetes orchestration — cover basics, defer advanced topics
- Cost-incurring cloud labs — use local VMs/containers where possible
- Backend API/database — static content served by Next.js, progress stored in localStorage

## Context

Shipped v1.0 with 20,429 LOC across TypeScript, React, MDX, and CSS.
Tech stack: Next.js 16.2 (App Router), React 19, Tailwind v4, shadcn/ui, MDX with rehype-pretty-code.
8 curriculum modules with 56 lessons, Docker-based labs, and 2 capstone projects.
All exercises have verification scripts with PASS/FAIL feedback.

- Learner knows programming fundamentals but wants to understand how machines work at a deeper level
- Course runs locally as a Next.js web app on localhost
- Real-life examples and scenarios are critical — no toy examples
- Progressive structure: each module builds on previous knowledge
- Emphasis on "learn by doing" pedagogy — minimal passive reading
- UI must look modern and polished — not a generic tutorial site

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

---
*Last updated: 2026-03-19 after v1.0 milestone*
