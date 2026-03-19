# Learn Systems: Interactive DevOps & Systems Engineering Course

## What This Is

A comprehensive, hands-on interactive course that teaches DevOps and systems engineering from the ground up, starting with Linux fundamentals. The course is designed for someone who knows programming basics but wants to deeply understand how machines work — from the kernel to the cloud. Every lesson is structured around real-world exercises where the learner practices actual skills, supported by thorough conceptual explanations.

## Core Value

Every lesson must be hands-on and interactive — the learner practices real skills on real systems, not just reads about them. Understanding comes through doing.

## Requirements

### Validated

(None yet — ship to validate)

### Active

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
- [ ] Progressive difficulty from beginner to intermediate/advanced
- [ ] Thorough explanations of "why" and "how things work under the hood"

### Out of Scope

- Video content — text and code-based curriculum only
- Certification prep — focused on practical skills, not exam cramming
- Multi-user/LMS platform — single-learner local course
- Advanced Kubernetes orchestration — cover basics, defer advanced topics
- Cost-incurring cloud labs — use local VMs/containers where possible

## Context

- Learner knows programming fundamentals but wants to understand how machines work at a deeper level
- Course should be self-contained and runnable locally (using VMs, Docker, local tools)
- Real-life examples and scenarios are critical — no toy examples
- The course is built as files in this repo: lessons, exercises, scripts, configs
- Progressive structure: each module builds on previous knowledge
- Emphasis on "learn by doing" pedagogy — minimal passive reading

## Constraints

- **Platform**: macOS development machine (Darwin) — exercises should work on macOS or use Docker/VMs for Linux-specific content
- **Cost**: Minimize cloud costs — prefer local Docker/VM environments for practice
- **Format**: Markdown lessons with embedded code blocks, shell scripts for exercises, Docker/VM configs for lab environments
- **Interactivity**: Exercises must include verification steps so learner knows they succeeded

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Local-first labs using Docker/VMs | Avoid cloud costs, instant feedback, repeatable environments | — Pending |
| Markdown + scripts format | Simple, version-controlled, works in any editor/terminal | — Pending |
| Progressive module structure | Each module builds on previous, mirrors real learning path | — Pending |

---
*Last updated: 2026-03-18 after initialization*
