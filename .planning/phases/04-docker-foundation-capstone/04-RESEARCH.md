# Phase 4: Docker & Foundation Capstone - Research

**Researched:** 2026-03-19
**Domain:** Docker internals (namespaces/cgroups), MDX lesson content authoring, Docker Compose multi-container labs, capstone project design
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Docker Lesson Depth & Approach**
- Very deep on container internals — DOC-01 demystifies containers completely: namespaces, cgroups, overlay FS traced back to Linux primitives they already learned
- Learner uses Docker directly on their local machine (already installed) — lessons use docker run, docker build, docker compose commands directly
- Dockerfile best practices (DOC-07) covers multi-stage builds, layer caching, .dockerignore, security (non-root user, minimal base images), health checks — with before/after comparisons showing image size reduction
- A simple Node.js or Python web app that learners Dockerize progressively across lessons (same app, building complexity)

**Foundation Capstone Design**
- Open-ended project brief (not step-by-step) — learner must integrate Linux, networking, and Docker skills to deploy a multi-container app with shell automation
- Capstone app: 3-service Docker Compose app (web + API + database) requiring Dockerfiles, networking between services, shell script for deployment/health checks, file permissions setup
- Project brief with requirements and success criteria only — learner figures out the "how" themselves, with optional hint system (expandable hints in ExerciseCard)
- Comprehensive verify.sh that tests the entire deployed stack (services running, networking works, data persists, health checks pass)

**Content Organization**
- Linear lesson ordering per REQUIREMENTS: what containers are → images → containers → volumes → networking → Compose → best practices → exercises → cheat sheet → capstone
- Module accent color: cyan (per Phase 1 CONTEXT decision) — CSS var `--color-module-docker` at `oklch(0.70 0.15 195)`
- Capstone is the final lesson in the module (highest order number) — serves as module culmination
- Difficulty labels: DOC-01–03 Foundation; DOC-04–06 Intermediate; DOC-07 Intermediate; Capstone: Challenge

### Claude's Discretion
- Whether to use Node.js or Python for the progressive exercise app
- Exact capstone requirements and success criteria wording
- Specific Docker Compose configurations per exercise
- Exercise design specifics (what tasks, what verification checks)
- Callout placement and deep-dive content selection
- How to structure the capstone hint system (number and depth of hints)

### Deferred Ideas (OUT OF SCOPE)
- Kubernetes basics (ADV-01, v2)
- Container security scanning (ADV-03, v2)
- Performance tuning (ADV-04, v2)
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| DOC-01 | Lesson on what containers are — namespaces, cgroups, how containers actually work under the hood | Linux kernel primitives (namespaces, cgroups, overlay FS) directly connect to LNX-02/LNX-05 prior knowledge; docker inspect, /proc exploration patterns |
| DOC-02 | Lesson on Docker images — layers, Dockerfile, build process, registries | Dockerfile FROM/RUN/COPY/CMD patterns; docker image inspect showing layer IDs; docker build output tracing each layer; docker hub pull patterns |
| DOC-03 | Lesson on Docker containers — lifecycle, exec, logs, resource limits | docker run/start/stop/rm lifecycle; docker exec for interactive access; docker logs; --memory/--cpus flags for resource limits; docker stats |
| DOC-04 | Lesson on Docker volumes — bind mounts, named volumes, data persistence | docker volume create/ls/rm; -v flag patterns; bind mount vs named volume distinction; data persistence across container restarts |
| DOC-05 | Lesson on Docker networking — bridge, host, overlay, DNS between containers | docker network create/inspect; container hostname resolution; --network flag; bridge/host/none driver patterns; connects to Phase 3 networking knowledge |
| DOC-06 | Lesson on Docker Compose — multi-service apps, depends_on, environment variables, profiles | compose.yml spec; progressive app growing from single to multi-service; environment/env_file; depends_on with condition; healthcheck; profiles |
| DOC-07 | Lesson on Dockerfile best practices — multi-stage builds, layer caching, security | multi-stage FROM AS; .dockerignore; non-root USER; minimal base images; HEALTHCHECK instruction; before/after image size comparison |
| DOC-08 | Hands-on exercises for each Docker lesson with real application scenarios | Progressive app (Node.js or Python) Dockerized incrementally across lessons; verify.sh checks container state, network connectivity, data persistence |
| DOC-09 | Module cheat sheet with Docker commands and concepts | QuickReference component per lesson topic; follows Phase 2/3 pattern as final regular-lesson MDX before capstone |
| CAP-01 | Foundation capstone — deploy a Dockerized web app, diagnose network issues, automate with shell scripts | Open-ended ExerciseCard with requirements + success criteria; 3-service Compose app; verify.sh tests entire deployed stack; VerificationChecklist hints for each success criterion |
</phase_requirements>

---

## Summary

Phase 4 is a content-authoring and Docker infrastructure phase — the Next.js platform is fully operational and requires zero new npm dependencies. The critical new elements compared to Phases 2 and 3 are: (1) Docker-based content (not just labs — the lessons themselves teach Docker commands run directly on the host), (2) a progressive app that grows in complexity across lessons, and (3) the Foundation Capstone which is the first open-ended project in the course.

