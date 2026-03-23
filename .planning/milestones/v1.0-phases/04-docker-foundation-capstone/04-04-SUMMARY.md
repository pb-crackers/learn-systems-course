---
phase: 04-docker-foundation-capstone
plan: "04"
subsystem: content
tags: ["cheat-sheet", "capstone", "docker", "mdx", "verify-sh", "shell-scripting"]
dependency_graph:
  requires: ["04-01", "04-02"]
  provides: ["docker-cheat-sheet", "foundation-capstone", "verify-sh"]
  affects: ["module-registry-count"]
tech_stack:
  added: []
  patterns: ["QuickReference per lesson", "ExerciseCard requirements-only steps", "verify.sh PASS/FAIL with exec -T and python3 JSON"]
key_files:
  created:
    - content/modules/03-docker/08-cheat-sheet.mdx
    - content/modules/03-docker/09-foundation-capstone.mdx
    - docker/capstone/api/app.js
    - docker/capstone/api/package.json
    - docker/capstone/web/index.html
    - docker/capstone/web/nginx.conf
    - docker/capstone/README.md
    - docker/capstone/verify.sh
  modified: []
decisions:
  - "verify.sh checks 7 criteria (3 services running separately, port 8080, inter-service networking, non-root uid, deploy.sh executable) — more granular than research pattern's 6-check example for clearer diagnostics"
  - "API starter code includes PostgreSQL integration when DATABASE_URL is set and falls back to in-memory array — learner doesn't need to write app logic, only Dockerize"
  - "Callout type deep-dive chosen for 'What You Are Practicing' section — cross-module skills summary fits deep-dive framing"
metrics:
  duration: 5min
  completed: "2026-03-19"
  tasks_completed: 2
  files_created: 8
---

# Phase 4 Plan 4: Docker Cheat Sheet and Foundation Capstone Summary

**One-liner:** Docker module cheat sheet (7 QuickReference sections) plus Foundation Capstone project with open-ended ExerciseCard, minimal starter code (Express API + nginx web), comprehensive verify.sh with 7 PASS/FAIL checks, and full project brief in README.md.

## What Was Built

### Task 1: Docker Module Cheat Sheet (DOC-09)

`content/modules/03-docker/08-cheat-sheet.mdx` — follows the exact Phase 2/3 pattern:
- Frontmatter: `moduleSlug: "03-docker"`, `order: 8`, `difficulty: "Foundation"`, `prerequisites: []`
- 7 QuickReference sections, one per lesson topic:
  1. Container Internals: namespace types (PID/NET/MNT/UTS/IPC/USER), cgroup files, overlay FS inspection
  2. Docker Images: build/inspect commands, all Dockerfile instructions (FROM/RUN/COPY/CMD/EXPOSE/WORKDIR/ENV/ENTRYPOINT)
  3. Docker Containers: run flags, exec, logs, stop/start/rm, stats, inspect
  4. Docker Volumes: create/ls/inspect/rm, named vs bind mount vs tmpfs
  5. Docker Networking: network create/ls/inspect, bridge/host/none drivers, container DNS
  6. Docker Compose: up/down/ps/logs/exec commands, compose.yml structure, healthcheck, profiles
  7. Dockerfile Best Practices: multi-stage FROM AS, .dockerignore entries, non-root USER, HEALTHCHECK, minimal base images table
- `Callout type="tip"` bridging to Foundation Capstone and Phase 5 (System Administration)

### Task 2: Foundation Capstone (CAP-01)

**`content/modules/03-docker/09-foundation-capstone.mdx`**
- Frontmatter: `order: 9`, `difficulty: "Challenge"`, `estimatedMinutes: 90`, prerequisites include `01-linux-fundamentals/07-shell-scripting`
- Overview with reassuring Callout explaining everything needed was already covered
- Architecture ASCII diagram showing browser → web → api → db with port annotations
- ExerciseCard with `difficulty="Challenge"` and 6 requirement-only steps (not instructions)
- VerificationChecklist with 7 items, each with expandable hints pointing to concepts not implementations
- Getting Started section with 5 pointer bullets
- What You Are Practicing deep-dive Callout mapping skills to all three foundation modules

**`docker/capstone/api/app.js`** — minimal Express API (~55 lines):
- `GET /health` returns `{ status: "healthy" }`
- `GET /api/items` queries PostgreSQL when `DATABASE_URL` is set, in-memory array fallback
- `POST /api/items` stores items in PostgreSQL or in-memory
- Listens on `process.env.PORT || 3000`

**`docker/capstone/api/package.json`** — `capstone-api`, express + pg dependencies

**`docker/capstone/web/index.html`** — vanilla JS frontend with fetch-based items list and add form

**`docker/capstone/web/nginx.conf`** — reverse proxy config with explanatory comments; proxies `/api/*` and `/health` to `http://api:3000`

**`docker/capstone/README.md`** — full project brief:
- Architecture ASCII diagram with port annotations
- Services table (web/api/db with image, port, notes)
- API contract with request/response examples
- Numbered requirements matching ExerciseCard steps
- Success criteria matching VerificationChecklist items
- No implementation hints (hints are MDX-only)

**`docker/capstone/verify.sh`** — 7 PASS/FAIL checks:
1. web service running (docker compose ps + python3 JSON)
2. api service running (same pattern)
3. db service running (same pattern)
4. web accessible on localhost:8080 (curl HTTP code check)
5. API reachable from web container via hostname 'api' (docker compose exec -T + curl)
6. API runs as non-root user (docker compose exec -T api id -u)
7. deploy.sh exists and is executable ([ -x ])

Anti-patterns honored:
- `$((PASS + 1))` not `((PASS++))` — safe under `set -e`
- `docker compose` not `docker-compose` — v2 subcommand
- `exec -T` in all in-script exec calls — prevents TTY hang
- `python3` for JSON parsing — universally available without jq
- `|| echo "missing"` fallbacks — graceful if services not running

## Verification Results

- `bash -n docker/capstone/verify.sh` — PASSED (syntax check)
- `npm run build` — PASSED (40 static pages, up from 39)
- `npm test` — PASSED (29/29 tests)

## Deviations from Plan

### Auto-fixed Issues

None — plan executed exactly as written.

### Notes

The research pattern showed 6 checks in verify.sh. This implementation uses 7 checks by splitting "all three services running" into three separate checks (one per service). This provides more targeted FAIL messages — the learner knows exactly which service failed rather than receiving a generic "stack not running" error.

The `09-foundation-capstone.mdx` file already existed as a stub from a prior plan with `difficulty: "Challenge"` frontmatter but only a "Coming Soon" body. The stub was replaced with the full capstone content.

## Self-Check: PASSED

| Item | Status |
|------|--------|
| content/modules/03-docker/08-cheat-sheet.mdx | FOUND |
| content/modules/03-docker/09-foundation-capstone.mdx | FOUND |
| docker/capstone/verify.sh | FOUND |
| docker/capstone/api/app.js | FOUND |
| docker/capstone/web/index.html | FOUND |
| docker/capstone/README.md | FOUND |
| commit 1005d78 (cheat sheet) | FOUND |
| commit b2cd457 (capstone) | FOUND |
