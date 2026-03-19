# Project Research Summary

**Project:** learn-systems — Interactive DevOps & Systems Engineering Course
**Domain:** Local-first, file-based, self-paced technical course (repo-as-curriculum)
**Researched:** 2026-03-18
**Confidence:** HIGH (stack), HIGH (features), MEDIUM-HIGH (architecture), HIGH (pitfalls)

## Executive Summary

This project is a local-first, file-based DevOps and systems engineering course delivered entirely through a git repository. Research across comparable curricula and platforms confirms the strongest pattern for this format: a layered directory structure separating concepts (lessons), guided practice (exercises), and open scenarios (labs), with machine-checkable verification scripts per exercise. The course is not a documentation site — it is an interactive learning environment where the repo IS the medium. Docker Desktop and Multipass provide the lab runtime on macOS without cloud costs or external platform dependencies, which is the core differentiator against KodeKloud and similar subscription-based platforms.

The recommended approach builds in three phases. First, establish infrastructure and the module template with the Linux Fundamentals module — Linux gates every subsequent topic and establishes the "explain the mechanism before showing the command" pattern that defines course quality. Second, add Networking Foundations and Docker/Containerization as an interconnected tier, since Docker networking is just Linux networking with Docker branding on it. Third, extend to CI/CD, Infrastructure as Code, and monitoring as an advanced tier after the foundational skills are proven. A MkDocs Material site can be layered on at any point as an optional publishing step.

The single greatest risk to this course is what the research calls "tool-operator syndrome": exercises that teach command execution without explaining the underlying kernel subsystem, protocol, or system call. This produces learners who can follow recipes but cannot troubleshoot. The second-largest risk is lab environment brittleness — Docker images with unpinned versions or missing ARM Mac compatibility that cause learners to debug infrastructure rather than learn. Both risks must be addressed at the template level before any content is written, not patched retroactively.

---

## Key Findings

### Recommended Stack

The toolchain is purpose-built for a local-first, macOS-based DevOps course. Docker Desktop (4.65.0) is the primary lab runtime — it handles 80% of exercises that need a Linux environment. Multipass (1.16.1) fills the gaps where Docker is insufficient: systemd, init systems, kernel module exercises that require a real VM. The combination eliminates the need for cloud accounts entirely. Material for MkDocs (9.7.5) delivers the course site if publishing is desired; all Insiders features are now free as of 9.7.0. The `just` task runner standardizes every lab lifecycle to `just up`, `just reset`, `just verify` — a consistent interface across all modules. OpenTofu replaces HashiCorp Terraform for the IaC module, eliminating license confusion for learners.

**Core technologies:**
- Docker Desktop 4.65.0: primary lab runtime for all container-based exercises — industry standard (71% developer adoption), single install, supports Compose natively
- Multipass 1.16.1: lightweight Ubuntu VMs for systemd and kernel-level content — Docker alone cannot host these; Multipass is faster than VirtualBox on Apple Silicon
- Material for MkDocs 9.7.5: course site delivery if publishing is needed — all Insiders features free, pure Markdown, no Node.js required
- bats-core 1.13.0 + bats-assert + bats-support: exercise verification — TAP-compliant, learner runs `bats verify.bats` and sees PASS/FAIL per check
- just 1.47.1: lab lifecycle commands — cleaner than Make, self-documenting via `just --list`, cross-platform
- OpenTofu 1.11.0: IaC module labs — drop-in HCL compatibility with Terraform, MPL 2.0 license, no BUSL issues
- ShellCheck 0.11.0: lint gate on course shell scripts and a teachable tool in the shell scripting content

**Critical version requirements:**
- Docker Compose v2 only (bundled with Docker Desktop) — v1 is deprecated and EOL; exercises must use `docker compose` not `docker-compose`
- Multipass preferred over Vagrant+VirtualBox — VirtualBox has no Apple Silicon support as of 2026
- bats-support is a required dependency of bats-assert — both must be installed as git submodules

### Expected Features

