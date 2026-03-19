# Roadmap: Learn Systems

## Overview

This roadmap builds a modern Next.js web application delivering a comprehensive, hands-on DevOps and systems engineering course. The first phase establishes the application shell and content framework before any curriculum is written. Subsequent phases add curriculum modules in dependency order — Linux gates everything, networking gates Docker, Docker gates CI/CD — ensuring each phase delivers a complete, verifiable capability the learner can use immediately. The final phase closes with monitoring and an advanced capstone that integrates all prior modules.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: App Foundation** - Next.js application shell with navigation, progress tracking, content framework, and modern UI (completed 2026-03-19)
- [x] **Phase 2: Linux Fundamentals** - Complete Linux module with mechanism-first lessons, Docker-based labs, and verified exercises (completed 2026-03-19)
- [ ] **Phase 3: Networking Foundations** - Complete networking module with TCP/IP through SSH and firewall lessons with multi-container labs
- [ ] **Phase 4: Docker & Foundation Capstone** - Complete Docker/containerization module plus cross-module foundation capstone project
- [x] **Phase 5: System Administration & CI/CD** - Sysadmin module (systemd, logging, disk) combined with CI/CD pipelines module (completed 2026-03-19)
- [x] **Phase 6: Infrastructure as Code & Cloud** - OpenTofu/IaC module and cloud fundamentals module mapped to prior knowledge (completed 2026-03-19)
- [ ] **Phase 7: Monitoring & Advanced Capstone** - Prometheus/Grafana monitoring module and full-stack advanced capstone project

## Phase Details

### Phase 1: App Foundation
**Goal**: The Next.js application is running with a polished UI, full course navigation, progress tracking, and a content framework that every subsequent curriculum module can drop into
**Depends on**: Nothing (first phase)
**Requirements**: APP-01, APP-02, APP-03, APP-04, APP-05, APP-06, APP-07, APP-08, CONT-01, CONT-02, CONT-03, CONT-04, CONT-05, CONT-06, CONT-07, CONT-08
**Success Criteria** (what must be TRUE):
  1. Learner can navigate the full course sidebar, see all modules and lessons with progress indicators, and track completion across browser sessions via localStorage
  2. Any lesson page displays rich MDX content with syntax-highlighted, copyable code blocks, embedded interactive components, and clear prerequisite links
  3. Learner can toggle dark mode and the preference persists; the layout is fully usable on desktop and tablet
  4. Learner can search across all course content and navigate to matching lessons from the results
  5. Every lesson template enforces "How It Works" explanation sections, explicit prerequisites, difficulty-labeled exercises with real-world scenarios, and a quick reference section per module
**Plans**: 4 plans

Plans:
- [ ] 01-01-PLAN.md — Next.js 16 scaffold, Tailwind v4 dark-first theming, type system, useLocalStorage hook, Vitest setup (Wave 1)
- [ ] 01-02-PLAN.md — 8-module collapsible sidebar, mobile drawer, ProgressProvider, localStorage progress tracking (Wave 2, parallel with 01-03)
- [ ] 01-03-PLAN.md — MDX pipeline, lesson/module routes, MiniSearch index API, Cmd+K search modal (Wave 2, parallel with 01-02)
- [ ] 01-04-PLAN.md — Content components (CodeBlock, TerminalBlock, ExerciseCard, Callout, etc.), LessonLayout, lesson template (Wave 3)

### Phase 2: Linux Fundamentals
**Goal**: Learners can complete all Linux Fundamentals lessons with Docker-based lab environments, verifiable exercises, and the "explain the mechanism before the command" pattern established for all subsequent modules
**Depends on**: Phase 1
**Requirements**: LNX-01, LNX-02, LNX-03, LNX-04, LNX-05, LNX-06, LNX-07, LNX-08, LNX-09, LNX-10, LNX-11
**Success Criteria** (what must be TRUE):
  1. Learner can open any Linux lesson and read a thorough mechanism-first explanation (how the kernel/subsystem actually works) before any commands are shown
  2. Learner can launch a Docker-based lab environment for each Linux lesson and complete the exercise entirely within that container
  3. Learner can run the exercise verification and receive explicit PASS/FAIL feedback telling them whether they succeeded — no guessing required
  4. Learner can reference the module cheat sheet and find all essential Linux commands and concepts from the module in one place
  5. Progress indicators in the sidebar update correctly when Linux lessons and exercises are marked complete
**Plans**: 4 plans

Plans:
- [ ] 02-01-PLAN.md — Lessons 1-5 (computers, OS, filesystem, permissions, processes) + integration seam updates for sidebar/search (Wave 1, parallel with 02-02)
- [ ] 02-02-PLAN.md — Lessons 6-9 (shell, scripting, text processing, packages) (Wave 1, parallel with 02-01)
- [ ] 02-03-PLAN.md — Docker lab infrastructure: Dockerfile, 9 setup scripts, 9 verify scripts with PASS/FAIL output (Wave 2)
- [ ] 02-04-PLAN.md — Module cheat sheet with QuickReference sections for all 9 lesson topics (Wave 2)

