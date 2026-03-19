# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v1.0 — Learn Systems

**Shipped:** 2026-03-19
**Phases:** 7 | **Plans:** 27 | **Sessions:** ~6

### What Was Built
- Next.js 16 curriculum platform with dark-mode UI, sidebar navigation, progress tracking, Cmd+K search
- 8-module DevOps curriculum (56 lessons) with mechanism-first pedagogy
- Docker-based lab environments with PASS/FAIL verification scripts
- Full monitoring stack (Prometheus, Grafana, Alertmanager, Loki/Promtail)
- OpenTofu IaC exercises using local Docker provider
- 2 capstone projects — foundation (cross-module) and advanced (memory leak diagnosis)
- 80 requirements satisfied across application, content framework, and curriculum

### What Worked
- Wave-based parallel execution of independent plans within each phase significantly reduced wall-clock time
- Mechanism-first pattern established in Phase 2 scaled cleanly to all subsequent modules
- Docker Compose labs with verify.sh scripts provide reliable, repeatable exercises
- RESEARCH.md before each phase prevented version/API mistakes in exercises
- Prerequisite chain validation (69 links across 56 lessons) caught no broken links — good planning

### What Was Inefficient
- Phase 3 VERIFICATION.md captured a hostname bug (app vs app-server) that was subsequently fixed but the verification status was never updated — stale metadata persists
- ROADMAP.md progress tracking for Phases 3 and 4 shows stale "In Progress" counts despite all plans being complete
- Vitest lesson count assertions were not added for the first two modules (linux, networking) — only added starting from Phase 4

### Patterns Established
- Module structure: N lessons + cheat sheet + optional capstone, each with consistent frontmatter
- Lab structure: docker/{module}/{lesson-num}-{name}/compose.yml + setup.sh + verify.sh
- Compose profile pattern for optional services (Loki/Promtail as `profiles: ["loki"]`)
- QuickReference components as cheat sheet building blocks (one per lesson topic)
- Cross-module bridge callouts in "What's Next" sections linking modules to their successors

### Key Lessons
1. Research phases are essential for Docker/monitoring stacks — exact image versions and config patterns prevent exercise breakage
2. Capstone projects should provide starter code + verification, not step-by-step instructions — the challenge is synthesis
3. The memory leak pattern (silent leakStore + setInterval) is effective because it only manifests in metrics after 5+ minutes

### Cost Observations
- Model mix: ~30% opus (orchestration), ~70% sonnet (execution/verification)
- Sessions: ~6 (init, phases 1-2, phases 3-4, phases 5-6, phase 7, completion)
- Notable: Parallel plan execution within waves cut phase execution time roughly in half

---

## Cross-Milestone Trends

### Process Evolution

| Milestone | Sessions | Phases | Key Change |
|-----------|----------|--------|------------|
| v1.0 | ~6 | 7 | Initial milestone — established wave-based parallel execution |

### Cumulative Quality

| Milestone | Tests | Coverage | Lessons |
|-----------|-------|----------|---------|
| v1.0 | 34 | 6/8 modules tested | 56 |

### Top Lessons (Verified Across Milestones)

1. Research before planning prevents version/API mistakes in hands-on exercises
2. Mechanism-first pedagogy scales across module types (systems, networking, containerization, monitoring)