Linux, Networking, and Docker are the non-negotiable v1 modules — every learner expects them and every subsequent module depends on them. Shell scripting is not a standalone module; it is woven into Linux Fundamentals and reinforced throughout. Machine-checkable verification scripts per exercise are the primary differentiator against text-based courses. "Under the hood" explanations (explaining kernel subsystems and protocols before showing commands) are the explicit value proposition of this course over tool-focused alternatives.

**Must have (table stakes — v1):**
- Linux Fundamentals module (filesystem, permissions, processes, shell, text tools, package management) — gates everything
- Networking Foundations module (OSI, TCP/IP, DNS, HTTP/S, SSH, firewalls) — prerequisite for Docker and cloud
- Docker/Containerization module (images, containers, volumes, networking, Compose) — highest learner demand
- Machine-checkable verification scripts per exercise — core differentiator; without this, exercises are documentation
- Local lab setup guide (Docker Desktop + macOS setup, Module 00) — learners cannot start without it
- "Under the hood" mechanism explanations per lesson — stated core value of the course
- Cheat sheet / REFERENCE.md per module — low cost, high retention value, persists after course

**Should have (add after v1 validation — v1.x):**
- CI/CD Pipelines module — requires Docker module to be solid; CI/CD without containers is incomplete
- System Administration module — natural progression after Linux and Networking
- Cross-module capstone (Linux + Networking + Docker) — integration skill; add when three foundation modules exist
- Progressive difficulty labels (Foundation / Intermediate / Challenge) — add when enough exercises exist to differentiate

**Defer (v2+):**
- Infrastructure as Code (OpenTofu) module — high complexity; defer until cloud context exists
- Cloud Fundamentals module — requires IaC context; lightweight given local-first constraint
- Monitoring & Observability module (Prometheus, Grafana) — multi-service lab complexity; defer until container networking is solid
- Kubernetes Basics module — explicitly deferred per project scope; add only after containers and networking are solid
- Advanced cross-module capstone (full CI/CD → Docker → Cloud pipeline) — requires all prior modules

### Architecture Approach

The architecture is a 4-layer repo: Course layer (module index), Module layer (numbered directories), Lesson layer (lessons/exercises/labs separation), and Verification layer (check.sh per exercise). The strict separation of lesson files (passive reading), exercise files (guided practice with machine-checkable outcomes), and lab files (open scenarios without step-by-step guidance) is the core architectural decision. It prevents monolithic files, enables per-exercise verification, and matches the three distinct cognitive modes: understanding, applying, and synthesizing. All exercise environments are disposable Docker containers or Multipass VMs — no host state is assumed.

**Major components:**
1. Module directories (`modules/NN-name/`) — ordered by numeric prefix; each contains `lessons/`, `exercises/`, `labs/`, `solutions/`; self-contained after prerequisites met
2. Exercise verification scripts (`check.sh`) — live adjacent to each exercise; assert system state (file permissions, process state, port open, command output); emit PASS/FAIL; exit 0/1
3. Lab environments (`docker-compose.yml` + `Dockerfile` per lab) — disposable, reproducible; learner runs `docker compose up`, works inside container, tears it down; no state leaks between labs
4. Shared base Docker image (`environments/base-linux/`) — all labs extend it; reduces build time and ensures consistent Linux starting state regardless of host OS
5. Module 00 setup verification — checks Docker, tools, and macOS prerequisites with clear error messages before learner touches content
6. Solutions directory (`solutions/`) — committed but not linked in main reading path; learner navigates there explicitly if stuck

**Key patterns:**
- Verification-first authoring: write `check.sh` before writing exercise README — defines "done" before describing "how to get there"
- Lesson → Exercise → Lab progression within each module is non-negotiable; no mixing content types into single files
- All exercises run inside Docker containers; no exercises assume host state beyond Docker availability
- Pin all Docker image versions (never `:latest`); document pinned versions in exercise frontmatter

### Critical Pitfalls

1. **Tool-operator syndrome** — teaching commands without explaining the underlying system (kernel subsystem, protocol, system call). Prevention: every tool introduction must be preceded by a "why this exists" section. Establish this pattern in Module 1 Linux Fundamentals; it infects all subsequent modules if not caught early.