The canonical Docker module slug is `'03-docker'` as defined in `content/modules/index.ts`. All MDX files must use `moduleSlug: "03-docker"` in frontmatter, and content lives in `content/modules/03-docker/`. The accent color `'docker'` is already defined in globals.css at `oklch(0.70 0.15 195)` — a teal/cyan hue. Both the module registry and CSS variable are fully wired and confirmed.

The Docker labs differ fundamentally from Phase 3 networking labs: Docker lessons teach Docker itself, so exercises run `docker` commands directly on the host machine (not inside a container). The exercise environment for DOC-01 through DOC-07 is the learner's own terminal. Only certain deep-dive exercises (container internals inspection) need a container as the subject being examined. The capstone (CAP-01) uses Docker Compose because the learner builds the multi-container stack themselves as the project artifact.

**Primary recommendation:** Write MDX lessons first (DOC-01 through DOC-07) as the critical path, build the progressive exercise app scaffolding in a focused plan, wire the module index registration, deliver the cheat sheet, and treat the capstone as a standalone plan due to its verify.sh complexity.

---

## Standard Stack

### Core — No new npm dependencies needed

Phase 4 adds zero new npm packages. All tools were installed in Phase 1.

| Tool | Version | Purpose | Notes |
|------|---------|---------|-------|
| `@next/mdx` | 16.2.0 | Compiles MDX at build time | Already configured in `next.config.ts` |
| `gray-matter` | 4.0.3 | Frontmatter parsing | Used in `lib/mdx.ts` — no changes needed |
| `rehype-pretty-code` | 0.14.3 | Syntax highlighting | Configured with `one-dark-pro` theme |
| `remark-gfm` | 4.0.1 | Tables, task lists in MDX | Already in MDX pipeline |
| Docker | 27.4.0 (host) | Lab runtime AND lesson subject | Lessons teach Docker commands directly |
| Docker Compose | v2.31.0 (host) | Multi-container capstone orchestration | `docker compose` subcommand — no hyphen |

### Supporting — Docker images for exercise app