### Phase 3: Networking Foundations
**Goal**: Learners can complete all Networking Foundations lessons with multi-container lab environments and understand how Docker networking (covered next) builds on these primitives
**Depends on**: Phase 2
**Requirements**: NET-01, NET-02, NET-03, NET-04, NET-05, NET-06, NET-07, NET-08, NET-09
**Success Criteria** (what must be TRUE):
  1. Learner can follow a packet from physical layer through the TCP/IP stack and articulate what happens at each layer, not just name the layers
  2. Learner can complete DNS, HTTP/HTTPS, and SSH lessons including hands-on exercises using dig, curl, and ssh within Docker Compose lab environments
  3. Learner can complete the firewall lesson and write iptables/ufw rules in a lab container that verifiably block or allow the expected traffic
  4. Learner can use the network troubleshooting lesson's tools (ping, traceroute, tcpdump, ss) to diagnose a deliberately broken network scenario and identify the fault
  5. Learner can reference the networking cheat sheet for all commands and concepts from the module
**Plans**: 4 plans

Plans:
- [ ] 03-01-PLAN.md — Lessons 1-3 (physical networking, TCP/IP stack, DNS) with mechanism-first explanations and ASCII diagrams (Wave 1, parallel with 03-02)
- [ ] 03-02-PLAN.md — Lessons 4-7 (HTTP/HTTPS, SSH, firewalls, troubleshooting) with exercises referencing Docker Compose labs (Wave 1, parallel with 03-01)
- [ ] 03-03-PLAN.md — Docker Compose multi-container lab infrastructure: Dockerfile, 6 lab directories with compose.yml + setup.sh + verify.sh (Wave 2, parallel with 03-04)
- [ ] 03-04-PLAN.md — Module cheat sheet with 7 QuickReference sections and What's Next callout bridging to Docker (Wave 2, parallel with 03-03)

### Phase 4: Docker & Foundation Capstone
**Goal**: Learners can build, run, and compose Docker-based applications with full understanding of the Linux primitives underneath, and can complete a cross-module foundation capstone that integrates Linux, networking, and Docker skills without step-by-step guidance
**Depends on**: Phase 3
**Requirements**: DOC-01, DOC-02, DOC-03, DOC-04, DOC-05, DOC-06, DOC-07, DOC-08, DOC-09, CAP-01
**Success Criteria** (what must be TRUE):
  1. Learner can explain namespaces and cgroups as the mechanism behind containers before writing a single Dockerfile
  2. Learner can build a multi-stage Docker image, run a container with resource limits, mount volumes correctly, and configure container networking — all using verified exercises
  3. Learner can write a Docker Compose file for a multi-service application with correct service dependencies, environment variables, and named volumes
  4. Learner can complete the foundation capstone: deploy a Dockerized web app, diagnose a network issue using skills from Module 2, and automate the setup with a shell script from Module 1 — without step-by-step guidance
  5. Learner can reference the Docker cheat sheet for all Docker and Compose commands from the module
**Plans**: 4 plans

Plans:
- [ ] 04-01-PLAN.md — Lessons 1-3 (container internals, images, containers) + progressive Node.js exercise app (Wave 1, parallel with 04-02)
- [ ] 04-02-PLAN.md — Lessons 4-7 (volumes, networking, Compose, best practices) + optimized Dockerfile (Wave 1, parallel with 04-01)
- [ ] 04-03-PLAN.md — Exercise verify scripts for all 7 Docker lessons + integration test (Wave 2, parallel with 04-04)
- [ ] 04-04-PLAN.md — Module cheat sheet + foundation capstone project with verify.sh (Wave 2, parallel with 04-03)

### Phase 5: System Administration & CI/CD
**Goal**: Learners can manage Linux services with systemd, understand logging and disk management, and build real CI/CD pipelines that build and deploy Docker images using GitHub Actions
**Depends on**: Phase 4
**Requirements**: SYS-01, SYS-02, SYS-03, SYS-04, SYS-05, SYS-06, SYS-07, SYS-08, CICD-01, CICD-02, CICD-03, CICD-04, CICD-05, CICD-06
**Success Criteria** (what must be TRUE):
  1. Learner can manage systemd services (start, stop, enable, view status and journal logs) and write a simple service unit file using verified lab exercises
  2. Learner can diagnose disk usage, manage mounts, configure cron/systemd timers, and monitor system resources using the sysadmin lessons' verified exercises
  3. Learner can write a GitHub Actions workflow that builds a Docker image, runs tests, and deploys — and can trace what each step is actually doing in the underlying system
  4. Learner can describe blue/green, rolling, and canary deployment strategies and explain the tradeoffs without consulting the lesson
  5. Learner can reference both the sysadmin and CI/CD cheat sheets for commands and pipeline patterns
**Plans**: 4 plans

