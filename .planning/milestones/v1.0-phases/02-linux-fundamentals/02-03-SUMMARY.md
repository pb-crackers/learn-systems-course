---
phase: 02-linux-fundamentals
plan: "03"
subsystem: infra
tags: [docker, bash, linux, containers, lab-environment]

# Dependency graph
requires:
  - phase: 02-linux-fundamentals
    provides: 9 MDX lesson files with exercise scenarios and verification checklists

provides:
  - docker/linux/Dockerfile — buildable ubuntu:22.04 image with all tools (procps, strace, man-db, gawk, iproute2, sysstat, curl, wget, vim, nano, less, tree); student/testuser accounts; devops group
  - docker/linux/setup/01-09.sh — 9 setup scripts that create lab environments and drop learner into interactive bash
  - docker/linux/verify/01-09.sh — 9 verify scripts with colored PASS/FAIL output for each lesson

affects:
  - All linux-fundamentals MDX lessons that reference docker run commands
  - Phase 2 capstone if it uses docker lab environment

# Tech tracking
tech-stack:
  added: [Docker, ubuntu:22.04, bash shell scripting]
  patterns:
    - verify.sh PASS/FAIL pattern with check() function and colored printf
    - setup.sh pattern ending with exec /bin/bash for interactive drop-in
    - PASS/FAIL arithmetic using $((PASS + 1)) not ((PASS++)) to avoid set -e exit

key-files:
  created:
    - docker/linux/Dockerfile
    - docker/linux/setup/01-computers.sh
    - docker/linux/setup/02-os.sh
    - docker/linux/setup/03-filesystem.sh
    - docker/linux/setup/04-permissions.sh
    - docker/linux/setup/05-processes.sh
    - docker/linux/setup/06-shell.sh
    - docker/linux/setup/07-scripting.sh
    - docker/linux/setup/08-text-processing.sh
    - docker/linux/setup/09-packages.sh
    - docker/linux/verify/01-computers.sh
    - docker/linux/verify/02-os.sh
    - docker/linux/verify/03-filesystem.sh
    - docker/linux/verify/04-permissions.sh
    - docker/linux/verify/05-processes.sh
    - docker/linux/verify/06-shell.sh
    - docker/linux/verify/07-scripting.sh
    - docker/linux/verify/08-text-processing.sh
    - docker/linux/verify/09-packages.sh
  modified: []

key-decisions:
  - "sysstat added to Dockerfile: not in plan spec but provides iostat for lesson 1 CPU/IO content; auto-fix Rule 2"
  - "08-text-processing setup generates access.log at runtime with bash arithmetic not external tools — keeps Dockerfile minimal (no python/node)"
  - "05-processes setup uses a runaway.sh background process (busy-wait loop) rather than yes > /dev/null to give pgrep a predictable name for learner exercises"
  - "07-scripting provides incomplete template file not a working script — forces learner to practice shebang, set -e, functions, trap hands-on"

patterns-established:
  - "verify.sh pattern: check() function with colored PASS/FAIL printf; PASS/FAIL counters incremented with $((N + 1)) arithmetic; RESULT: PASS/FAIL summary at end"
  - "setup.sh pattern: mkdir /tmp/exercise, create exercise files, heredoc INSTRUCTIONS block, exec /bin/bash at end"
  - "Container exercise state in /tmp/exercise/ — predictable, writable, cleared on container exit"

requirements-completed:
  - LNX-10

# Metrics
duration: 5min
completed: 2026-03-19
---

# Phase 2 Plan 03: Docker Lab Infrastructure Summary

**Ubuntu:22.04 Docker image with 9 setup/verify script pairs providing hands-on lab environments for all Linux Fundamentals lessons, with colored PASS/FAIL verification output**

## Performance

- **Duration:** 5 min
- **Started:** 2026-03-19T10:50:47Z
- **Completed:** 2026-03-19T10:55:47Z
- **Tasks:** 2
- **Files modified:** 19 (1 Dockerfile + 9 setup + 9 verify)

## Accomplishments