The progressive exercise app (DOC-01 through DOC-07) and capstone (CAP-01) need container images. Recommendation: use **Node.js** for the progressive app (Claude's discretion — chosen here because Node.js apps have a natural multi-file structure that demonstrates Dockerfile COPY patterns clearly, and most DevOps learners encounter Node.js deployments in real work).

| Image | Tag | Purpose | Why This Choice |
|-------|-----|---------|----------------|
| `node` | `20-alpine` | Progressive exercise app base | LTS, Alpine keeps image small — good for demonstrating multi-stage build benefit |
| `node` | `20` (full) | Before comparison in DOC-07 | ~1.1GB vs ~150MB for Alpine — dramatic contrast for layer optimization lesson |
| `postgres` | `16-alpine` | Capstone database service | Official, Alpine, widely used in real work; connects to Phase 4 data persistence |
| `nginx` | `alpine` | Capstone web/reverse-proxy service | Already used in Phase 3 networking labs; familiar to learner |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `node:20-alpine` for app | `python:3.12-slim` | Python is also valid; Node chosen because Dockerfile COPY of package.json + lock file demonstrates layer caching more explicitly |
| `postgres:16-alpine` for capstone DB | `redis:alpine` | Postgres requires more setup (env vars, health check, data directory) which teaches more; Redis is simpler but less representative |
| Progressive app growing across lessons | Isolated per-lesson apps | Progressive app creates coherent learning arc — learner sees their app evolve; isolated apps would feel disconnected |

**Installation:** No npm install needed. Docker images are pulled automatically on first use.

---

## Architecture Patterns

### Recommended Project Structure

```
content/
└── modules/
    └── 03-docker/
        ├── 01-what-are-containers.mdx     (DOC-01, Foundation)
        ├── 02-docker-images.mdx           (DOC-02, Foundation)
        ├── 03-docker-containers.mdx       (DOC-03, Foundation)
        ├── 04-docker-volumes.mdx          (DOC-04, Intermediate)
        ├── 05-docker-networking.mdx       (DOC-05, Intermediate)
        ├── 06-docker-compose.mdx          (DOC-06, Intermediate)
        ├── 07-dockerfile-best-practices.mdx (DOC-07, Intermediate)
        ├── 08-cheat-sheet.mdx             (DOC-09, Foundation, order: 8)
        └── 09-foundation-capstone.mdx     (CAP-01, Challenge, order: 9)

docker/
└── app/
    ├── README.md                          (explains progressive app)
    ├── Dockerfile.basic                   (DOC-02: single-stage, no best practices)
    ├── Dockerfile.optimized               (DOC-07: multi-stage, .dockerignore, non-root)
    ├── app.js                             (or app.py — the progressive exercise app)
    ├── package.json                       (if Node.js)
    └── .dockerignore

docker/
└── capstone/
    ├── README.md                          (capstone project brief — same content as MDX)
    ├── compose.yml                        (learner's starting point — empty or minimal scaffold)
    ├── web/
    │   └── (intentionally empty — learner creates Dockerfile)
    ├── api/
    │   └── (intentionally empty — learner creates Dockerfile + app code)
    ├── deploy.sh                          (learner creates this — deploy.sh template stub)
    └── verify.sh                         (provided — comprehensive stack verification)
```

Notes:
- Cheat sheet uses `order: 8`, capstone uses `order: 9` — capstone is the final lesson
- `docker/app/` contains the progressive exercise app used in DOC-02 through DOC-07
- `docker/capstone/` contains the capstone scaffold — learner fills it in
- DOC-01 (container internals) uses `docker run` commands on host only — no separate lab directory needed

### Pattern 1: MDX Frontmatter for Docker Module

The `moduleSlug` MUST be `"03-docker"` — confirmed from `content/modules/index.ts`. The accentColor `'docker'` maps to `--color-module-docker` in globals.css.

```mdx
---
title: "What Are Containers?"
description: "Namespaces, cgroups, and overlay filesystems — how containers use Linux kernel features you already know"
module: "Docker & Containerization"
moduleSlug: "03-docker"
lessonSlug: "01-what-are-containers"
order: 1
difficulty: "Foundation"
estimatedMinutes: 22
prerequisites: ["01-linux-fundamentals/05-processes", "01-linux-fundamentals/03-linux-filesystem"]
tags: ["containers", "namespaces", "cgroups", "overlay-fs", "docker"]
---
```

DOC-01 requires both `05-processes` (PID namespaces) and `03-linux-filesystem` (overlay FS) as prerequisites — these are the Linux Fundamentals lessons that directly map to container internals.

### Pattern 2: Lesson Prerequisite Chain

```
DOC-01: prerequisites: ["01-linux-fundamentals/05-processes", "01-linux-fundamentals/03-linux-filesystem"]
DOC-02: prerequisites: ["03-docker/01-what-are-containers"]
DOC-03: prerequisites: ["03-docker/02-docker-images"]
DOC-04: prerequisites: ["03-docker/03-docker-containers"]
DOC-05: prerequisites: ["03-docker/03-docker-containers", "02-networking/02-tcp-ip-stack"]
DOC-06: prerequisites: ["03-docker/04-docker-volumes", "03-docker/05-docker-networking"]
DOC-07: prerequisites: ["03-docker/02-docker-images", "03-docker/03-docker-containers"]
DOC-09 (cheat sheet): prerequisites: []
CAP-01 (capstone): prerequisites: ["03-docker/06-docker-compose", "03-docker/07-dockerfile-best-practices", "01-linux-fundamentals/07-shell-scripting"]
```

DOC-05 (networking) depends on the TCP/IP stack lesson from Phase 3 — the lesson explicitly bridges Docker networking primitives back to Linux bridge networks the learner saw in networking labs. The capstone requires shell scripting (deploy.sh) in addition to Compose and best practices.

### Pattern 3: Docker Lesson Exercise Pattern (Host-Native Commands)

Docker lessons DOC-01 through DOC-07 use a different lab pattern than Phases 2 and 3. The learner runs Docker commands directly in their terminal on the host — they are NOT inside a container. The subject of inspection is a container, but the tool is Docker on the host.

**TerminalBlock pattern for Docker exercises:**

```mdx
<TerminalBlock
  title="Inspect namespace isolation"
  lines={[
    { type: 'comment', content: 'Start a container in the background' },
    { type: 'command', content: 'docker run -d --name mybox ubuntu:22.04 sleep infinity' },
    { type: 'output', content: 'a1b2c3d4e5f6...' },
    { type: 'comment', content: 'Find its PID from the host perspective' },
    { type: 'command', content: 'docker inspect mybox --format "{{.State.Pid}}"' },
    { type: 'output', content: '12345' },
    { type: 'comment', content: 'See its namespace links — same kernel, isolated view' },
    { type: 'command', content: 'ls -la /proc/12345/ns/' },
    { type: 'output', content: 'lrwxrwxrwx 1 root root 0 ... ipc -> ipc:[4026532345]' },
    { type: 'output', content: 'lrwxrwxrwx 1 root root 0 ... net -> net:[4026532346]' },
    { type: 'output', content: 'lrwxrwxrwx 1 root root 0 ... pid -> pid:[4026532347]' },
    { type: 'comment', content: 'Clean up' },
    { type: 'command', content: 'docker rm -f mybox' },
  ]}
/>
```

### Pattern 4: Progressive App Architecture

The same small app is used across lessons DOC-02 through DOC-07, growing in complexity:

| Lesson | App Evolution | What It Demonstrates |
|--------|--------------|---------------------|
| DOC-02 (images) | Basic Dockerfile, app returns "Hello" | FROM, COPY, RUN npm install, CMD, EXPOSE |
| DOC-03 (containers) | Same image, various run flags | --name, --rm, -p, -e, docker logs, docker exec |
| DOC-04 (volumes) | App reads/writes a file | Named volume for persistence, bind mount for development |
| DOC-05 (networking) | App calls a second service | docker network create, --network flag, service hostname resolution |
| DOC-06 (Compose) | Full multi-service compose.yml | services, depends_on, environment, healthcheck |
| DOC-07 (best practices) | Dockerfile refactored | multi-stage build, .dockerignore, non-root USER |

This gives a coherent story: learner builds "their" app and improves it lesson by lesson.

### Pattern 5: Capstone Exercise Structure

The capstone uses `ExerciseCard` with `difficulty="Challenge"` and open-ended `steps` (requirements, not instructions). The hint system uses `VerificationChecklist` items with the `hint` field for expandable guidance.

The `ExerciseCard.steps` type is `{ step: number; description: string; command?: string }[]`. For the capstone, steps describe **requirements** not implementation steps. The `command` field can hint at a starting point without giving the answer.

```mdx
<ExerciseCard
  title="Foundation Capstone: Dockerized Multi-Service App"
  difficulty="Challenge"
  scenario="You're a new DevOps engineer. Your first task: take a three-tier application (web frontend, API backend, PostgreSQL database) and make it runnable anywhere with a single command. You'll write the Dockerfiles, configure the networking, automate deployment with a shell script, and verify the stack is healthy."
  objective="Deploy a production-style multi-service Docker Compose application with custom Dockerfiles, inter-service networking, data persistence, and an automated deployment script with health checks."
  steps={[
    { step: 1, description: "Write a Dockerfile for the API service. The API must run as a non-root user and listen on port 3000." },
    { step: 2, description: "Write a Dockerfile for the web frontend. Use a multi-stage build to keep the final image under 100MB." },
    { step: 3, description: "Create docker/capstone/compose.yml that brings up all three services on a custom bridge network. The API must not be accessible from outside the Compose network — only through the web service." },
    { step: 4, description: "Configure the PostgreSQL service with a named volume so data survives container restarts." },
    { step: 5, description: "Write docker/capstone/deploy.sh — a shell script that builds all images, starts the stack, and prints a health status summary. The script must exit non-zero if any service fails to start." },
    { step: 6, description: "Run the provided verify.sh to validate your deployment." },
  ]}
>
  <VerificationChecklist
    title="Success Criteria"
    items={[
      { id: "cap-01", label: "All three services are running (docker compose ps shows 'running')", hint: "Use docker compose ps to check service states. All services should show Status: running (healthy)." },
      { id: "cap-02", label: "Web service is accessible on host port 8080", hint: "curl http://localhost:8080/ should return HTTP 200. Check your ports mapping in compose.yml." },
      { id: "cap-03", label: "API responds to web service requests (networking works)", hint: "The web service container should be able to reach the api service by its Compose service name. Use docker compose exec web curl http://api:3000/health to test." },
      { id: "cap-04", label: "Database data persists across container restarts", hint: "Run docker compose restart db, then verify your data is still there. Named volumes survive container recreation — bind mounts don't." },
      { id: "cap-05", label: "API container runs as non-root user", hint: "docker compose exec api id should show uid=1000 or similar non-root UID. Add USER node (or USER appuser) in your Dockerfile." },
      { id: "cap-06", label: "deploy.sh exits 0 on success, non-zero on failure", hint: "Use set -e in deploy.sh and check service health with docker compose ps --format json | jq '.[].Status'." },
      { id: "cap-07", label: "verify.sh passes all checks", hint: "Run bash docker/capstone/verify.sh from the project root. Read each FAIL message carefully — they describe exactly what to fix." },
    ]}
  />
</ExerciseCard>
```

### Pattern 6: Capstone verify.sh Architecture

The capstone verify.sh is the most comprehensive in the course. It runs on the host (not inside a container) and uses `docker compose` commands to test the deployed stack. Structure:

```bash
#!/usr/bin/env bash
# docker/capstone/verify.sh
# Run from project root: bash docker/capstone/verify.sh
set -euo pipefail

PASS=0
FAIL=0
COMPOSE_FILE="docker/capstone/compose.yml"

check() {
  local desc="$1"
  local result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Foundation Capstone Verification ==="
echo ""

# 1. All services running
WEB_STATE=$(docker compose -f "$COMPOSE_FILE" ps --format json web 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d[0]['State'])" 2>/dev/null || echo "missing")

if [ "$WEB_STATE" = "running" ]; then
  check "web service is running" "pass"
else
  check "web service is not running — run: bash docker/capstone/deploy.sh" "fail"
fi

# 2. Port accessibility
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ | grep -q "200"; then
  check "web service responds on localhost:8080" "pass"
else
  check "web service not responding on port 8080 — check ports: in compose.yml" "fail"
fi

# 3. Inter-service networking
if docker compose -f "$COMPOSE_FILE" exec -T web \
    curl -s -o /dev/null -w "%{http_code}" http://api:3000/health 2>/dev/null | grep -q "200"; then
  check "web can reach API service by hostname 'api'" "pass"
else
  check "web cannot reach api — check both services are on same Compose network" "fail"
fi

# 4. Non-root user in API
API_UID=$(docker compose -f "$COMPOSE_FILE" exec -T api id -u 2>/dev/null || echo "0")
if [ "$API_UID" != "0" ]; then
  check "API container runs as non-root (uid=$API_UID)" "pass"
else
  check "API container runs as root — add USER instruction in api/Dockerfile" "fail"
fi

# 5. Named volume exists
if docker volume ls --format '{{.Name}}' | grep -q "capstone"; then
  check "Named volume exists for database persistence" "pass"
else
  check "No named volume found — add named volume for db in compose.yml" "fail"
fi

# 6. deploy.sh exists and is executable
if [ -x docker/capstone/deploy.sh ]; then
  check "deploy.sh exists and is executable" "pass"
else
  check "deploy.sh missing or not executable — create and chmod +x deploy.sh" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed. Foundation Capstone complete!\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
```

Key verify.sh design decisions:
- Runs on host (not inside a container) — uses `docker compose` commands
- Uses `-T` flag with `docker compose exec` to avoid pseudo-TTY allocation (important in scripts)
- Falls back gracefully if services aren't running (shows diagnostic message, not crash)
- Each FAIL message includes the exact command or fix needed
- Tests observable behavior (HTTP 200, UID, volume name) not configuration files

### Anti-Patterns to Avoid

- **Wrong moduleSlug:** Using `"03-docker-foundation-capstone"` or `"04-docker"` instead of `"03-docker"`. The registry slug in `content/modules/index.ts` is `'03-docker'`. Always verify against this file.
- **Capstone steps as instructions:** CAP-01 ExerciseCard steps must be requirements/criteria, not "do step 1, then step 2" instructions. The learner figures out the how.
- **Progressive app as isolated per-lesson apps:** DOC-02 through DOC-07 use the SAME app file growing in complexity — not separate apps. The continuity is the point.
- **verify.sh for capstone inside a container:** The capstone verify.sh runs on the HOST — it uses `docker compose` commands to inspect the deployed stack from the outside. It does NOT run inside a container.
- **`((PASS++))` under `set -e`:** Use `PASS=$((PASS + 1))` — inherited from Phases 2/3 research. `((VAR++))` exits with code 1 when the variable is 0, which kills the script under `set -e`.
- **`docker-compose` (v1) syntax:** Always use `docker compose` (v2 subcommand). The v1 binary is not installed on the host.
- **`set -euo pipefail` in verify.sh with pipelines:** The `pipefail` option makes the script exit if any command in a pipeline fails. Use `|| echo "default"` fallbacks for commands that may return non-zero in failure scenarios being tested.
- **Hardcoded container IDs:** Use service names (Compose DNS) not container IDs or IPs in verify.sh.
- **Capstone providing app source code:** The capstone project brief provides requirements only. The learner writes the app code. However, providing minimal scaffolding (empty directories, a README.md with the API contract) is acceptable to avoid ambiguity about what "the API" should return.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Container state inspection | Custom Docker API calls | `docker compose ps`, `docker inspect` CLI | Stable, script-friendly output; CLI is what learners use in real work |
| Service health checking in verify.sh | Polling loop with sleep | `docker compose ps --format json` + service healthcheck in compose.yml | Compose healthchecks handle retry/backoff; verify.sh only checks final state |
| Progressive app web server | Custom TCP server | `node:20-alpine` with minimal Express or Python with Flask | Realistic Dockerization scenario; learner sees a real app being containerized |
| Multi-stage build demonstration | Manual layer counting | `docker image inspect --format '{{len .RootFS.Layers}}'` | Shows exact layer count reduction from multi-stage — concrete and automatable |
| JSON parsing in verify.sh | Regex on docker output | `python3 -c "import sys,json; ..."` (python3 is in ubuntu:22.04) | Docker JSON output is stable; regex on text output breaks on format changes |

**Key insight:** The capstone verify.sh is the most complex shell script in the course so far. Keep it readable — one `check()` call per criterion, each FAIL message describes the exact fix. Resist adding clever bash tricks that obscure what's being tested.

---

## Common Pitfalls

### Pitfall 1: Module Slug Mismatch

**What goes wrong:** Docker lessons don't appear in sidebar; `getAllLessonPaths()` returns 0 Docker paths.

**Why it happens:** `content/modules/index.ts` registers the module as `slug: '03-docker'`. Content must live in `content/modules/03-docker/`. Phase-level naming (`04-docker-foundation-capstone`) is the planning directory name — it has no relationship to the content slug.

**How to avoid:** Content directory: `content/modules/03-docker/`. Frontmatter `moduleSlug`: `"03-docker"`. Always verify against `content/modules/index.ts`.

**Warning signs:** Sidebar shows "Docker & Containerization" with "0 lessons" despite MDX files existing.

### Pitfall 2: Capstone Steps Are Instructions, Not Requirements

**What goes wrong:** The capstone ExerciseCard steps become a tutorial walkthrough, defeating the purpose of an open-ended capstone.

**Why it happens:** It's tempting to add "helpful" commands or "use this approach" hints directly into steps.

**How to avoid:** Steps describe what must be true ("The API must run as non-root"), not how to achieve it. Hints go in `VerificationChecklist` items via the `hint` field — expandable, optional, not shown by default.

**Warning signs:** Steps include specific docker commands the learner should run; steps reference specific implementation details.

### Pitfall 3: verify.sh docker compose exec Without -T Flag

**What goes wrong:** `docker compose exec web curl ...` hangs in a shell script because it allocates a pseudo-TTY by default.

**Why it happens:** `docker compose exec` allocates a TTY when stdin is a terminal. In a script, stdin may not be a TTY, causing inconsistent behavior.

**How to avoid:** Always use `docker compose exec -T service command` in shell scripts. The `-T` flag disables pseudo-TTY allocation.

**Warning signs:** verify.sh hangs indefinitely on the `docker compose exec` line.

### Pitfall 4: Progressive App Breaking Between Lessons

**What goes wrong:** The DOC-04 exercise (volumes) assumes an app file from DOC-03, but the learner never built it, or built a different version.

**Why it happens:** The progressive app requires the learner to have followed prior lessons. If they skip to DOC-04, the exercise won't work as expected.

**How to avoid:** The `docker/app/` directory should contain the starting point for each lesson stage (or the final state of the previous lesson). Each lesson's TerminalBlock shows the exact `docker build` command using the provided `Dockerfile.basic` or the app source — learners don't need to have completed prior exercises to do the current one.

**Warning signs:** Exercise steps reference files the learner "should have" from a previous lesson without providing them in the `docker/app/` directory.

### Pitfall 5: Multi-Stage Build Dockerfile Cache in DOC-07

**What goes wrong:** Demonstrating multi-stage build benefits requires a cold cache. If the learner has been building images throughout the module, caching effects obscure the build time/size comparison.

**Why it happens:** Docker layer cache aggressively reuses layers. The "before" single-stage build size comparison only works if the learner hasn't already cached the layers from the "after" multi-stage build.

**How to avoid:** Lesson content must instruct learners to use `docker build --no-cache` for the comparison runs in DOC-07, and to run `docker image prune` before the size comparison exercise.

**Warning signs:** `docker images` shows the "unoptimized" image is same size as optimized because most layers are shared from earlier builds.

### Pitfall 6: Capstone verify.sh Uses `docker compose ps` JSON Before Services Start

**What goes wrong:** `docker compose ps --format json web` returns empty or invalid JSON if the service hasn't started yet, crashing `python3 -c "..."` JSON parsing.

**Why it happens:** The learner runs verify.sh before running deploy.sh, or deploy.sh fails silently.

**How to avoid:** The verify.sh must handle missing/stopped services gracefully. Use `|| echo "missing"` fallbacks on commands that may fail:
```bash
WEB_STATE=$(docker compose -f "$COMPOSE_FILE" ps --format json web 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d[0]['State'])" 2>/dev/null || echo "missing")
```

**Warning signs:** verify.sh crashes with `json.decoder.JSONDecodeError` before printing any PASS/FAIL output.

### Pitfall 7: Docker Lesson TerminalBlock Shows Misleading Output

**What goes wrong:** A TerminalBlock shows container output that will differ on the learner's machine (container IDs, timestamps, hashes) and the learner thinks something is wrong.

**Why it happens:** Container IDs are random. Image digests differ by platform (arm64 vs amd64).

**How to avoid:** In TerminalBlock `output` lines, truncate container IDs to the first 12 characters and use `...` suffix: `a1b2c3d4e5f6`. Use `[truncated]` for long hash outputs. Add a `comment` line explaining "Your output will show a different container ID — that's normal."

**Warning signs:** Learner reports "my output doesn't match" on basic `docker run` exercises.

---

## Code Examples

All examples derived from Phase 2/3 codebase patterns and confirmed against existing code.

### DOC-01 Container Internals Callout

The DOC-01 lesson must explicitly connect to prior Linux Fundamentals knowledge:

```mdx
<Callout type="deep-dive" title="Remember PID Namespaces from Lesson 5?">
In Linux Fundamentals Lesson 5 (Processes), you learned that each process has a PID
visible in `/proc`. When Docker creates a container, it calls `clone()` with the
`CLONE_NEWPID` flag — the container gets its own PID namespace. The process inside
the container thinks it's PID 1. From the host, it has a completely different PID
(whatever the kernel assigned). Run `docker inspect mybox --format "{{.State.Pid}}"`
to see the host PID of a container's init process.
</Callout>
```

### DOC-07 Multi-Stage Build Before/After

```mdx
<TerminalBlock
  title="Before: Single-stage build"
  lines={[
    { type: 'command', content: 'docker build --no-cache -t app:bloated -f docker/app/Dockerfile.basic .' },
    { type: 'output', content: '[+] Building 45.2s (8/8) FINISHED' },
    { type: 'command', content: 'docker images app:bloated' },
    { type: 'output', content: 'REPOSITORY   TAG       IMAGE ID       SIZE' },
    { type: 'output', content: 'app          bloated   a1b2c3d4e5f6   1.12GB' },
  ]}
/>

<TerminalBlock
  title="After: Multi-stage build"
  lines={[
    { type: 'command', content: 'docker build --no-cache -t app:optimized -f docker/app/Dockerfile.optimized .' },
    { type: 'output', content: '[+] Building 38.1s (12/12) FINISHED' },
    { type: 'command', content: 'docker images app:optimized' },
    { type: 'output', content: 'REPOSITORY   TAG         IMAGE ID       SIZE' },
    { type: 'output', content: 'app          optimized   b2c3d4e5f6a7   142MB' },
  ]}
/>
```

### Cheat Sheet Frontmatter Pattern

```mdx
---
title: "Docker & Containerization Cheat Sheet"
description: "Quick reference for all Docker commands, Dockerfile instructions, and Compose syntax covered in this module"
module: "Docker & Containerization"
moduleSlug: "03-docker"
lessonSlug: "08-cheat-sheet"
order: 8
difficulty: "Foundation"
estimatedMinutes: 5
prerequisites: []
tags: ["cheat-sheet", "reference", "docker", "commands", "dockerfile"]
---
```

### Capstone Frontmatter Pattern

```mdx
---
title: "Foundation Capstone: Deploy a Dockerized App"
description: "Integrate Linux, networking, and Docker skills to deploy a multi-container application — no step-by-step guidance"
module: "Docker & Containerization"
moduleSlug: "03-docker"
lessonSlug: "09-foundation-capstone"
order: 9
difficulty: "Challenge"
estimatedMinutes: 90
prerequisites: ["03-docker/06-docker-compose", "03-docker/07-dockerfile-best-practices", "01-linux-fundamentals/07-shell-scripting"]
tags: ["capstone", "project", "docker-compose", "dockerfile", "shell-scripting", "integration"]
---
```

### Integration Test Addition for Phase 4

The existing `lib/__tests__/modules.test.ts` has a stale description `'returns an array (empty in Phase 1)'`. Phase 4 should strengthen the Docker module assertion:

```typescript
// Addition to lib/__tests__/modules.test.ts
it('docker module has 9 lessons after Phase 4', () => {
  const paths = getAllLessonPaths()
  const dockerPaths = paths.filter(p => p.moduleSlug === '03-docker')
  expect(dockerPaths).toHaveLength(9)
})
```

---

## State of the Art

| Old Approach | Current Approach | Relevant To |
|--------------|------------------|-------------|
| `docker-compose` v1 CLI | `docker compose` v2 subcommand (no hyphen) | All TerminalBlock examples and verify.sh |
| Single-stage Dockerfiles everywhere | Multi-stage builds standard for production | DOC-07 lesson — multi-stage is the current best practice |
| Running as root in containers | Non-root USER instruction as security baseline | DOC-07 and capstone — API must not run as root |
| `MAINTAINER` instruction | Deprecated — use `LABEL maintainer=` | DOC-02/DOC-07 — don't use MAINTAINER in Dockerfiles |
| `docker-compose.yml` filename | `compose.yml` (preferred by Compose v2) | All Phase 4 Compose files use `compose.yml` |
| `CMD ["npm", "start"]` for Node apps | `CMD ["node", "server.js"]` preferred | Avoids npm as PID 1; cleaner signal handling |
| `EXPOSE` as documentation | `EXPOSE` is still documentation-only | Clarify in DOC-02 that EXPOSE doesn't publish ports — `-p` does |

**Key constraints carried forward:**
- Build scripts must keep `--webpack` flag: `"dev": "next dev --webpack"` in package.json. This is an existing constraint; never remove it.
- `$((VAR + 1))` not `((VAR++))` in verify.sh under `set -e`.
- `docker compose exec -T` in any shell script.

---

## Open Questions

1. **Progressive app: Node.js vs Python**
   - What we know: CONTEXT.md marks this as Claude's discretion. Both are valid. Node.js has more DevOps course content online.
   - Recommendation: Use Node.js (`node:20-alpine`). A minimal Express app with two routes (`GET /` and `GET /health`) takes ~10 lines of JS, has an obvious `package.json` + `node_modules` structure that makes layer caching lessons concrete, and is realistic (most learners encounter Node.js in DevOps work). Python is also valid — defer final choice to the planner, but Node.js is the recommended default.

2. **Capstone project scope: provide API source or require learner to write it?**
   - What we know: CONTEXT.md says "open-ended project brief" — learner figures out the "how". But writing an Express app + PostgreSQL queries may be too far outside DevOps scope.
   - Recommendation: Provide minimal starter code for the API and web services (10-20 lines each) in `docker/capstone/api/app.js` and `docker/capstone/web/index.html`. The capstone challenge is **Dockerizing and orchestrating** the services — not writing application logic. This keeps the focus on DevOps skills while removing accidental complexity.

3. **verify.sh JSON parsing: python3 vs jq**
   - What we know: `python3` is available everywhere (macOS, Ubuntu). `jq` requires installation. The capstone verify.sh runs on the host machine, not in a container.
   - Recommendation: Use `python3 -c "import sys,json; ..."` — it's universally available without requiring learners to install `jq`. Flag the assumption: if `python3` is not in PATH on the learner's machine, verify.sh will fail. Add a preamble check: `command -v python3 >/dev/null || { echo "python3 required"; exit 1; }`.

---

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.0 |
| Config file | `vitest.config.ts` (project root) |
| Quick run command | `npm test` |
| Full suite command | `npm run build && npm test` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DOC-01 through DOC-07 | MDX files render without build errors | smoke | `npm run build` | ❌ Wave 0: MDX files don't exist yet |
| DOC-09 | Cheat sheet MDX renders all QuickReference sections | smoke | `npm run build` | ❌ Wave 0 |
| CAP-01 | Capstone MDX renders with ExerciseCard and VerificationChecklist | smoke | `npm run build` | ❌ Wave 0 |
| DOC-08 | verify.sh scripts are valid bash syntax | manual | `bash -n docker/app/verify-*.sh docker/capstone/verify.sh` | ❌ Wave 0 |
| CAP-01 | Capstone verify.sh exits 0 when stack is correctly deployed | manual | `bash docker/capstone/verify.sh` (after deploying) | ❌ Wave 0 |
| Integration | `getAllLessonPaths()` returns 9 Docker paths | unit | `npm test` | ✅ `lib/__tests__/modules.test.ts` exists (needs new assertion) |
| Integration | `moduleSlug: "03-docker"` matches registry | unit | `npm test` (modules test validates lessons array) | ✅ Indirectly covered |

### Sampling Rate

- **Per task commit:** `npm test` (unit tests, < 5s)
- **Per wave merge:** `npm run build` (verifies MDX compilation, frontmatter validation, static params)
- **Phase gate:** Full suite green + manual review of all 7 lessons + capstone deploy test before `/gsd:verify-work`

### Wave 0 Gaps

- [ ] `content/modules/03-docker/` directory — does not exist yet; create before adding MDX files
- [ ] `docker/app/` directory — progressive exercise app files; create before lesson exercises reference it
- [ ] `docker/capstone/` directory — capstone scaffold; create before capstone lesson is written
- [ ] Add Docker module assertion to `lib/__tests__/modules.test.ts`:
  ```typescript
  it('docker module has 9 lessons after Phase 4', () => {
    const paths = getAllLessonPaths()
    const dockerPaths = paths.filter(p => p.moduleSlug === '03-docker')
    expect(dockerPaths).toHaveLength(9)
  })
  ```

---

## Sources

### Primary (HIGH confidence)

- Phase 4 codebase — direct inspection of `content/modules/index.ts` (confirmed slug: `'03-docker'`), `app/globals.css` (confirmed `--color-module-docker: oklch(0.70 0.15 195)`), `lib/modules.ts` (filesystem scanner logic), `lib/__tests__/modules.test.ts`, `types/content.ts`, `components/content/ExerciseCard.tsx`, `components/content/VerificationChecklist.tsx`, `components/content/Callout.tsx`, `docker/linux/Dockerfile`, `docker/networking/Dockerfile`, `docker/networking/06-firewalls/compose.yml`, `docker/networking/07-troubleshooting/compose.yml`
- `.planning/phases/04-docker-foundation-capstone/04-CONTEXT.md` — locked user decisions
- `.planning/REQUIREMENTS.md` — DOC-01 through DOC-09, CAP-01 definitions
- Phase 2 RESEARCH.md and Phase 3 RESEARCH.md — established patterns (MDX frontmatter, verify.sh PASS/FAIL, Docker Compose architecture)
- `docker --version` → 27.4.0; `docker compose version` → v2.31.0-desktop.2 (confirmed on host)

### Secondary (MEDIUM confidence)

- Docker Compose v2 `exec -T` flag requirement in scripts — standard Docker Compose v2 behavior; confirmed from Docker documentation and Phase 3 patterns
- `node:20-alpine` vs full `node:20` image size difference (~150MB vs ~1.1GB) — well-established Docker community knowledge; verify exact numbers during lesson writing with `docker pull`

### Tertiary (LOW confidence)

- `docker compose ps --format json` exact output structure — Docker Compose v2 JSON output format; verify exact field names (`State` vs `Status`) against live `docker compose ps --format json` output during plan execution
- PostgreSQL named volume behavior with `docker compose restart` — standard Docker volume behavior; test during capstone development

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — zero new npm packages; Docker tools confirmed on host; module slug confirmed from live registry
- Architecture: HIGH — patterns derived directly from Phase 2/3 codebase inspection; module slug confirmed; CSS variable confirmed; component APIs confirmed
- Pitfalls: HIGH for slug mismatch, TTY flag, and verify.sh patterns (confirmed from prior phases); MEDIUM for progressive app breakage scenario (design concern, not confirmed bug)
- Content topics: HIGH — Docker fundamentals (namespaces, cgroups, Dockerfile, Compose) are stable; Docker API and CLI syntax changes slowly

**Research date:** 2026-03-19
**Valid until:** 2026-06-19 (stable domain — Docker fundamentals and CLI syntax do not change at this timescale; Compose v2 API stable)