Plans:
- [ ] 05-01-PLAN.md — Sysadmin lessons 1-6 (users, systemd, logging, disk, scheduling, monitoring) with mechanism-first explanations (Wave 1, parallel with 05-03)
- [ ] 05-02-PLAN.md — Sysadmin Docker labs (2 Dockerfiles, 6 setup/verify scripts), cheat sheet, Vitest assertion (Wave 2)
- [ ] 05-03-PLAN.md — CI/CD lessons 1-4 (concepts, GitHub Actions, build/test pipelines, deployment strategies) (Wave 1, parallel with 05-01)
- [ ] 05-04-PLAN.md — CI/CD cheat sheet with pipeline exercise + Vitest assertion (Wave 2)

### Phase 6: Infrastructure as Code & Cloud
**Goal**: Learners can write OpenTofu/Terraform HCL to provision infrastructure declaratively using local Docker targets, and understand cloud fundamentals by mapping cloud services to the networking, IaC, and container concepts they already know
**Depends on**: Phase 5
**Requirements**: IAC-01, IAC-02, IAC-03, IAC-04, IAC-05, IAC-06, CLD-01, CLD-02, CLD-03, CLD-04, CLD-05, CLD-06, CLD-07
**Success Criteria** (what must be TRUE):
  1. Learner can write an OpenTofu configuration from scratch — providers, resources, variables, outputs — and apply it to provision local Docker resources without following a step-by-step tutorial
  2. Learner can explain Terraform state, perform state management operations, and describe why remote backends and state locking exist
  3. Learner can write a reusable Terraform module and compose it with other modules
  4. Learner can map each major cloud service category (compute, networking, storage, IAM) to a concept they learned in prior modules and explain the mapping without consulting the lesson
  5. Learner can reference both the IaC and cloud cheat sheets for OpenTofu commands and cloud service patterns
**Plans**: 4 plans

Plans:
- [ ] 06-01-PLAN.md — IaC lessons 1-4 (concepts, HCL basics, state, modules) with mechanism-first explanations (Wave 1, parallel with 06-03)
- [ ] 06-02-PLAN.md — IaC exercise HCL files (3 directories), verify scripts, cheat sheet, Vitest assertion (Wave 2)
- [ ] 06-03-PLAN.md — Cloud lessons 1-5 (concepts, compute, networking, storage, IAM) with Docker/Linux mappings (Wave 1, parallel with 06-01)
- [ ] 06-04-PLAN.md — Cloud mapping Docker Compose exercise, verify script, cheat sheet, Vitest assertion (Wave 2)

### Phase 7: Monitoring & Advanced Capstone
**Goal**: Learners can instrument a Dockerized application with Prometheus and Grafana, set up alerting, and complete an advanced capstone that integrates all prior modules into a full pipeline with an intentional failure scenario to diagnose
**Depends on**: Phase 6
**Requirements**: MON-01, MON-02, MON-03, MON-04, MON-05, MON-06, MON-07, CAP-02
**Success Criteria** (what must be TRUE):
  1. Learner can explain the three pillars of observability (metrics, logs, traces) and articulate when to use each
  2. Learner can write PromQL queries against a running Prometheus instance and create a Grafana dashboard for a Dockerized application using the Docker Compose monitoring stack
  3. Learner can configure an alerting rule in Prometheus and trace the alert path from metric threshold to notification
  4. Learner can complete the advanced capstone: a Dockerized application with a CI/CD pipeline, infrastructure provisioned with OpenTofu, monitoring with Prometheus/Grafana, and an intentional failure scenario they must diagnose and resolve without guidance
  5. Learner can reference the monitoring cheat sheet for Prometheus, Grafana, and log aggregation tools
**Plans**: 3 plans

Plans:
- [ ] 07-01-PLAN.md — Monitoring lessons 1-5 (observability concepts, Prometheus, Grafana, log aggregation, incident response) (Wave 1, parallel with 07-02)
- [ ] 07-02-PLAN.md — Docker Compose monitoring stack, Loki example, cheat sheet, Vitest assertion (Wave 1, parallel with 07-01)
- [ ] 07-03-PLAN.md — Advanced capstone project with memory leak failure scenario, IaC, CI workflow (Wave 2)

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 → 7

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. App Foundation | 4/4 | Complete    | 2026-03-19 |
| 2. Linux Fundamentals | 4/4 | Complete   | 2026-03-19 |
| 3. Networking Foundations | 2/4 | In Progress|  |
| 4. Docker & Foundation Capstone | 3/4 | In Progress|  |
| 5. System Administration & CI/CD | 4/4 | Complete   | 2026-03-19 |
| 6. Infrastructure as Code & Cloud | 4/4 | Complete   | 2026-03-19 |
| 7. Monitoring & Advanced Capstone | 1/3 | In Progress|  |

---
*Roadmap created: 2026-03-18*
*Requirements coverage: 80/80 v1 requirements mapped*
*Phase 1 planned: 2026-03-18 — 4 plans, 3 waves*
*Phase 2 planned: 2026-03-19 — 4 plans, 2 waves*
*Phase 3 planned: 2026-03-19 — 4 plans, 2 waves*
*Phase 4 planned: 2026-03-19 — 4 plans, 2 waves*
*Phase 5 planned: 2026-03-19 — 4 plans, 2 waves*
*Phase 6 planned: 2026-03-19 — 4 plans, 2 waves*
*Phase 7 planned: 2026-03-19 — 3 plans, 2 waves*
