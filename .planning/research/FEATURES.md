# Feature Research

**Domain:** Interactive DevOps & Systems Engineering Course (local-first, file-based)
**Researched:** 2026-03-18
**Confidence:** HIGH (curriculum scope), MEDIUM (pedagogical format specifics)

## Feature Landscape

### Table Stakes (Users Expect These)

Features learners assume exist. Missing these = course feels incomplete or unprofessional.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Progressive module structure (foundations → advanced) | Every credible DevOps course follows the same arc: Linux → Networking → Containers → CI/CD → IaC → Cloud. Learners will be confused if order is wrong. | LOW | Order matters: each module assumes prior. Wrong order forces expensive backtracking. |
| Hands-on exercises for every lesson | "Learn by doing" is the defining value of this course. A lesson without an exercise is just documentation, not a course. | MEDIUM | Every lesson needs at minimum one practical task, not just reading. |
| Exercise verification steps | Learners must know when they've succeeded. Without verification, exercises are ambiguous — "did I do that right?" erodes confidence. | MEDIUM | Shell commands that produce deterministic expected output. Can be manual checks or small validation scripts. |
| Linux fundamentals module | Linux is the prerequisite for all DevOps work. Any course missing it assumes knowledge the target learner does not have. | MEDIUM | Filesystem, permissions, processes, shell, text manipulation, package management. |
| Networking foundations module | TCP/IP, DNS, HTTP, firewalls — learners who skip this can't troubleshoot anything in prod. | MEDIUM | Covers: OSI model, TCP/IP, DNS resolution, HTTP/HTTPS, SSH, firewalls (iptables/ufw). |
| Containerization module (Docker) | Docker is the entry point for modern DevOps work. Expected by anyone who has read a DevOps roadmap. | MEDIUM | Images, containers, volumes, networking, Compose — all five sub-topics expected. |
| CI/CD pipelines module | CI/CD is core to what DevOps means. Every major curriculum covers it. | MEDIUM | Build, test, deploy automation. GitHub Actions is the lowest-friction tool for local-first course. |
| Infrastructure as Code module | Terraform is now table stakes for DevOps practitioners. | HIGH | Terraform is the standard. CloudFormation is AWS-only; Pulumi is niche. Use Terraform. |
| Cloud fundamentals module | All DevOps work lands in cloud eventually. Learners expect it. | MEDIUM | Can be lightweight given local-first constraint — conceptual + minimal free-tier exercises. |
| Monitoring and observability module | The "three pillars" (metrics, logs, traces) are expected in any complete DevOps curriculum. | MEDIUM | Prometheus, Grafana, log aggregation basics. |
| Shell scripting coverage | Every DevOps engineer writes Bash. Learners entering this course expect to build this skill. | LOW | Can be woven through Linux fundamentals and automation modules rather than standalone. |
| Real-world scenarios (not toy examples) | Toy examples ("hello world" app) don't build confidence or portfolio value. Learners disengage. | HIGH | Each exercise should simulate a real task: deploying a web service, debugging a failing container, writing a Dockerfile for a real app. |
| Conceptual explanations of "why" | Learners who don't understand why something works can't troubleshoot when it breaks. This course explicitly targets understanding, not memorization. | MEDIUM | "How it works under the hood" sections in each lesson before or alongside the exercises. |
| macOS compatibility | The learner is on macOS. Any exercise requiring bare-metal Linux must use Docker or a VM. | MEDIUM | Document setup path clearly: Homebrew, Docker Desktop, or Multipass/Lima for VM-based labs. |

### Differentiators (Competitive Advantage)

