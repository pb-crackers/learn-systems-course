# Requirements: Learn Systems

**Defined:** 2026-03-18
**Core Value:** Every lesson must be hands-on and interactive with thorough explanations — the learner practices real skills and understands how machines actually work. Delivered as a modern, production-ready Next.js web application.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Application Foundation

- [x] **APP-01**: Next.js App Router application with TypeScript, Tailwind CSS, and shadcn/ui
- [x] **APP-02**: Modern, polished responsive design using shadcn/ui and 21st.dev components
- [x] **APP-03**: Course navigation with sidebar showing all modules and lessons with progress indicators
- [x] **APP-04**: Progress tracking persisted in localStorage (lesson completion, exercise completion)
- [x] **APP-05**: Dark mode support with system preference detection
- [x] **APP-06**: Mobile-responsive layout that works on desktop and tablet
- [x] **APP-07**: Search functionality across all course content
- [x] **APP-08**: Syntax-highlighted code blocks with copy-to-clipboard functionality

### Content Framework

- [x] **CONT-01**: MDX-based lesson content with rich formatting, diagrams, and interactive elements
- [x] **CONT-02**: Each lesson has thorough "How It Works" explanation sections before exercises
- [x] **CONT-03**: Each lesson has explicit prerequisites listed and linked
- [x] **CONT-04**: Interactive terminal/code components embedded in lessons for try-it-yourself moments
- [x] **CONT-05**: Exercise sections with clear objectives, steps, and verification criteria
- [x] **CONT-06**: Quick reference/cheat sheet section per module
- [x] **CONT-07**: Progressive difficulty labels (Foundation / Intermediate / Challenge) on exercises
- [x] **CONT-08**: Real-world scenario descriptions for every exercise (not toy examples)

### Module 1: Linux Fundamentals

- [x] **LNX-01**: Lesson on how computers work — CPU, memory, storage, I/O (prerequisite context)
- [x] **LNX-02**: Lesson on what an operating system does — kernel, userspace, system calls
- [x] **LNX-03**: Lesson on the Linux filesystem — hierarchy, mount points, inodes, everything is a file
- [x] **LNX-04**: Lesson on file permissions and ownership — users, groups, chmod, chown, sticky bits
- [x] **LNX-05**: Lesson on processes — PID, fork/exec, process states, signals, ps, top, kill
- [x] **LNX-06**: Lesson on shell fundamentals — bash, environment variables, PATH, pipes, redirects
- [x] **LNX-07**: Lesson on shell scripting — variables, conditionals, loops, functions, error handling
- [x] **LNX-08**: Lesson on text processing — grep, sed, awk, sort, uniq, cut, xargs
- [x] **LNX-09**: Lesson on package management — apt/yum, repositories, dependencies
- [x] **LNX-10**: Hands-on exercises for each Linux lesson with Docker-based lab environments
- [x] **LNX-11**: Module cheat sheet with essential Linux commands and concepts

### Module 2: Networking Foundations

- [x] **NET-01**: Lesson on how networks work — physical layer, switches, routers, packets
- [x] **NET-02**: Lesson on the TCP/IP stack — layers, encapsulation, IP addressing, subnets
- [x] **NET-03**: Lesson on DNS — resolution process, record types, caching, troubleshooting with dig/nslookup
- [x] **NET-04**: Lesson on HTTP/HTTPS — request/response cycle, methods, headers, TLS handshake
- [x] **NET-05**: Lesson on SSH — key-based auth, tunneling, config files, agent forwarding
- [x] **NET-06**: Lesson on firewalls — iptables, ufw, security groups concepts, netfilter
- [x] **NET-07**: Lesson on network troubleshooting — ping, traceroute, tcpdump, netstat/ss, curl
- [x] **NET-08**: Hands-on exercises for each networking lesson with multi-container lab environments
- [x] **NET-09**: Module cheat sheet with networking commands and concepts

### Module 3: System Administration

- [x] **SYS-01**: Lesson on user and group management — useradd, /etc/passwd, /etc/shadow, sudo
- [x] **SYS-02**: Lesson on systemd — units, services, targets, journald, service lifecycle
- [x] **SYS-03**: Lesson on logging — syslog, journald, log rotation, centralized logging concepts
- [x] **SYS-04**: Lesson on disk management — fdisk, mount, fstab, LVM basics, df, du
- [x] **SYS-05**: Lesson on process management and scheduling — cron, systemd timers, at, nice/renice
- [x] **SYS-06**: Lesson on system monitoring — top, htop, vmstat, iostat, resource bottlenecks
- [ ] **SYS-07**: Hands-on exercises for each sysadmin lesson
- [ ] **SYS-08**: Module cheat sheet with sysadmin commands and concepts

