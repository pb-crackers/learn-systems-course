# Architecture Research

**Domain:** Interactive file-based DevOps & systems engineering course (local, single-learner, repo-as-curriculum)
**Researched:** 2026-03-18
**Confidence:** MEDIUM-HIGH

---

## Standard Architecture

### System Overview

```
┌──────────────────────────────────────────────────────────────────────┐
│                         COURSE LAYER                                  │
│  curriculum manifest / module index / progression state              │
├──────────────────────────────────────────────────────────────────────┤
│                         MODULE LAYER                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │
│  │  01-linux/   │  │  02-network/ │  │  03-docker/  │  ...          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘               │
│         │ (depends on previous)              │                       │
├─────────┴───────────────────────────────────┴───────────────────────┤
│                         LESSON LAYER (per module)                     │
│  ┌───────────────────────────────────────────────────────────────┐   │
│  │  README.md (concept + explanation)                            │   │
│  │  exercises/  (guided tasks with expected outputs)             │   │
│  │  labs/       (open-ended environment configs)                 │   │
│  │  solutions/  (reference answers, not shown by default)        │   │
│  └───────────────────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────────────────┤
│                      VERIFICATION LAYER                               │
│  ┌─────────────────────────────────────────────────────────────┐     │
│  │  check.sh (per exercise: asserts state, prints PASS/FAIL)   │     │
│  └─────────────────────────────────────────────────────────────┘     │
├──────────────────────────────────────────────────────────────────────┤
│                      ENVIRONMENT LAYER                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │
│  │  Dockerfile  │  │ docker-       │  │  Vagrantfile │               │
│  │  (per lab)   │  │ compose.yml  │  │  (where VM   │               │
│  │              │  │              │  │   required)  │               │
│  └──────────────┘  └──────────────┘  └──────────────┘               │
└──────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| Course manifest | Ordered list of modules, prerequisites, learning objectives per module | `modules/index.md` or simple directory naming convention (`01-`, `02-`) |
| Module | Groups a coherent topic (e.g., "Linux Filesystem"). Contains all lessons for that topic. | Directory with numbered subfolders |
| Lesson (README.md) | Delivers concepts, "why it works this way", contextual diagrams, worked examples. Pure reading. | Markdown file, no exercises embedded |
| Exercise | Guided, step-by-step task with a specific measurable outcome. Learner does one thing, confirms it worked. | `exercises/NN-name/` directory with `README.md` instructions + `check.sh` |
| Lab | Open-ended environment. Learner completes a realistic scenario without step-by-step hand-holding. | `labs/NN-name/` directory with `README.md` brief + Docker/Vagrant environment files |
| Verification script | Asserts filesystem state, process state, or command output after an exercise. Emits clear PASS/FAIL. | `check.sh` (bash), runs inside the same environment the learner worked in |
| Solution | Reference implementation shown only after learner attempts the task. | `solutions/` subdirectory, not linked from lesson by default |
| Environment config | Reproducible, disposable environment for each lab. Learner can reset and retry. | `Dockerfile` + `docker-compose.yml`; Vagrant for kernel-level topics that require a real Linux VM on macOS |

---

## Recommended Project Structure

```
learn-systems/
├── modules/
│   ├── 00-setup/                   # Environment setup: Docker, tools, aliases
│   │   ├── README.md               # What you need and why
│   │   └── check.sh                # Verifies Docker installed, etc.
│   │
│   ├── 01-linux-fundamentals/
│   │   ├── README.md               # Module overview + learning objectives
│   │   ├── lessons/
│   │   │   ├── 01-filesystem/
│   │   │   │   └── README.md       # Concept: VFS, inodes, mount points
│   │   │   ├── 02-permissions/
│   │   │   │   └── README.md       # Concept: Unix permission model, ACLs
│   │   │   └── 03-processes/
│   │   │       └── README.md       # Concept: process tree, signals, /proc
│   │   ├── exercises/
│   │   │   ├── 01-navigate-filesystem/
│   │   │   │   ├── README.md       # Instructions: "find all files owned by root..."
│   │   │   │   └── check.sh        # Asserts expected output or state
│   │   │   ├── 02-fix-permissions/
│   │   │   │   ├── README.md
│   │   │   │   └── check.sh
│   │   │   └── ...
│   │   ├── labs/
│   │   │   ├── 01-broken-system/
│   │   │   │   ├── README.md       # Scenario brief (no step-by-step)
│   │   │   │   ├── Dockerfile      # Broken environment to fix
│   │   │   │   └── docker-compose.yml
│   │   │   └── ...
│   │   └── solutions/
│   │       ├── 01-navigate-filesystem.md
│   │       └── 02-fix-permissions.md
│   │
│   ├── 02-networking/
│   ├── 03-sysadmin/
│   ├── 04-docker/
│   ├── 05-cicd/
│   ├── 06-iac/
│   ├── 07-cloud/
│   ├── 08-monitoring/
│   └── 09-configuration-management/
│
├── environments/
│   └── base-linux/                 # Shared base Docker image all exercises inherit from
│       └── Dockerfile
│
└── .planning/                      # Course planning artifacts (not learner-facing)
```

### Structure Rationale

- **`modules/NN-name/`:** Numeric prefix enforces ordering without any tooling. Learner navigates top-to-bottom. Each module is self-contained — can be read independently once prerequisites are met.
- **`lessons/` vs `exercises/` vs `labs/`:** Separation of concern is critical. Lessons = passive reading. Exercises = guided doing with verification. Labs = open-ended environment problems. Mixing them into a single file creates a bloated doc that is hard to navigate and makes verification impossible.
- **`check.sh` per exercise:** Verification lives next to the exercise, not in a central runner. This keeps each exercise independently testable and makes authoring simple: write the exercise, write its check script, done.
- **`solutions/`:** Committed but not linked prominently. Learner can `cd solutions/` but won't stumble into them during normal navigation.
- **`environments/`:** Shared base image reduces Docker build time and ensures all exercises start from a consistent Linux environment regardless of the host OS (macOS).

---

## Architectural Patterns

### Pattern 1: Lesson → Exercise → Lab Separation

**What:** Each lesson (concept delivery) is separate from exercises (guided practice) and labs (open scenarios). Three distinct content types with different files, different cognitive modes.

**When to use:** Always. Every module follows this structure.

**Trade-offs:** More files per module. But learner knows exactly what they are reading: "this README is teaching me something" vs "this README is giving me a task." No cognitive switching mid-file.

**Example:**
```
01-linux-fundamentals/
├── lessons/01-filesystem/README.md   ← reads like a textbook chapter
├── exercises/01-navigate-filesystem/README.md  ← reads like a task list
└── labs/01-broken-system/README.md   ← reads like a ticket/scenario
```

### Pattern 2: Verification-First Exercise Authoring

**What:** Write `check.sh` before writing `README.md` for every exercise. The check script defines what "done" means; the instructions are just guidance toward that state.

**When to use:** Every exercise.

**Trade-offs:** Takes more discipline. Pays off by ensuring every exercise has a clear, testable success condition and prevents exercises that say "explore the filesystem" with no measurable outcome.

**Example:**
```bash
#!/usr/bin/env bash
# check.sh for exercise: set-permissions
set -euo pipefail

