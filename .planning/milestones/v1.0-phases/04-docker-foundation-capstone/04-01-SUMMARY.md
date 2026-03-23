---
phase: 04-docker-foundation-capstone
plan: "01"
subsystem: content
tags: [docker, containers, namespaces, cgroups, overlay-fs, dockerfile, mdx, node]

# Dependency graph
requires:
  - phase: 01-app-foundation
    provides: Next.js MDX pipeline, component library (ExerciseCard, VerificationChecklist, Callout, QuickReference, TerminalBlock)
  - phase: 02-linux-fundamentals
    provides: Linux lessons 03 (filesystem) and 05 (processes) that DOC-01 explicitly cross-references
provides:
  - DOC-01 lesson: container internals (namespaces, cgroups, overlay FS) with explicit Linux Fundamentals connections
  - DOC-02 lesson: Docker images (layers, Dockerfile instructions, build process, layer caching, registries)
  - DOC-03 lesson: container lifecycle (exec, logs, resource limits connected back to cgroups)
  - docker/app/ progressive exercise app (Express server + Dockerfile.basic) used DOC-02 through DOC-07
affects: [04-docker-foundation-capstone plan 02 and above, which build on the progressive app and reference these lessons]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Docker lesson exercises run commands on the HOST (not inside a container) — the subject of inspection is a container, the tool is docker CLI"
    - "Progressive app pattern: docker/app/ contains the starting point for each lesson's exercises — no prior-lesson dependency"
    - "TerminalBlock output lines use truncated 12-char container IDs (a1b2c3d4e5f6...) with 'Your output will differ' comments"

key-files:
  created:
    - content/modules/03-docker/01-what-are-containers.mdx
    - content/modules/03-docker/02-docker-images.mdx
    - content/modules/03-docker/03-docker-containers.mdx
    - docker/app/app.js
    - docker/app/package.json
    - docker/app/Dockerfile.basic
    - docker/app/.dockerignore
  modified: []

key-decisions:
  - "Progressive app uses Node.js (Express) — matches DevOps course reality, package.json structure makes layer caching lessons concrete"
  - "Dockerfile.basic uses FROM node:20 (full image, NOT alpine) — intentional for DOC-07 before/after size comparison (1.1GB vs ~150MB)"
  - "CMD ['node', 'app.js'] not CMD ['npm', 'start'] — node as PID 1 receives SIGTERM directly; npm as PID 1 can obscure signals"
  - "DOC-01 prerequisites include both 05-processes (PID namespaces) and 03-linux-filesystem (overlay FS) — both Linux lessons are directly referenced"
  - "docker/app/.dockerignore excludes node_modules — prevents local node_modules from overriding clean npm install inside container"

patterns-established:
  - "Docker module MDX uses moduleSlug: '03-docker' — confirmed from content/modules/index.ts registry"
  - "Mechanism-first lesson structure: container internals explained before CLI usage, consistent with Phase 2/3 pattern"
  - "cgroups connection pattern: DOC-03 resource limits section explicitly references cgroup files from DOC-01 deep-dive"

requirements-completed: [DOC-01, DOC-02, DOC-03]

# Metrics
duration: 7min
completed: 2026-03-19
---

# Phase 4 Plan 01: Docker Foundation Lessons Summary

**Three mechanism-first Docker Foundation lessons plus Express progressive exercise app — container internals (namespaces/cgroups/overlayFS) traced to Linux primitives, images lesson with layer caching, containers lesson with exec/logs/resource limits all backed by cgroup deep-dives**

## Performance

- **Duration:** 7 min
- **Started:** 2026-03-19T12:11:11Z
- **Completed:** 2026-03-19T12:18:00Z
- **Tasks:** 2
- **Files modified:** 7

## Accomplishments

- Created docker/app/ progressive exercise app: Express server with GET / and GET /health, package.json, Dockerfile.basic (intentionally full node:20 for DOC-07 size contrast), and .dockerignore
- Created DOC-01 (01-what-are-containers.mdx): deep-dive on all 6 namespace types, cgroup v2 hierarchy, overlay FS layer diagram, full docker run sequence ASCII, explicit callouts linking PID namespaces to LNX-05 and overlay FS to LNX-03
- Created DOC-02 (02-docker-images.mdx): image layer stack ASCII, all Dockerfile instructions with layer vs metadata distinction, EXPOSE warning callout, layer cache invalidation rules, build context and .dockerignore explanation, registry naming convention
- Created DOC-03 (03-docker-containers.mdx): full lifecycle state diagram, graceful shutdown SIGTERM explanation, docker exec vs docker attach warning, docker logs/inspect with key fields table, resource limits deep-dive connecting --memory/--cpus to cgroup file writes, exit code reference

## Task Commits

1. **Task 1: Progressive app source files and DOC-01 container internals lesson** - `3d030f0` (feat)
2. **Task 2: DOC-02 Docker images and DOC-03 container lifecycle lessons** - `25982f6` (feat)

## Files Created/Modified

- `docker/app/app.js` — Minimal Express server: GET / returns version JSON, GET /health returns uptime
- `docker/app/package.json` — docker-exercise-app v1.0.0 with express dependency (no lockfile — learners npm install inside container)
- `docker/app/Dockerfile.basic` — Single-stage node:20 Dockerfile with layer-caching comments on each instruction
- `docker/app/.dockerignore` — Excludes node_modules, npm-debug.log, .git, .env
- `content/modules/03-docker/01-what-are-containers.mdx` — DOC-01: namespaces/cgroups/overlayFS with Linux Fundamentals cross-references
- `content/modules/03-docker/02-docker-images.mdx` — DOC-02: image layers, Dockerfile instructions, build cache, registries
- `content/modules/03-docker/03-docker-containers.mdx` — DOC-03: lifecycle, exec, logs, resource limits, exit codes

## Decisions Made

- Progressive app uses Node.js (Express): package.json + node_modules structure makes layer caching lessons concrete; realistic for DevOps learners
- Dockerfile.basic uses `FROM node:20` (full ~1.1GB image, not alpine): intentionally oversized so DOC-07 can show dramatic before/after with multi-stage alpine build
- `CMD ["node", "app.js"]` not `CMD ["npm", "start"]`: node as PID 1 receives SIGTERM directly for graceful shutdown; this is tested in DOC-03 exercise
- DOC-01 deep-dive callouts reference both LNX-05 (processes → PID namespaces) and LNX-03 (filesystem → overlay FS) explicitly by lesson title
- DOC-03 resource limits section includes a deep-dive callout showing the exact cgroup file Docker writes to, connecting back to DOC-01 mechanism content

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- docker/app/ progressive exercise app is ready for DOC-04 (volumes) which adds file read/write to demonstrate named volumes and bind mounts
- Prerequisite chain established: DOC-04 depends on DOC-03, DOC-05 depends on DOC-03 and networking lesson, following pattern from research
- All 3 lessons render in the app at /modules/03-docker/ (confirmed via npm run build with 37 static pages)
- 28 existing tests pass — no regressions

---
*Phase: 04-docker-foundation-capstone*
*Completed: 2026-03-19*