2. **Lab environment brittleness** — Docker images with unpinned versions, ARM/Apple Silicon incompatibility, or host dependency assumptions. Prevention: establish a lab template with version pinning, explicit `--platform` flags, and a `verify-env.sh` pre-check before writing any exercises. Never use `:latest` tags. This is the highest-frequency cause of learner abandonment per research.

3. **Missing or ambiguous verification** — exercises that end with "you should see X" in prose rather than a runnable check command. Prevention: enforce a required `## Verification` section in every exercise template. Without machine-checkable verification, exercises become guesswork and self-paced abandonment rates spike.

4. **Scope inflation** — covering too many tools at surface level instead of building working fluency with fewer tools. Prevention: write competency goals before content; each module must have a stated goal the learner can demonstrate on a novel problem. This project already marks advanced Kubernetes and deep Ansible as out of scope — hold that line.

5. **Prerequisite order violations** — modules that implicitly require knowledge from prior modules not yet covered. Prevention: maintain an explicit prerequisite graph; list prerequisites at each module header; do a full sequential read-through at each milestone. The dependency chain is: Linux → Networking → Docker → CI/CD → IaC → Cloud → Monitoring.

6. **Read-heavy, do-light ratio** — lesson text vastly outnumbering exercise time. Prevention: target 40% explanation / 60% hands-on practice by time; enforce this in the lesson template by requiring inline "try this" prompts after every major concept block; no explanation section longer than 5 minutes without a hands-on prompt.

---

## Implications for Roadmap

The research establishes clear phase ordering based on three constraints: (1) cognitive dependency — each topic requires genuine prior knowledge, not just familiarity; (2) tool dependency — Docker must exist before CI/CD; (3) pitfall prevention — infrastructure templates must exist before content, and the "explain the mechanism first" pattern must be established in Phase 1 before it can be inherited.

### Phase 0: Infrastructure and Templates
**Rationale:** Nothing else works without this. Lab environment brittleness (Pitfall 2) and missing verification (Pitfall 4) must be solved at the template level before any content is written. Retrofitting these is expensive.
**Delivers:** Module 00 setup verification; shared base Docker image; exercise template (lesson/exercise/lab directory structure + check.sh pattern); justfile with `up`/`down`/`reset`/`verify` targets; bats submodule setup; confirmed macOS ARM compatibility
**Addresses:** Lab environment brittleness pitfall; missing verification pitfall; establishes repo structure for all subsequent phases
**Avoids:** The two highest-recovery-cost pitfalls are addressed structurally before any content exists
**Research flag:** Standard patterns — skip research-phase. Docker template structure and bats verification are well-documented.

### Phase 1: Linux Fundamentals
**Rationale:** Linux gates every subsequent module. More importantly, this phase establishes the "explain the mechanism first" pattern that must be inherited by all subsequent modules. If tool-operator syndrome takes root in Phase 1, every later module inherits it.
**Delivers:** Filesystem, permissions, processes, signals, shell scripting, text manipulation, package management — all with mechanism-first lesson structure; first working verification scripts; cheat sheet; module template proven in practice
**Addresses:** Table stakes feature: Linux Fundamentals module; table stakes feature: shell scripting woven through; differentiator: "under the hood" explanations
**Avoids:** Tool-operator syndrome (establish pattern here); prerequisite violations (this is the foundation)
**Research flag:** Standard patterns — skip research-phase. Linux fundamentals curriculum is well-established.

### Phase 2: Networking Foundations
**Rationale:** Networking must precede Docker because Docker networking (bridge networks, overlay networks, DNS between services) is implemented on Linux networking primitives. A learner who does not understand TCP/IP and DNS cannot troubleshoot Docker Compose service discovery.
**Delivers:** OSI model, TCP/IP, DNS, HTTP/HTTPS, SSH, firewalls (iptables/ufw) — all with Docker-based lab environments; multi-host networking labs using Docker Compose
**Addresses:** Table stakes feature: Networking Foundations module
**Avoids:** Prerequisite order violations — Docker module cannot be taught without this
**Research flag:** Standard patterns — skip research-phase.