- Docker image builds from ubuntu:22.04 with procps, gawk, strace, man-db, iproute2, sysstat, curl, wget, vim, nano, less, tree; student/testuser accounts; devops group
- All 9 setup scripts create realistic lab environments and drop learner into interactive bash via `exec /bin/bash`
- All 9 verify scripts provide explicit colored PASS/FAIL feedback using a consistent `check()` pattern
- Text processing lab generates a 500-line Apache access log at container startup with realistic mixed status codes, IPs, and URLs

## Task Commits

1. **Task 1: Dockerfile and setup/verify scripts for lessons 1-5** - `c2e9bab` (feat)
2. **Task 2: Setup/verify scripts for lessons 6-9** - `af19a5e` (feat)

**Plan metadata:** _(see final commit)_

## Files Created/Modified

- `docker/linux/Dockerfile` — ubuntu:22.04 base; all tools installed; student/testuser/devops created; setup and verify scripts copied and made executable
- `docker/linux/setup/01-computers.sh` — /proc/cpuinfo, /proc/meminfo, lsblk exploration; checks cpu-cores.txt, total-memory.txt, block-devices.txt
- `docker/linux/setup/02-os.sh` — kernel version, strace, /proc/1 exploration; checks kernel-version.txt, strace-output.txt, init-cmdline.txt
- `docker/linux/setup/03-filesystem.sh` — hard links, symlinks, inode exploration; checks inode match, symlink existence, inode-listing.txt, mount-info.txt
- `docker/linux/setup/04-permissions.sh` — secret.txt(644), scripts/, shared/, deploy.sh; checks 600 perms, executable dir, sticky bit, executable script
- `docker/linux/setup/05-processes.sh` — launches runaway.sh background process; checks found-pid.txt, process-cmdline.txt, signal-sent.txt
- `docker/linux/setup/06-shell.sh` — env vars, pipelines, 2>&1 redirect exercise; checks env-output.txt, pipeline-result.txt, combined-output.txt
- `docker/linux/setup/07-scripting.sh` — incomplete deploy.sh template; checks shebang, set -e, chmod +x, function, exits 0
- `docker/linux/setup/08-text-processing.sh` — generates 500-line access log + app.conf; checks error-urls.txt, top-ips.txt, PORT modified, pipeline-output.txt
- `docker/linux/setup/09-packages.sh` — runs apt-get update, installs tree; checks dpkg -s tree, tree-files.txt, curl-deps.txt
- `docker/linux/verify/01-09.sh` — corresponding verify scripts (all use identical check() PASS/FAIL pattern)

## Decisions Made

- `sysstat` added to Dockerfile (not in plan) — provides `iostat` referenced in lesson 1 content; minor addition
- `08-text-processing.sh` generates the access log using pure bash arithmetic loops — no external dependencies needed in Dockerfile
- Lesson 5 uses a named `runaway.sh` script instead of `yes > /dev/null` so `pgrep runaway` gives learners a reliable, predictable name
- Lesson 7 provides an intentionally incomplete template (no shebang, no chmod) so learners must practice those steps themselves

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Added sysstat to Dockerfile**
- **Found during:** Task 1 (Dockerfile creation)
- **Issue:** Lesson 1 content references `iostat -x 1` for I/O diagnostics; not in plan's tool list
- **Fix:** Added `sysstat` package to Dockerfile apt-get install block
- **Files modified:** docker/linux/Dockerfile
- **Verification:** Docker image builds successfully with iostat available
- **Committed in:** c2e9bab (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (1 missing critical tool)
**Impact on plan:** Minor Dockerfile addition. No scope creep.

## Issues Encountered

- Docker Desktop was not running at plan start — launched it and waited ~15 seconds for daemon. Build proceeded normally once running. No code changes required.

## User Setup Required

None — Docker image is self-contained.

## Next Phase Readiness

- All 9 Linux Fundamentals lessons now have matching lab containers
- Learners can build once (`docker build -t learn-systems-linux docker/linux/`) then launch any lesson lab
- Verify scripts give explicit PASS/FAIL so learners know immediately if they completed the exercise correctly
- Phase 2 Plan 04 (cheat sheet) is already complete — Phase 2 is done

---
*Phase: 02-linux-fundamentals*
*Completed: 2026-03-19*