PASS=0; FAIL=0

check() {
  if eval "$2" &>/dev/null; then
    echo "PASS: $1"
    ((PASS++))
  else
    echo "FAIL: $1"
    ((FAIL++))
  fi
}

check "script.sh is executable by owner" \
  "[[ -x /home/learner/script.sh ]]"

check "script.sh is NOT world-writable" \
  "[[ ! -w /home/learner/script.sh ]] || [[ $(stat -c '%a' /home/learner/script.sh) != *2 ]]"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
```

### Pattern 3: Disposable Docker Environments

**What:** Each lab provides a `docker-compose.yml` that spins up a clean environment. Learner starts it, does the lab, tears it down. No state leaks between labs.

**When to use:** All labs. For Linux-specific kernel topics (e.g., cgroups, namespaces, kernel parameters) that don't work correctly inside Docker, use a Vagrantfile pointing to a minimal Linux VM instead.

**Trade-offs:** Docker adds a layer of abstraction that hides some Linux internals (systemd, udev). For the early Linux fundamentals modules, this is acceptable. For sysadmin topics requiring systemd, switch to Vagrant. Document the tradeoff explicitly in the lab README.

**Example:**
```yaml
# docker-compose.yml for lab: broken-permissions
services:
  lab:
    build: .
    container_name: learn-systems-lab
    hostname: lab-machine
    tty: true
    stdin_open: true
    volumes:
      - ./workspace:/home/learner/workspace