### Module 4: Containerization with Docker

- [x] **DOC-01**: Lesson on what containers are — namespaces, cgroups, how containers actually work under the hood
- [x] **DOC-02**: Lesson on Docker images — layers, Dockerfile, build process, registries
- [x] **DOC-03**: Lesson on Docker containers — lifecycle, exec, logs, resource limits
- [x] **DOC-04**: Lesson on Docker volumes — bind mounts, named volumes, data persistence
- [x] **DOC-05**: Lesson on Docker networking — bridge, host, overlay, DNS between containers
- [x] **DOC-06**: Lesson on Docker Compose — multi-service apps, depends_on, environment variables, profiles
- [x] **DOC-07**: Lesson on Dockerfile best practices — multi-stage builds, layer caching, security
- [x] **DOC-08**: Hands-on exercises for each Docker lesson with real application scenarios
- [x] **DOC-09**: Module cheat sheet with Docker commands and concepts

### Module 5: CI/CD Pipelines

- [x] **CICD-01**: Lesson on CI/CD concepts — what it is, why it matters, build/test/deploy lifecycle
- [x] **CICD-02**: Lesson on GitHub Actions — workflows, triggers, jobs, steps, artifacts
- [x] **CICD-03**: Lesson on building and testing in pipelines — Docker builds, test automation, linting
- [x] **CICD-04**: Lesson on deployment strategies — blue/green, rolling, canary concepts
- [x] **CICD-05**: Hands-on exercises building real CI/CD pipelines
- [x] **CICD-06**: Module cheat sheet with CI/CD patterns and GitHub Actions syntax

### Module 6: Infrastructure as Code

- [ ] **IAC-01**: Lesson on IaC concepts — why declarative infra, state management, drift
- [ ] **IAC-02**: Lesson on Terraform/OpenTofu basics — HCL syntax, providers, resources, variables
- [ ] **IAC-03**: Lesson on Terraform state — local state, remote backends, state locking
- [ ] **IAC-04**: Lesson on Terraform modules — reusability, composition, registry
- [ ] **IAC-05**: Hands-on exercises with local Docker provider (no cloud cost)
- [ ] **IAC-06**: Module cheat sheet with Terraform/OpenTofu commands and patterns

### Module 7: Cloud Fundamentals

- [ ] **CLD-01**: Lesson on cloud computing concepts — IaaS/PaaS/SaaS, regions, availability zones
- [ ] **CLD-02**: Lesson on compute — VMs, containers, serverless (mapped to prior Docker knowledge)
- [ ] **CLD-03**: Lesson on cloud networking — VPCs, subnets, load balancers (mapped to prior networking knowledge)
- [ ] **CLD-04**: Lesson on cloud storage — object, block, file storage types and use cases
- [ ] **CLD-05**: Lesson on IAM — policies, roles, least privilege (mapped to prior Linux permissions knowledge)
- [ ] **CLD-06**: Hands-on exercises with conceptual mapping to local Docker equivalents
- [ ] **CLD-07**: Module cheat sheet with cloud concepts and service mappings

### Module 8: Monitoring & Observability

- [ ] **MON-01**: Lesson on observability concepts — metrics, logs, traces (three pillars)
- [ ] **MON-02**: Lesson on Prometheus — metrics collection, PromQL basics, alerting rules
- [ ] **MON-03**: Lesson on Grafana — dashboards, data sources, visualization
- [ ] **MON-04**: Lesson on log aggregation — centralized logging, ELK/Loki concepts
- [ ] **MON-05**: Lesson on incident response — alerting, runbooks, postmortems
- [ ] **MON-06**: Hands-on exercises with Docker Compose monitoring stack
- [ ] **MON-07**: Module cheat sheet with monitoring tools and concepts

### Capstone Projects

- [x] **CAP-01**: Foundation capstone — deploy a Dockerized web app, diagnose network issues, automate with shell scripts
- [ ] **CAP-02**: Advanced capstone — full pipeline: Docker app + CI/CD + IaC + monitoring with intentional failure scenario

## v2 Requirements

### Advanced Topics

- **ADV-01**: Kubernetes basics — pods, deployments, services, configmaps
- **ADV-02**: Configuration management with Ansible — playbooks, inventory, idempotency
- **ADV-03**: Security hardening module — SSH hardening, secrets management, vulnerability scanning
- **ADV-04**: Performance tuning — kernel parameters, resource limits, profiling

### Enhanced Interactivity