### Phase 3: Docker and Containerization
**Rationale:** Docker is the highest-demand module and unlocks CI/CD, monitoring, and IaC labs. It must come after Networking (Docker networking requires prior understanding) but before CI/CD (pipelines build and push images).
**Delivers:** Images, containers, volumes, networking, Docker Compose — with scenario-based labs (broken containers, misconfigured networks); introduces multi-service lab environments that subsequent modules inherit
**Uses:** Docker Desktop 4.65.0, Docker Compose v2, just task runner, bats verification
**Addresses:** Table stakes feature: Docker/Containerization module; differentiator: local-first lab environments; differentiator: scenario-based exercises with failure modes
**Avoids:** ARM Mac compatibility (use explicit `--platform` declarations); Docker Compose v1 vs v2 syntax trap
**Research flag:** Standard patterns — skip research-phase. Docker curriculum patterns are well-documented.

### Phase 4: Foundation Capstone
**Rationale:** A capstone after the three foundation modules validates integration skills before adding new tool complexity. Forces the learner to combine Linux, networking, and Docker knowledge in one scenario without step-by-step guidance.
**Delivers:** Cross-module capstone project: deploy a real (non-toy) Dockerized web service, diagnose a networking failure, write a shell script to automate setup — produces a portfolio artifact
**Addresses:** Differentiator: cross-module capstone; differentiator: real-world scenarios not toy examples
**Avoids:** Scope inflation — capstone reuses skills from prior modules, introduces no new tools
**Research flag:** Needs research-phase during planning — defining a realistic, non-trivial scenario that validates all three prior modules without scope creeping into CI/CD territory requires careful design.

### Phase 5: System Administration and CI/CD
**Rationale:** System administration (process management, service configuration, logging) is a natural extension of Linux fundamentals and is required context for understanding what CI/CD pipelines are actually doing when they deploy services. CI/CD requires Docker (build/push images) and shell scripting (pipeline scripts).
**Delivers:** systemd, journald, log management, user/group management (sysadmin); GitHub Actions pipelines that build, test, and deploy Docker images (CI/CD); progressive difficulty labels introduced across all modules
**Uses:** Multipass for systemd exercises (Docker cannot host systemd); bats-core for CI pipeline verification; GitHub Actions as lowest-friction CI tool for local-first course
**Addresses:** Table stakes features: CI/CD module, System Administration module
**Avoids:** Premature introduction of Multipass (only introduced here when Docker is genuinely insufficient for systemd)
**Research flag:** CI/CD with GitHub Actions is well-documented (skip research-phase). Multipass for systemd exercises has less course-design documentation — light research warranted during planning.

### Phase 6: Infrastructure as Code
**Rationale:** IaC belongs after CI/CD because the most compelling IaC use case in this course is infrastructure provisioned by a pipeline, not manual `tofu apply`. Learners who understand CI/CD grasp why declarative infrastructure matters.
**Delivers:** OpenTofu HCL basics, local state, modules, a working pipeline that provisions infrastructure — with explicit competency goal: learner can write Terraform for a novel local environment without following a tutorial
**Uses:** OpenTofu 1.11.0, Docker-based lab targets for local IaC practice without cloud costs
**Addresses:** Table stakes feature: IaC module; anti-feature: avoids HashiCorp license confusion (OpenTofu)
**Avoids:** Scope inflation — IaC module has one stated competency goal; advanced state backends and remote runners are explicitly deferred
**Research flag:** OpenTofu 1.11.0 is a relatively recent version; state encryption feature introduced in 1.11 may have limited community documentation — research-phase recommended during planning.

