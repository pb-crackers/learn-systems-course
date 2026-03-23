---
phase: 05-system-administration-ci-cd
plan: "02"
subsystem: infra
tags: [docker, bash, sysadmin, verify-scripts, mdx, vitest, ubuntu, systemd]

requires:
  - phase: 05-system-administration-ci-cd
    provides: 6 sysadmin MDX lesson files (SYS-01 through SYS-06) with exercise descriptions

provides:
  - docker/sysadmin/Dockerfile (ubuntu:22.04 base for SYS-01, 04, 05, 06 labs)
  - docker/sysadmin/Dockerfile.systemd (jrei/systemd-ubuntu:22.04 for SYS-02, 03 labs)
  - 6 setup scripts with exercise instructions and lab environment initialization
  - 6 verify scripts with PASS/FAIL feedback for each sysadmin lesson
  - content/modules/04-sysadmin/07-cheat-sheet.mdx with 6 QuickReference sections
  - Vitest assertion confirming sysadmin module has 7 lessons

affects:
  - 05-system-administration-ci-cd plan 03 (CI/CD MDX lessons — no dependency but same phase)
  - Future phases using the sysadmin lab pattern for Docker-based exercises

tech-stack:
  added: []
  patterns:
    - "Loopback device for disk labs: truncate -s 512M + losetup /dev/loop0 inside --privileged container"
    - "Systemd lab via jrei/systemd-ubuntu:22.04 with --privileged --tmpfs /tmp --tmpfs /run --tmpfs /run/lock flags"
    - "Verify script PASS/FAIL pattern: set -euo pipefail, check() function, PASS/FAIL counters, RESULT: PASS/FAIL final line"
    - "Setup script exec /bin/bash at end: keeps shell open after printing instructions"
    - "Conditional skip in verify scripts: graceful SKIP output for optional checks (e.g., systemd timer in scheduling)"

key-files:
  created:
    - docker/sysadmin/Dockerfile
    - docker/sysadmin/Dockerfile.systemd
    - docker/sysadmin/setup/01-users.sh
    - docker/sysadmin/setup/02-systemd.sh
    - docker/sysadmin/setup/03-logging.sh
    - docker/sysadmin/setup/04-disk.sh
    - docker/sysadmin/setup/05-scheduling.sh
    - docker/sysadmin/setup/06-monitoring.sh
    - docker/sysadmin/verify/01-users.sh
    - docker/sysadmin/verify/02-systemd.sh
    - docker/sysadmin/verify/03-logging.sh
    - docker/sysadmin/verify/04-disk.sh
    - docker/sysadmin/verify/05-scheduling.sh
    - docker/sysadmin/verify/06-monitoring.sh
    - content/modules/04-sysadmin/07-cheat-sheet.mdx
  modified:
    - lib/__tests__/modules.test.ts

key-decisions:
  - "05-scheduling verify: systemd timer check is conditional — file existence tested before systemctl is-active; avoids false fail on containers without systemd"
  - "06-monitoring verify: load average file check is a SKIP not FAIL — learner may have observed interactively without saving to file"
  - "Dockerfile includes rsyslog and logrotate: needed for SYS-03 logging exercises even in the non-systemd container"
  - "Modules test: previous session had already added cicd assertion — only sysadmin assertion was missing"

patterns-established:
  - "Verify SKIP pattern: conditional checks print SKIP in yellow when exercise step is optional or not yet reached"
  - "Setup scripts use exec /bin/bash at end so the script itself becomes the interactive shell session"
  - "Loopback persistence warning: setup/04-disk.sh explains /dev/loop0 is not persistent across container restarts"

requirements-completed: [SYS-07, SYS-08]

duration: 10min
completed: 2026-03-19
---

# Phase 5 Plan 02: Sysadmin Docker Lab Infrastructure Summary

**2 Dockerfiles, 6 setup scripts, 6 verify PASS/FAIL scripts for sysadmin Docker labs, plus cheat sheet with 6 QuickReference sections and Vitest 7-lesson assertion**

## Performance

- **Duration:** 10 min
- **Started:** 2026-03-19T13:07:34Z
- **Completed:** 2026-03-19T13:17:47Z
- **Tasks:** 2
- **Files modified:** 16

## Accomplishments

- Full Docker lab environment for all 6 sysadmin lessons: 2 Dockerfiles (ubuntu:22.04 and jrei/systemd-ubuntu:22.04), 6 setup scripts that initialize environments and print exercise instructions, 6 verify scripts that give learner granular PASS/FAIL feedback
- Sysadmin cheat sheet with 6 QuickReference sections (one per SYS-01–06 lesson topic), following Phase 2/3/4 pattern
- Vitest assertion confirming sysadmin module has 7 lessons — full test suite 31/31 green