```

---

## Data Flow

### Learner Progression Flow

```
Module README (orient)
    |
    v
Lesson README (understand concept)
    |
    v
Exercise README (follow guided steps)
    |
    v
run check.sh --> PASS: move to next exercise
            --> FAIL: re-read, retry, check solutions/
    |
    (all exercises complete)
    v
Lab README (apply knowledge to open scenario)
    |
    v
Submit to self (no automated check — lab success is subjective scenario completion)
    |
    (all labs complete)
    v
Next module (verify prerequisites met)
```

### Exercise State Machine

```
[NOT STARTED]
     |
     | (learner reads README.md)
     v
[IN PROGRESS]
     |
     | (learner runs check.sh)
     v
[PASS] ──────────────────────────────> [NEXT EXERCISE]
     |
     | (check.sh exits non-zero)
     v
[FAIL: investigate]
     |
     |-- re-read lesson README
     |-- check solutions/ directory
     |-- retry exercise
     |
     v
[IN PROGRESS] (loop)
```

### Key Data Flows

1. **Concept to skill:** Lesson README delivers model → Exercise makes learner apply model against real system → Lab makes learner use skill without scaffolding.
2. **Environment to verification:** Docker/Vagrant creates deterministic system state → Learner modifies state → `check.sh` asserts system state matches expected outcome.
3. **Module to module:** Each module's README lists prerequisites (prior modules). Learner controls pacing; no automated gating because this is local/single-learner.

---

## Scaling Considerations

This is a single-learner, file-based course. "Scaling" means content volume, not users.

| Scale | Architecture Adjustments |
|-------|--------------------------|
| 1-3 modules | Single `modules/` directory, no index needed — directory names are sufficient |
| 4-9 modules (target) | Add `modules/README.md` as course index with learning path diagram and time estimates per module |
| 10+ modules | Consider grouping modules into tracks (e.g., `tracks/linux/`, `tracks/cloud/`) — but avoid this until content volume demands it |

### Scaling Priorities

1. **First bottleneck: Docker image build time.** As labs multiply, cold builds get slow. Mitigation: shared base image in `environments/base-linux/` that all labs extend. Labs only add their specific state on top.
2. **Second bottleneck: Exercise check script maintenance.** As exercises multiply, keeping check scripts accurate becomes the main maintenance burden. Mitigation: keep checks focused on observable state (file permissions, process existence, port open) not on implementation details.

---

## Anti-Patterns

### Anti-Pattern 1: Monolithic Lesson Files

**What people do:** Write one giant `lesson.md` per topic that includes concepts, step-by-step exercises, and verification all inline.

**Why it's wrong:** Learner cannot skip to the exercise without reading all the theory. Verification cannot be automated because steps are prose. Impossible to reuse the lab environment for a different exercise. File becomes 500+ lines and unmaintainable.

**Do this instead:** Separate `lessons/`, `exercises/`, and `labs/` directories. Each file has one job.

### Anti-Pattern 2: Implicit Success Criteria

**What people do:** Exercises say "explore the systemd journal" or "play with Docker networking" with no measurable success condition.

**Why it's wrong:** Learner doesn't know when they're done. No reinforcement of correct behavior. Nothing distinguishes a learner who did the exercise from one who skipped it.

**Do this instead:** Every exercise ends with a concrete, checkable state. If you can't write a `check.sh` for it, it's not an exercise — it's a lesson. Move it there.

### Anti-Pattern 3: Hardcoded Environment State in Exercises

**What people do:** Exercise instructions assume specific file paths, usernames, or host state from the learner's macOS machine.

**Why it's wrong:** macOS environment varies. Exercise fails for reasons unrelated to the learning objective. Learner debugs their machine instead of the concept.

**Do this instead:** All exercises that require a Linux environment must provide a Docker container. The container's state is known and reproducible. `check.sh` runs inside the container, not on the host.

### Anti-Pattern 4: Burying Solutions in the Main Reading Path

**What people do:** Put solutions inline after the exercise instructions, separated by a horizontal rule.

**Why it's wrong:** Learner scrolls down out of impatience and reads the solution before attempting the problem. Kills the learning value of the exercise.

**Do this instead:** Solutions live in a separate `solutions/` directory. Main exercise `README.md` ends with: "If you're stuck, see `solutions/NN-exercise-name.md`." Learner has to actively navigate there.

---

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| Docker Hub / GHCR | `FROM` base images in Dockerfiles | Pin specific image digests for reproducibility. Don't use `:latest`. |
| GitHub | Repository hosting — learner clones locally | No runtime dependency. Course works entirely offline after clone. |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| Lesson README → Exercise README | None (learner navigates manually) | Lesson should end with "Now practice this in `exercises/01-name/`" — a navigational cue, not a programmatic link |
| Exercise README → check.sh | Learner runs `bash check.sh` from exercise directory | check.sh must be executable and self-contained. No arguments required. |
| Lab README → Docker environment | Learner runs `docker compose up -d` then works inside container | Lab README must include the exact commands to start and stop the environment |
| Module N → Module N+1 | Prerequisites listed in Module README | No automated enforcement. Single-learner; trust the curriculum sequence. |

---

## Build Order Implications for Roadmap

The component dependencies establish a clear build order for the course itself:

1. **Environment infrastructure first** (Module 00: Setup) — Nothing else works without Docker/tools confirmed working on macOS.
2. **Shared base Docker image** — Build this before authoring any lab that requires a Linux environment. All subsequent labs depend on it.
3. **Module content in curriculum order** — Each module depends on the previous. Linux fundamentals must exist before networking (which assumes you understand processes and file descriptors). Networking before Docker (which uses Linux networking primitives). Docker before CI/CD (which uses Docker as a build environment).
4. **Lesson before exercise before lab** (within each module) — Lesson delivers the model. Exercise verifies basic application of the model. Lab tests independent application. This ordering within a module is non-negotiable.
5. **check.sh before exercise README** — As described in Pattern 2, defining what done looks like before writing how to get there prevents vague exercises.

---

## Sources

- [KodeKloud: Hands-On DevOps Learning 2025](https://kodekloud.com/blog/hands-on-devops-cloud-ai-learning-2025/) — Lab-integrated-into-lesson-flow pattern, validation approach (MEDIUM confidence: marketing page, but describes real platform behavior)
- [moeinfatehi/LinuxForCyberSecurityCourse](https://github.com/moeinfatehi/LinuxForCyberSecurityCourse) — Numbered module directory pattern, lectures/assignments/resources per module (HIGH confidence: inspected repository structure directly)
- [freeCodeCamp/learn-bash-scripting-by-building-five-programs](https://github.com/freeCodeCamp/learn-bash-scripting-by-building-five-programs/blob/main/TUTORIAL.md) — Step-based exercise format, hints section, observable output verification (HIGH confidence: inspected file directly)
- [bregman-arie/devops-exercises](https://github.com/bregman-arie/devops-exercises) — Topic-folder organization, Q&A exercise format (HIGH confidence: inspected repository structure)
- [DevOps with Docker / University of Helsinki](https://github.com/oneiromancy/devops-with-docker) — Pass/fail criteria per exercise, skip allowances, mandatory flags (MEDIUM confidence: course description, not direct code inspection)
- [CMU: Course Content & Schedule](https://www.cmu.edu/teaching/designteach/design/contentschedule.html) — Curriculum sequencing principles: simple to complex, dependency identification (HIGH confidence: academic source)
- [Skytap: Self-Paced Hands-On Learning](https://www.skytap.com/blog/maximizing-the-value-of-self-paced-hands-on-learning-with-interactive-lab-guides/) — Lab guide structure, step-by-step vs open-ended distinction (MEDIUM confidence: vendor blog but describes real instructional design patterns)

---
*Architecture research for: Interactive DevOps & Systems Engineering Course (local, file-based)*
*Researched: 2026-03-18*