Features that set this course apart. Not required, but valuable given the project's stated core value.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Bash verification scripts per exercise | Instead of "check if you got it right" being manual, a small bash script validates the state of the system. Instant, unambiguous feedback. This is rare in file-based courses. | MEDIUM | Example: `verify.sh` that checks if a service is running, a file has correct permissions, or a Docker container responds correctly. KodeKloud does this with a platform; this course does it with scripts. |
| Local-first lab environments (no cloud cost) | Most interactive DevOps courses require cloud accounts with real costs. Local Docker/VM labs remove the barrier completely. | HIGH | Docker Compose for multi-service labs; Lima/Multipass for VM-based Linux exercises on macOS. Reproducible via `docker compose up`. |
| "Under the hood" explanations alongside exercises | Most courses are tool-focused ("here's how to use kubectl") without explaining kernel namespaces, cgroups, etc. Explaining the mechanism builds mental models that survive tool churn. | MEDIUM | Example: when teaching Docker, explain what namespaces and cgroups actually do before showing the commands. |
| Scenario-based exercises with real failure modes | Exercises that simulate real incidents (misconfigured firewall, broken DNS, failed deployment) teach troubleshooting, not just happy-path setup. | HIGH | Requires intentionally broken lab environments to debug — more engaging than "run this command and observe output". |
| Cheat sheets and reference files per module | Quick-reference command sheets that persist after the course. Learners keep the repo as a reference resource. | LOW | One `REFERENCE.md` per module with the most useful commands and flags. Competitors (KodeKloud) don't provide this persistently. |
| Progressive complexity within modules | Each module has beginner → intermediate exercises. Learners can go deep or move on. Avoids the "too easy then suddenly too hard" cliff. | MEDIUM | Label exercises: Foundation / Intermediate / Challenge. |
| Cross-module capstone projects | A project that requires skills from multiple modules (e.g., "deploy a Dockerized app with a CI/CD pipeline that runs tests and pushes to a registry"). Builds integration skills. | HIGH | One capstone per major phase (Linux+Networking, Containers+CI/CD, IaC+Cloud). |
| Git-native course structure | The course lives in a git repo. Learners fork it, commit their exercise answers, and build a real portfolio artifact. | LOW | This is an architecture choice as much as a feature, but communicates seriousness about the learning format. |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems, or that scope creep would push toward.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Video content | "Real" courses have videos; text feels less legitimate to some learners. | Out of scope per PROJECT.md. More importantly: videos go stale fast when tool UIs change. Text + code blocks are searchable, versionable, and durable. | High-quality, opinionated prose + annotated code blocks teach as well as video for technical skills. |
| Multi-user LMS platform (progress tracking, accounts) | Feels like a "real" course platform. Learners expect Coursera-style progress bars. | Requires significant infrastructure (auth, DB, frontend). Adds cost, complexity, and maintenance burden. Out of scope per PROJECT.md. | Use markdown checklists (`- [ ]`) in exercise files that learners check off manually. Git history serves as progress log. |
| Certification exam preparation | Certifications (AWS SAA, CKA, LFCS) are a common upsell. | Shifts focus from deep understanding to memorizing what's on the exam. These are different skills. Exam prep content is specifically excluded in PROJECT.md. | Practical skills from this course are better preparation for real work than exam prep. Note in README that certifications can be pursued separately. |
| Advanced Kubernetes orchestration (Helm, operators, multi-cluster) | Kubernetes is hot and learners want to learn "all of it". | K8s orchestration has a steep complexity cliff. Introducing advanced K8s before learners understand Linux/networking leads to cargo-culting. Explicitly deferred in PROJECT.md. | Cover K8s basics (pods, deployments, services, configmaps) thoroughly. Mark advanced topics as "next steps" with external references. |
| Cloud-heavy labs with real cost | Cloud labs feel "real" — learners want to practice on actual AWS/GCP. | Incurs costs. Requires account setup. Cloud console UIs change. A learner running 10 exercises might accumulate a bill. | Local Docker/VM labs reproduce 80% of what matters. For cloud-specific concepts, use free tier + explicit cost guardrails + `terraform destroy` reminders. |
| Gamification (badges, points, leaderboards) | Engagement mechanics feel motivating. | Gamification adds significant platform complexity for marginal pedagogical value. Often distracts from depth. | Natural gamification via: verification scripts that pass/fail, capstone projects that produce working systems, git commit history showing progress. |
| AI-generated exercise auto-grading | Trendy in 2025/2026 DevOps training. | Fragile — bash commands have many valid forms. False negatives demotivate. Building a reliable auto-grader is an engineering project in itself. | Script-based verification checks specific state (is port 8080 open? does `curl localhost` return 200?) rather than parsing learner commands. Deterministic and maintainable. |
| Configuration management deep-dive (Ansible, Chef, Puppet) | Listed as a curriculum topic broadly. | For a single-learner local course, configuration management adds complexity before the learner needs it. The value of Ansible appears when managing multiple servers — hard to demonstrate locally without VMs. | Cover Ansible basics in the automation module. Focus on use cases (idempotent server config, playbooks) rather than full coverage. |