### Phase 7: Cloud Fundamentals and Monitoring
**Rationale:** Cloud fundamentals can be lightweight in a local-first course because the networking and IaC modules already cover the underlying concepts (VPCs are just networks, security groups are just firewall rules). Monitoring (Prometheus, Grafana) requires multi-service Docker Compose environments that are only tractable after Docker and sysadmin are solid.
**Delivers:** Cloud conceptual layer (AWS/GCP core services mapped to prior networking/IaC concepts) with minimal free-tier exercises and explicit cost guardrails; Prometheus + Grafana monitoring stack for a Dockerized application with alerting basics
**Uses:** Docker Compose multi-service environments for monitoring labs; OpenTofu for any cloud provisioning exercises
**Addresses:** Table stakes features: Cloud Fundamentals, Monitoring & Observability
**Avoids:** Cloud-heavy labs with real cost (local-first constraint; explicit `terraform destroy` reminders); nested virtualization traps in monitoring labs (resource-limit all Compose services)
**Research flag:** Both modules have high implementation complexity and multi-service lab environments — research-phase recommended during planning for both.

### Phase 8: Advanced Capstone
**Rationale:** Final integration project requiring skills from all prior modules. Produces a portfolio-worthy artifact. Deferred until all prior modules are validated.
**Delivers:** Full pipeline capstone: Dockerized application with CI/CD pipeline, infrastructure provisioned with OpenTofu, monitoring with Prometheus/Grafana, deployed scenario with intentional failure to diagnose
**Addresses:** Differentiator: cross-module capstone (advanced tier)
**Research flag:** Needs research-phase during planning — scenario design for a capstone spanning this many modules is complex and needs deliberate scoping to avoid scope inflation.

### Phase Ordering Rationale

- **Cognitive dependency drives all ordering:** Linux → Networking → Docker → CI/CD → IaC → Cloud → Monitoring is the only sequence where every module builds on prior knowledge. Deviating from this creates prerequisite violations (Pitfall 5), the second-hardest pitfall to recover from.
- **Infrastructure first (Phase 0) prevents the two most expensive pitfalls:** Lab environment brittleness and missing verification have HIGH recovery costs if caught late. They are architectural — only fixable by establishing the template before content exists.
- **Capstones are placed after module tiers, not at the end:** Foundation capstone (Phase 4) validates before adding new tool complexity. This prevents scope inflation from creeping into the advanced tier.
- **IaC before Cloud:** Cloud fundamentals without IaC context produces click-through AWS console exercises that teach nothing transferable. IaC first means cloud concepts land as "things you provision with code."
- **Multipass introduced only when Docker is insufficient (Phase 5):** Introducing Multipass earlier adds toolchain complexity before learners need it.

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 4 (Foundation Capstone):** Capstone scenario design needs careful scoping to be genuinely non-trivial without scope creeping into Phase 5 tools.
- **Phase 6 (IaC):** OpenTofu 1.11.0 is recent; state encryption and new features may have limited course-design precedent. Verify exercise patterns against current docs.
- **Phase 7 (Cloud + Monitoring):** Multi-service monitoring lab environments have performance traps (large images, slow Compose startup). Need specific research on slim Prometheus/Grafana images and resource limits for macOS.
- **Phase 8 (Advanced Capstone):** Scenario scoping across all prior modules is the hardest design problem in the course.

Phases with standard patterns (skip research-phase):
- **Phase 0 (Infrastructure):** Docker template structure, bats setup, and just task runner patterns are well-documented.
- **Phase 1 (Linux Fundamentals):** Curriculum scope and lesson structure are the most well-documented area in technical education.
- **Phase 2 (Networking):** Networking fundamentals curriculum order is established; Docker Compose multi-host lab patterns are well-documented.
- **Phase 3 (Docker):** Docker curriculum patterns and bats verification integration are extensively documented in open-source course repos.
- **Phase 5 (Sysadmin + CI/CD):** GitHub Actions documentation is comprehensive; Multipass for systemd is documented (lighter research may still be useful).

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All tool versions verified against official release pages; Homebrew install paths confirmed; version compatibility table validated |
| Features | HIGH | Curriculum scope validated against roadmap.sh, bregman-arie/devops-exercises (2,624 exercises), and KodeKloud platform analysis; module ordering confirmed by feature dependency graph |
| Architecture | MEDIUM-HIGH | Directory structure pattern confirmed in multiple inspected open-source course repos; verification-first authoring pattern is sound but not universally documented; some patterns are reasoned from first principles |
| Pitfalls | HIGH | Key pitfalls corroborated by peer-reviewed sources (ACM, ResearchGate); Apple Silicon Docker issues confirmed by current 2026 technical sources; tool-operator syndrome pattern cited across multiple independent DevOps education sources |

