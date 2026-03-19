# Phase 4: Docker & Foundation Capstone - Context

**Gathered:** 2026-03-19
**Status:** Ready for planning

<domain>
## Phase Boundary

Write all Docker lesson content (DOC-01 through DOC-07), build Docker-based exercises (DOC-08), create the module cheat sheet (DOC-09), and build the Foundation Capstone project (CAP-01). This phase produces curriculum content and a capstone that integrates Linux, networking, and Docker skills.

</domain>

<decisions>
## Implementation Decisions

### Docker Lesson Depth & Approach
- Very deep on container internals — DOC-01 demystifies containers completely: namespaces, cgroups, overlay FS traced back to Linux primitives they already learned
- Learner uses Docker directly on their local machine (already installed) — lessons use docker run, docker build, docker compose commands directly
- Dockerfile best practices (DOC-07) covers multi-stage builds, layer caching, .dockerignore, security (non-root user, minimal base images), health checks — with before/after comparisons showing image size reduction
- A simple Node.js or Python web app that learners Dockerize progressively across lessons (same app, building complexity)

### Foundation Capstone Design
- Open-ended project brief (not step-by-step) — learner must integrate Linux, networking, and Docker skills to deploy a multi-container app with shell automation
- Capstone app: 3-service Docker Compose app (web + API + database) requiring Dockerfiles, networking between services, shell script for deployment/health checks, file permissions setup
- Project brief with requirements and success criteria only — learner figures out the "how" themselves, with optional hint system (expandable hints in ExerciseCard)
- Comprehensive verify.sh that tests the entire deployed stack (services running, networking works, data persists, health checks pass)

### Content Organization
- Linear lesson ordering per REQUIREMENTS: what containers are → images → containers → volumes → networking → Compose → best practices → exercises → cheat sheet → capstone
- Module accent color: cyan (per Phase 1 CONTEXT decision)
- Capstone is the final lesson in the module (highest order number) — serves as module culmination
- Difficulty labels: DOC-01–03 Foundation; DOC-04–06 Intermediate; DOC-07 Intermediate; Capstone: Challenge

### Claude's Discretion
- Whether to use Node.js or Python for the progressive exercise app
- Exact capstone requirements and success criteria wording
- Specific Docker Compose configurations per exercise
- Exercise design specifics (what tasks, what verification checks)
- Callout placement and deep-dive content selection
- How to structure the capstone hint system (number and depth of hints)

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- All Phase 1 content components: CodeBlock, TerminalBlock, ExerciseCard, VerificationChecklist, Callout, QuickReference
- Phase 2 patterns: MDX lesson structure, verify.sh PASS/FAIL pattern, Docker base image approach
- Phase 3 patterns: Docker Compose multi-container labs, custom bridge networks, volume-mounted verify.sh
- lib/modules.ts filesystem scanning, search index, progress tracking — all working

### Established Patterns
- MDX frontmatter structure with moduleSlug, lessonSlug, order, difficulty, prerequisites
- Lesson section ordering: Overview → How It Works → Hands-On Exercise → Verification → Quick Reference
- Docker labs: setup scripts prepare environment, verify scripts check state with PASS/FAIL
- Content directory: content/modules/{moduleSlug}/ with numbered MDX files

### Integration Points
- New MDX files drop into content/modules/03-docker/ (or whatever slug is in index.ts) and auto-discovered
- Module index at content/modules/index.ts needs Docker module metadata
- Capstone exercise files go into docker/capstone/ or similar directory
- Sidebar auto-populates, search index rebuilds automatically

</code_context>

<specifics>
## Specific Ideas

- Container internals lesson must explicitly connect to Linux Fundamentals: "Remember namespaces from Lesson 5? Containers use those exact same kernel features"
- Progressive app across Docker lessons gives coherent learning arc — not just isolated exercises
- Capstone is deliberately open-ended to test real integration skills — this is the first time learner works without step-by-step guidance
- verify.sh for capstone must be thorough — it's the most complex verification in the course so far

</specifics>

<deferred>
## Deferred Ideas

- Kubernetes basics (ADV-01, v2)
- Container security scanning (ADV-03, v2)
- Performance tuning (ADV-04, v2)

</deferred>

---

*Phase: 04-docker-foundation-capstone*
*Context gathered: 2026-03-19*