## Feature Dependencies

```
[Linux Fundamentals]
    └──required by──> [Shell Scripting]
    └──required by──> [Networking Foundations]
    └──required by──> [System Administration]
    └──required by──> [Docker / Containerization]
    └──required by──> [All subsequent modules]

[Shell Scripting]
    └──required by──> [CI/CD Pipelines]
    └──required by──> [Bash Verification Scripts]

[Networking Foundations]
    └──required by──> [Docker Networking]
    └──required by──> [Cloud Fundamentals]
    └──required by──> [Firewalls / Security]

[Docker / Containerization]
    └──required by──> [CI/CD Pipelines] (build/push images)
    └──required by──> [Kubernetes Basics]
    └──required by──> [Local Lab Environments]

[CI/CD Pipelines]
    └──required by──> [Cross-Module Capstone: App Deploy Pipeline]
    └──enhances──> [Infrastructure as Code] (deploy infra via pipeline)

[Infrastructure as Code (Terraform)]
    └──required by──> [Cloud Fundamentals labs]
    └──enhances──> [Cross-Module Capstone: IaC + Cloud]

[System Administration]
    └──required by──> [Monitoring & Observability]

[Monitoring & Observability]
    └──enhances──> [Cross-Module Capstone: Production Readiness]

[Exercise Verification Scripts]
    └──requires──> [Shell Scripting] (to write them)
    └──enhances──> [All Exercises]

[Local Lab Environments (Docker Compose / VMs)]
    └──required by──> [Linux Exercises on macOS]
    └──required by──> [Multi-service CI/CD labs]
    └──required by──> [Networking labs requiring multiple hosts]
```

### Dependency Notes

- **Linux Fundamentals gates everything:** Every subsequent module assumes shell fluency, process understanding, and filesystem knowledge. It must be module 1 with no shortcuts.
- **Docker before CI/CD:** CI/CD pipelines in modern DevOps build and push container images. If learner doesn't understand Docker, the CI/CD labs are magic.
- **Networking before Cloud:** Cloud fundamentals (VPCs, load balancers, security groups) are just networking concepts with AWS/GCP brand names on them. Learners who skip networking memorize console clicks without understanding.
- **Shell scripting woven throughout:** Not a standalone module — introduce in Linux Fundamentals and reinforce in every subsequent module.
- **Verification scripts enhance all exercises:** They're a cross-cutting feature. Build the pattern in Module 1 (Linux) and reuse it everywhere.
- **Local lab environments conflict with cloud-heavy labs:** Choosing local-first means cloud labs must be lightweight by design. This is a constraint that shapes the entire course.

## MVP Definition

### Launch With (v1)

Minimum viable course — validates the format, delivers core value.

- [ ] Linux Fundamentals module — foundational; gates all other modules
- [ ] Networking Foundations module — second prerequisite; required before containers or cloud
- [ ] Docker / Containerization module — most immediately applicable, highest learner demand
- [ ] Bash verification scripts per exercise — core differentiator; establishes the format
- [ ] Local lab setup guide (Docker Desktop + macOS setup) — without this, learners can't start
- [ ] "Under the hood" explanations in each lesson — stated core value of the course
- [ ] Cheat sheets / reference files per module — low complexity, high retention value

### Add After Validation (v1.x)

Features to add once the module format is proven and working.

- [ ] CI/CD Pipelines module — add when Docker module is solid; CI/CD without containers is incomplete
- [ ] System Administration module — add alongside or after networking; natural progression
- [ ] Cross-module capstone (Linux + Networking + Docker) — add when three foundation modules are complete
- [ ] Progressive difficulty labeling (Foundation / Intermediate / Challenge) — add when enough exercises exist to differentiate

### Future Consideration (v2+)

Features to defer until core modules are validated.