**Overall confidence:** HIGH

### Gaps to Address

- **Ansible scope:** Research recommends covering Ansible basics in a configuration management module but notes this is genuinely hard to demonstrate locally without multiple VMs. The decision to include or exclude a dedicated Ansible module is not resolved by research alone. Address during roadmap planning by deciding if Multipass-hosted VMs are sufficient for Ansible lab environments or if it should remain a stretch module.
- **Kubernetes Basics timing:** Research defers Kubernetes to after containers and networking are solid but does not define what "solid" means in practice. Define the competency gate during roadmap planning (e.g., learner completes Docker module capstone before Kubernetes module unlocks).
- **Course site publishing (MkDocs):** Whether to publish a MkDocs site is an open decision. The stack supports it (Material for MkDocs 9.7.5 is in the recommended toolchain) but it is not required for the local-first format. Treat as optional infrastructure that can be added at any phase.
- **Content staleness strategy:** Research identifies content staleness as a medium-term risk. The mitigation (version metadata in lesson frontmatter + a "test the course" CI script) requires a concrete implementation decision during Phase 0 planning.

---

## Sources

### Primary (HIGH confidence)
- Docker Desktop release notes — https://docs.docker.com/desktop/release-notes/ — version 4.65.0 confirmed March 16, 2026
- bats-core GitHub releases — https://github.com/bats-core/bats-core — v1.13.0 confirmed November 2025
- ShellCheck GitHub releases — https://github.com/koalaman/shellcheck — v0.11.0 confirmed August 2025
- just GitHub releases — https://github.com/casey/just — v1.47.1 confirmed March 16, 2026
- mkdocs-material PyPI — https://pypi.org/project/mkdocs-material/ — 9.7.5 March 2026; Insiders free since 9.7.0
- OpenTofu official site — https://opentofu.org/ — v1.11.0 current stable
- Multipass GitHub releases — https://github.com/canonical/multipass — v1.16.1 latest stable
- moeinfatehi/LinuxForCyberSecurityCourse — inspected directly — numbered module directory pattern
- freeCodeCamp/learn-bash-scripting — inspected directly — step-based verification pattern
- bregman-arie/devops-exercises — inspected directly — 2,624 exercises; topic coverage reference
- roadmap.sh/devops — authoritative community consensus on DevOps topic ordering
- ACM Transactions on Computing Education — automated grading research — verification step importance
- ResearchGate: Effects of Technical Difficulties on Learning — peer-reviewed — environment brittleness and dropout
- Cognitive Load Theory and Instructional Design (eLearning Industry) — prerequisite ordering principles
- Running Docker on Apple Silicon (OneUptime 2026) — current ARM Docker issues

### Secondary (MEDIUM confidence)
- KodeKloud platform analysis — lab format and verification approach reference
- Lima CNCF blog — v2.0 features; alternative to Multipass for power users
- CMU Teaching Design — curriculum sequencing: simple-to-complex, dependency identification
- Le Wagon Blog: Why Self-Paced Courses Fail — feedback absence as primary abandonment cause
- Skytap: Self-Paced Hands-On Learning — lab guide structure patterns
- DEV Community: DevOps tool-operator syndrome — single source, corroborated by arXiv paper

### Tertiary (LOW confidence / inference)
- Vagrant vs VirtualBox macOS ARM limitations — HashiCorp documentation (not directly tested against current VirtualBox release)
- Katacoda shutdown 2023 — community knowledge, not directly verified against Red Hat announcement

---
*Research completed: 2026-03-18*
*Ready for roadmap: yes*