## Task Commits

Each task was committed atomically:

1. **Task 1: Create sysadmin Docker lab infrastructure** - `ee086ec` (feat)
2. **Task 2: Write sysadmin cheat sheet and update Vitest assertion** - `391e5ff` (feat)

## Files Created/Modified

- `docker/sysadmin/Dockerfile` — ubuntu:22.04 with procps, sysstat, cron, at, sudo, util-linux, fdisk, rsyslog, logrotate
- `docker/sysadmin/Dockerfile.systemd` — jrei/systemd-ubuntu:22.04 for systemd labs; no CMD (uses /sbin/init); includes Apple Silicon tip comment
- `docker/sysadmin/setup/01-users.sh` — creates testuser1/testuser2/devteam/ops; exercises: create alice/bob, group assignments, sudoers drop-in
- `docker/sysadmin/setup/02-systemd.sh` — installs /usr/local/bin/hello.sh; exercises: create hello.service unit, lifecycle commands, journalctl
- `docker/sysadmin/setup/03-logging.sh` — creates /var/log/myapp/, generates journal entries via logger, app.log sample; exercises: logrotate config
- `docker/sysadmin/setup/04-disk.sh` — truncate + losetup /dev/loop0 (512M); exercises: fdisk, mkfs.ext4, mount, UUID fstab
- `docker/sysadmin/setup/05-scheduling.sh` — installs backup.sh/report.sh, starts cron; exercises: crontab, at, systemd timer pair
- `docker/sysadmin/setup/06-monitoring.sh` — installs scenario-cpu.sh/scenario-io.sh/scenario-memory.sh; exercises: vmstat, iostat, top, bottleneck identification
- `docker/sysadmin/verify/01-users.sh` — checks alice exists, devteam membership, bob exists, ops membership, sudoers drop-in, NOPASSWD access
- `docker/sysadmin/verify/02-systemd.sh` — checks unit file exists, [Unit]/[Service]/[Install] sections, ExecStart, service active, enabled, journalctl output
- `docker/sysadmin/verify/03-logging.sh` — checks /var/log/myapp/ exists, app.log exists, logrotate config, path reference, rotate directive, dry-run passes
- `docker/sysadmin/verify/04-disk.sh` — checks /dev/loop0 attached, /mnt/data mounted, df accessible, fstab entry, UUID= in entry
- `docker/sysadmin/verify/05-scheduling.sh` — checks backup.sh/report.sh installed, crontab entry, valid 5-field syntax, backup ran, conditional timer check
- `docker/sysadmin/verify/06-monitoring.sh` — checks uptime, vmstat, iostat, top available, scenario scripts present, optional load average file
- `content/modules/04-sysadmin/07-cheat-sheet.mdx` — 6 QuickReference sections: User Management, systemd, Logging, Disk Management, Scheduling, System Monitoring; What's Next CI/CD callout
- `lib/__tests__/modules.test.ts` — added 'sysadmin module has 7 lessons' assertion (cicd assertion was already present from previous session)

## Decisions Made

- 05-scheduling verify.sh: systemd timer check is conditional on timer file existence — containers without systemd will not have the file and the check prints SKIP instead of FAIL
- 06-monitoring verify.sh: load average file is optional (SKIP not FAIL) — learner may have observed interactively
- Dockerfile includes rsyslog/logrotate packages even in the non-systemd container — SYS-03 exercises need both tools without requiring the heavier systemd image
- Modules test had cicd assertion from a previous out-of-order execution — only the sysadmin assertion was missing; added without modifying existing tests

## Deviations from Plan

None — plan executed exactly as written. All acceptance criteria met on first attempt.

## Issues Encountered

None — lib/__tests__/modules.test.ts had already received a cicd module assertion (5 lessons) from a previous session; this was discovered on read and handled correctly by adding only the missing sysadmin assertion.

## User Setup Required

None — all files are static Docker assets and MDX content. No external services or environment variables required.

## Next Phase Readiness

- Sysadmin module is fully hands-on: 6 lessons with exercises, Docker lab environments, verify scripts, and a cheat sheet
- Plan 05-03 (CI/CD MDX lessons) can proceed — no dependency on sysadmin Docker labs
- Plan 05-04 (CI/CD exercise YAML and cheat sheet) can proceed after 05-03

---
*Phase: 05-system-administration-ci-cd*
*Completed: 2026-03-19*