- [ ] Infrastructure as Code (Terraform) module — high complexity; depends on understanding cloud concepts; defer until cloud module is solid
- [ ] Cloud Fundamentals module — requires IaC context and local-first workarounds to be worth doing
- [ ] Monitoring & Observability module — high complexity multi-service lab environments; defer until container networking is solid
- [ ] Cross-module capstone (full CI/CD → Docker → Cloud pipeline) — requires all prior modules
- [ ] Kubernetes Basics module — deferred per PROJECT.md; add only after containers + networking are solid

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Linux Fundamentals module | HIGH | MEDIUM | P1 |
| Networking Foundations module | HIGH | MEDIUM | P1 |
| Docker / Containerization module | HIGH | MEDIUM | P1 |
| Bash verification scripts per exercise | HIGH | MEDIUM | P1 |
| Local lab setup (Docker Compose + macOS) | HIGH | LOW | P1 |
| "Under the hood" explanations | HIGH | LOW | P1 |
| Shell scripting (woven through) | HIGH | LOW | P1 |
| Cheat sheets / reference files | MEDIUM | LOW | P1 |
| CI/CD Pipelines module | HIGH | MEDIUM | P2 |
| System Administration module | HIGH | MEDIUM | P2 |
| Cross-module capstone (foundation tier) | HIGH | HIGH | P2 |
| Progressive difficulty labels | MEDIUM | LOW | P2 |
| Infrastructure as Code (Terraform) | HIGH | HIGH | P3 |
| Cloud Fundamentals module | MEDIUM | HIGH | P3 |
| Monitoring & Observability module | HIGH | HIGH | P3 |
| Kubernetes Basics module | MEDIUM | HIGH | P3 |
| Cross-module capstone (advanced tier) | HIGH | HIGH | P3 |

**Priority key:**
- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## Competitor Feature Analysis

| Feature | KodeKloud | TechWorld with Nana | This Course (Planned) |
|---------|-----------|---------------------|------------------------|
| Exercise format | Browser-based interactive labs, auto-graded | Follow-along video demos + self-directed exercises | Markdown lessons + bash verification scripts |
| Lab environment | Cloud-hosted sandbox (browser terminal) | Local VMs + cloud | Local Docker/VM — reproducible, no cost |
| Verification | Platform auto-grades | Self-assessed | Bash scripts checking system state |
| Content permanence | Platform-dependent; subscription expires | Platform-dependent | Git repo — owned permanently, forkable |
| "Why" explanations | Minimal — tool-focused | Moderate — some conceptual | Explicit — "under the hood" per lesson |
| Cost | ~$20/month subscription | $100+ one-time | Free (repo) |
| Progression structure | Learning paths with levels | Linear bootcamp | Progressive modules, labeled difficulty |
| Real scenarios | Moderate — mostly happy path | Moderate | Explicit goal — scenario-based + failure modes |
| Reference materials | Some cheatsheets | Handouts per module | Cheat sheet per module in repo |
| Portability | Cannot use offline | Video offline, labs require platform | Fully offline after initial setup |

## Sources

- [roadmap.sh DevOps Roadmap](https://roadmap.sh/devops) — authoritative community consensus on topic ordering (HIGH confidence)
- [KodeKloud Platform](https://kodekloud.com) — leading hands-on DevOps platform; reference for lab format (MEDIUM confidence — marketing site)
- [bregman-arie/devops-exercises](https://github.com/bregman-arie/devops-exercises) — 2,624 community exercises; reference for topic coverage (HIGH confidence)
- [dth99/DevOps-Learn-By-Doing](https://github.com/dth99/DevOps-Learn-By-Doing) — community curated labs; reference for exercise types (MEDIUM confidence)
- [shiftkey-labs/DevOps-Foundations-Course](https://github.com/shiftkey-labs/DevOps-Foundations-Course) — structured course format reference (MEDIUM confidence)
- [milanm/DevOps-Roadmap](https://github.com/milanm/DevOps-Roadmap) — 2026 roadmap with learning resources (MEDIUM confidence)
- [KodeKloud 2025 DevOps Course Guide](https://kodekloud.com/blog/best-devops-courses-in-2025/) — industry analysis of course features (MEDIUM confidence)
- [DEV Community: 10 DevOps Mistakes Beginners Make](https://dev.to/devops_descent/10-devops-mistakes-beginners-make-and-how-to-avoid-them-2e7i) — pitfall research (MEDIUM confidence)

---
*Feature research for: Interactive DevOps & Systems Engineering Course*
*Researched: 2026-03-18*
