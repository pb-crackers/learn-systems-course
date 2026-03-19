# Learn Systems: Interactive DevOps & Systems Engineering Course

## What This Is

A production-ready Next.js web application that delivers a comprehensive, hands-on interactive course teaching DevOps and systems engineering from the ground up, starting with Linux fundamentals. The course is designed for someone who knows programming basics but wants to deeply understand how machines work — from the kernel to the cloud. Every lesson is structured around real-world exercises where the learner practices actual skills, with thorough conceptual explanations. The app features a modern UI built with shadcn/ui and 21st.dev components.

## Core Value

Every lesson must be hands-on and interactive — the learner practices real skills on real systems, not just reads about them. Understanding comes through doing. The web app must be polished, modern, and production-ready.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Next.js web application with modern UI (shadcn/ui, 21st.dev components)
- [ ] Complete Linux fundamentals curriculum (filesystem, permissions, processes, shell scripting)
- [ ] Networking foundations (TCP/IP, DNS, HTTP, firewalls, troubleshooting)
- [ ] System administration (users, packages, services, logging, monitoring)
- [ ] Containerization with Docker (images, containers, volumes, networking, Compose)
- [ ] CI/CD pipelines (build, test, deploy automation)
- [ ] Infrastructure as Code (Terraform or equivalent)
- [ ] Cloud fundamentals (compute, storage, networking in AWS/GCP/Azure)
- [ ] Configuration management and automation
- [ ] Monitoring, observability, and incident response
- [ ] Hands-on exercises for every topic with real-world scenarios
- [ ] Interactive code/terminal components embedded in lessons
- [ ] Progress tracking across modules and lessons
- [ ] Progressive difficulty from beginner to intermediate/advanced
- [ ] Thorough explanations of "why" and "how things work under the hood"
- [ ] Responsive, modern design that works on desktop and tablet

### Out of Scope

- Video content — text and code-based curriculum only
- Certification prep — focused on practical skills, not exam cramming
- Multi-user auth/LMS — single-learner local app
- Advanced Kubernetes orchestration — cover basics, defer advanced topics
- Cost-incurring cloud labs — use local VMs/containers where possible
- Backend API/database — static content served by Next.js, progress stored in localStorage

## Context

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
| Next.js App Router + shadcn/ui | Modern React stack, great DX, beautiful components out of the box | — Pending |
| Local-first labs using Docker/VMs | Avoid cloud costs, instant feedback, repeatable environments | — Pending |
| Content as MDX or structured data | Rich content with embedded interactive components | — Pending |
| localStorage for progress | No backend needed, simple single-user persistence | — Pending |
| Progressive module structure | Each module builds on previous, mirrors real learning path | — Pending |

---
*Last updated: 2026-03-18 after initialization (updated to web app approach)*