- **INT-01**: Embedded web-based terminal emulator for in-browser exercises
- **INT-02**: Interactive quizzes after each lesson
- **INT-03**: Animated diagrams for network packet flow, container lifecycle, etc.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Video content | Text and code-based only; videos go stale fast with tool UI changes |
| Certification exam prep | Focus on practical skills, not memorization |
| Multi-user authentication | Single-learner local app; no backend needed |
| Advanced Kubernetes (Helm, operators, multi-cluster) | Complexity cliff; basics sufficient for v1 |
| Cloud-heavy labs with real cost | Local-first constraint; Docker/VM equivalents used |
| Backend API/database | Static content via Next.js; progress in localStorage |
| Gamification (badges, points) | Adds platform complexity for marginal value |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| APP-01 | Phase 1 | Complete |
| APP-02 | Phase 1 | Complete |
| APP-03 | Phase 1 | Complete |
| APP-04 | Phase 1 | Complete |
| APP-05 | Phase 1 | Complete |
| APP-06 | Phase 1 | Complete |
| APP-07 | Phase 1 | Complete |
| APP-08 | Phase 1 | Complete |
| CONT-01 | Phase 1 | Complete |
| CONT-02 | Phase 1 | Complete |
| CONT-03 | Phase 1 | Complete |
| CONT-04 | Phase 1 | Complete |
| CONT-05 | Phase 1 | Complete |
| CONT-06 | Phase 1 | Complete |
| CONT-07 | Phase 1 | Complete |
| CONT-08 | Phase 1 | Complete |
| LNX-01 | Phase 2 | Complete |
| LNX-02 | Phase 2 | Complete |
| LNX-03 | Phase 2 | Complete |
| LNX-04 | Phase 2 | Complete |
| LNX-05 | Phase 2 | Complete |
| LNX-06 | Phase 2 | Complete |
| LNX-07 | Phase 2 | Complete |
| LNX-08 | Phase 2 | Complete |
| LNX-09 | Phase 2 | Complete |
| LNX-10 | Phase 2 | Complete |
| LNX-11 | Phase 2 | Complete |
| NET-01 | Phase 3 | Complete |
| NET-02 | Phase 3 | Complete |
| NET-03 | Phase 3 | Complete |
| NET-04 | Phase 3 | Complete |
| NET-05 | Phase 3 | Complete |
| NET-06 | Phase 3 | Complete |
| NET-07 | Phase 3 | Complete |
| NET-08 | Phase 3 | Complete |
| NET-09 | Phase 3 | Complete |
| DOC-01 | Phase 4 | Complete |
| DOC-02 | Phase 4 | Complete |
| DOC-03 | Phase 4 | Complete |
| DOC-04 | Phase 4 | Complete |
| DOC-05 | Phase 4 | Complete |
| DOC-06 | Phase 4 | Complete |
| DOC-07 | Phase 4 | Complete |
| DOC-08 | Phase 4 | Complete |
| DOC-09 | Phase 4 | Complete |
| CAP-01 | Phase 4 | Complete |
| SYS-01 | Phase 5 | Complete |
| SYS-02 | Phase 5 | Complete |
| SYS-03 | Phase 5 | Complete |
| SYS-04 | Phase 5 | Complete |
| SYS-05 | Phase 5 | Complete |
| SYS-06 | Phase 5 | Complete |
| SYS-07 | Phase 5 | Pending |
| SYS-08 | Phase 5 | Pending |
| CICD-01 | Phase 5 | Complete |
| CICD-02 | Phase 5 | Complete |
| CICD-03 | Phase 5 | Complete |
| CICD-04 | Phase 5 | Complete |
| CICD-05 | Phase 5 | Complete |
| CICD-06 | Phase 5 | Complete |
| IAC-01 | Phase 6 | Pending |
| IAC-02 | Phase 6 | Pending |
| IAC-03 | Phase 6 | Pending |
| IAC-04 | Phase 6 | Pending |
| IAC-05 | Phase 6 | Pending |
| IAC-06 | Phase 6 | Pending |
| CLD-01 | Phase 6 | Pending |
| CLD-02 | Phase 6 | Pending |
| CLD-03 | Phase 6 | Pending |
| CLD-04 | Phase 6 | Pending |
| CLD-05 | Phase 6 | Pending |
| CLD-06 | Phase 6 | Pending |
| CLD-07 | Phase 6 | Pending |
| MON-01 | Phase 7 | Pending |
| MON-02 | Phase 7 | Pending |
| MON-03 | Phase 7 | Pending |
| MON-04 | Phase 7 | Pending |
| MON-05 | Phase 7 | Pending |
| MON-06 | Phase 7 | Pending |
| MON-07 | Phase 7 | Pending |
| CAP-02 | Phase 7 | Pending |

**Coverage:**
- v1 requirements: 80 total
- Mapped to phases: 80
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-18*
*Last updated: 2026-03-18 after roadmap creation — traceability corrected to match final phase assignments*
