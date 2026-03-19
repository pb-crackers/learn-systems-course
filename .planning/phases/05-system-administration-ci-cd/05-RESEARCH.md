# Phase 5: System Administration & CI/CD - Research

**Researched:** 2026-03-19
**Domain:** Linux sysadmin content (systemd, users, logging, disk, scheduling, monitoring) + CI/CD content (GitHub Actions, pipelines, deployment strategies) — both as MDX lessons with Docker-based labs
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**System Administration Lesson Approach**
- Docker containers with systemd using systemd-enabled images (jrei/systemd-ubuntu or similar, --privileged) for realistic service management exercises
- Practical disk management: df, du, mount, fstab with mechanism explanations of block devices and filesystems — not full LVM deep-dive
- Monitoring lesson focuses on top/htop/vmstat/iostat with real bottleneck identification scenarios — sets up Phase 7's Prometheus/Grafana
- Cron and systemd timers covered with real scheduling exercises

**CI/CD Lesson Approach**
- GitHub Actions as the CI/CD platform — most popular, free tier, learner likely has a GitHub account
- Exercises are primarily about understanding and writing YAML workflow files — provide complete workflow YAML that learner can copy into their own repo
- Deployment strategies (blue/green, rolling, canary) covered conceptually with diagrams, not implemented
- Real pipeline exercise: complete workflow YAML for the progressive Docker app — lint → test → build image → push to registry

**Content Organization**
- Two separate content modules: 04-sysadmin and 05-cicd — matches the requirement structure
- SysAdmin difficulty: SYS-01–03 Foundation, SYS-04–06 Intermediate
- CI/CD difficulty: CICD-01–02 Foundation, CICD-03–04 Intermediate
- Module accent colors: SysAdmin = orange/amber; CI/CD = purple

### Claude's Discretion
- Exact systemd-enabled Docker image selection
- Specific bottleneck scenarios for monitoring lesson
- GitHub Actions workflow YAML specifics
- Exercise design details for both modules
- How to handle systemd limitations in containers (documentation approach)
- Exact cron/systemd timer scheduling examples

### Deferred Ideas (OUT OF SCOPE)
- Ansible/configuration management (ADV-02, v2)
- Security hardening module (ADV-03, v2)
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| SYS-01 | Lesson on user and group management — useradd, /etc/passwd, /etc/shadow, sudo | Ubuntu 22.04 user management commands; /etc/passwd and /etc/shadow file formats; sudo and sudoers; groups and `id` command; established linux container image already has student/testuser accounts as reference |
| SYS-02 | Lesson on systemd — units, services, targets, journald, service lifecycle | jrei/systemd-ubuntu:22.04 confirmed pullable; --privileged --tmpfs flags needed; unit file [Unit][Service][Install] anatomy; systemctl enable/disable/start/stop/status/reload; target concepts; journald and journalctl |
| SYS-03 | Lesson on logging — syslog, journald, log rotation, centralized logging concepts | journalctl filtering (-u, --since, --until, -p); /var/log/ structure; logrotate configuration; syslog protocol (RFC 5424); centralized logging concepts (sets up Phase 7 ELK/Loki) |
| SYS-04 | Lesson on disk management — fdisk, mount, fstab, LVM basics, df, du | lsblk / blkid / fdisk; mount command and UUID-based fstab entries; df -h / du -sh; loopback devices for lab simulation; NOT full LVM deep-dive per locked decision |
| SYS-05 | Lesson on process management and scheduling — cron, systemd timers, at, nice/renice | crontab syntax (5-field); systemd OnCalendar= calendar specifications; systemd-analyze calendar for validation; at command; nice/renice and priority levels |
| SYS-06 | Lesson on system monitoring — top, htop, vmstat, iostat, resource bottlenecks | top/htop column interpretation; vmstat (procs, memory, swap, io, cpu fields); iostat from sysstat package; load average interpretation; bottleneck identification patterns (CPU-bound vs I/O-bound) |
| SYS-07 | Hands-on exercises for each sysadmin lesson with Docker lab environments | jrei/systemd-ubuntu:22.04 for systemd labs; standard ubuntu:22.04 for most others; verify.sh PASS/FAIL pattern; loopback file device trick for disk labs |
| SYS-08 | Module cheat sheet with sysadmin commands and concepts | QuickReference component per lesson topic (6 components, one per SYS-01–06); follows Phase 2/3/4 pattern; final MDX file at 07-cheat-sheet.mdx |
| CICD-01 | Lesson on CI/CD concepts — what it is, why it matters, build/test/deploy lifecycle | CI (integration + test on every push) vs CD (continuous delivery vs deployment); pipeline stages; artifact concepts; feedback loop value; sets context for CICD-02 |
| CICD-02 | Lesson on GitHub Actions — workflows, triggers, jobs, steps, artifacts | .github/workflows/ location; on: triggers (push, pull_request, workflow_dispatch, schedule); jobs with runs-on; steps with uses/run; GITHUB_TOKEN; secrets context; artifacts upload/download |
| CICD-03 | Lesson on building and testing in pipelines — Docker builds, test automation, linting | actions/checkout@v6; docker/setup-buildx-action@v4; docker/build-push-action@v7; eslint/npm test in pipeline; matrix strategy for multi-version testing |
| CICD-04 | Lesson on deployment strategies — blue/green, rolling, canary concepts | Conceptual-only per locked decision; diagrams via ASCII/Callout; blue/green (full env swap, instant rollback), rolling (partial replacement), canary (traffic splitting) — no implementation |
| CICD-05 | Hands-on exercises building real CI/CD pipelines | Complete YAML workflow for docker/app/ — lint → test → build → push to ghcr.io; learner copies into their own repo; VerificationChecklist items learner checks manually |
| CICD-06 | Module cheat sheet with CI/CD patterns and GitHub Actions syntax | QuickReference component per lesson topic (4 components for CICD-01–04); GitHub Actions YAML syntax reference items |
</phase_requirements>

---

## Summary

Phase 5 is a content-authoring phase — no new npm dependencies required. The Next.js platform, MDX pipeline, and all content components are fully operational from Phases 1–4. The work is exclusively writing MDX lessons and building Docker lab environments for two content modules: `04-sysadmin` and `05-cicd`.

The sysadmin module requires a special Docker image (`jrei/systemd-ubuntu:22.04`) for lessons SYS-02 and SYS-03 that need a running systemd daemon. This image is confirmed available on Docker Hub and actively maintained. Most other sysadmin labs (SYS-01, SYS-04, SYS-05, SYS-06) can use standard `ubuntu:22.04` with sysstat/cron/procps packages. For disk management labs (SYS-04), loopback devices (`truncate -s 1G /tmp/disk.img && losetup /dev/loop0 /tmp/disk.img`) work reliably inside containers and avoid the need for real block devices.

The CI/CD module is primarily conceptual-plus-YAML. Exercises are workflow YAML files the learner copies into their own GitHub repo — no container lab infrastructure needed. The key technical content is production-quality GitHub Actions YAML using current action versions (actions/checkout@v6, docker/build-push-action@v7, docker/login-action@v4, docker/setup-buildx-action@v4 — all freshly verified in March 2026). The real pipeline exercise builds the `docker/app/` Node.js app that was introduced in Phase 4, giving the course strong continuity.

The two module slugs (`04-sysadmin`, `05-cicd`), accent CSS variables (`--color-module-sysadmin`, `--color-module-cicd`), and both entries in `content/modules/index.ts` are already wired — no module registry changes needed. The Vitest modules test already includes 'sysadmin' and 'cicd' in `validColors` and checks for exactly 8 modules total.

**Primary recommendation:** Structure as two parallel content streams. Wave 1: module registration checks + sysadmin MDX. Wave 2: sysadmin Docker labs. Wave 3: CI/CD MDX + workflow YAML examples. Wave 4: cheat sheets + Vitest count assertion update.

---

## Standard Stack

### Core (no new npm dependencies — all pre-existing)
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| jrei/systemd-ubuntu | 22.04 | Docker image with working systemd daemon | Confirmed pullable; actively maintained; supports Ubuntu 22.04 with cgroup v2; only image confirmed to work for systemctl exercises |
| ubuntu:22.04 | 22.04 | Base for non-systemd sysadmin labs | Same base used in Phase 2 linux labs; all required packages (sysstat, cron, procps) available via apt |
| sysstat | apt package | iostat, vmstat, sar for SYS-06 monitoring lesson | Already added to Phase 2 Dockerfile; confirms the pattern works |
| cron | apt package | cron daemon for SYS-05 scheduling exercises | Standard Ubuntu package; already in ubuntu:22.04 optionally |

### GitHub Actions (used in YAML examples — not installed locally)
| Action | Version | Purpose |
|--------|---------|---------|
| actions/checkout | v6.0.2 | Checkout repository in workflow — ALWAYS first step |
| docker/setup-buildx-action | v4.0.0 | Enable BuildKit for efficient multi-platform Docker builds |
| docker/login-action | v4.0.0 | Authenticate to container registry (ghcr.io) |
| docker/build-push-action | v7.0.0 | Build and push Docker image with full tag metadata |

**Version note:** All four action versions verified directly from GitHub releases on 2026-03-19. The v7 and v4 releases (March 2026) migrated to Node 24 runtime — use these exact major versions.

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| jrei/systemd-ubuntu | ubuntu:22.04 with tini | tini doesn't provide real systemd — systemctl commands won't work; defeats the lesson purpose |
| jrei/systemd-ubuntu | eniocarboni/docker-ubuntu-systemd | Less widely documented; jrei/systemd-ubuntu has more community references and confirmed 22.04 tag |
| loopback devices for disk labs | real additional disk in container | Loopback is simpler, no --device flag needed, works reliably in privileged containers |
| ghcr.io | Docker Hub | ghcr.io uses GITHUB_TOKEN (no separate secret), free tier unlimited for public repos |

---

## Architecture Patterns

### Module Directory Structure

```
content/modules/
├── 04-sysadmin/
│   ├── 01-user-management.mdx      # SYS-01
│   ├── 02-systemd.mdx              # SYS-02
│   ├── 03-logging.mdx              # SYS-03
│   ├── 04-disk-management.mdx      # SYS-04
│   ├── 05-scheduling.mdx           # SYS-05
│   ├── 06-system-monitoring.mdx    # SYS-06
│   └── 07-cheat-sheet.mdx          # SYS-08
├── 05-cicd/
│   ├── 01-cicd-concepts.mdx        # CICD-01
│   ├── 02-github-actions.mdx       # CICD-02
│   ├── 03-building-testing.mdx     # CICD-03
│   ├── 04-deployment-strategies.mdx # CICD-04
│   └── 05-cheat-sheet.mdx          # CICD-06
docker/
├── sysadmin/
│   ├── Dockerfile                  # ubuntu:22.04 base for most labs
│   ├── Dockerfile.systemd          # jrei/systemd-ubuntu:22.04 for SYS-02/03
│   ├── setup/                      # 01-users.sh through 06-monitoring.sh
│   └── verify/                     # 01-users.sh through 06-monitoring.sh
docker/
│   (no new directory for cicd — workflow YAML examples live in content)
```

**Note on CI/CD lab assets:** There is no `docker/cicd/` directory needed. The CICD-05 exercise delivers complete workflow YAML files as MDX `CodeBlock` components. No runtime Docker infrastructure is needed — the learner pastes YAML into their own `.github/workflows/` directory.

### Pattern 1: MDX Frontmatter (established, unchanged)
```mdx
---
title: "systemd: Service Management and the Modern Linux Init System"
description: "Unit files, service lifecycle, targets, journald — how Linux starts and manages services"
module: "System Administration"
moduleSlug: "04-sysadmin"
lessonSlug: "02-systemd"
order: 2
difficulty: "Foundation"
estimatedMinutes: 30
prerequisites: ["04-sysadmin/01-user-management"]
tags: ["systemd", "systemctl", "journald", "units", "services", "init"]
---
```

### Pattern 2: Systemd Lab Container (jrei/systemd-ubuntu)
```dockerfile
# docker/sysadmin/Dockerfile.systemd
FROM jrei/systemd-ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl wget vim nano procps \
    && rm -rf /var/lib/apt/lists/*
COPY verify/ /usr/local/lib/learn-systems/verify/
RUN chmod +x /usr/local/lib/learn-systems/verify/*.sh
```

Run command (required flags):
```bash
docker run -d --name sysadmin-lab \
  --privileged \
  --tmpfs /tmp --tmpfs /run --tmpfs /run/lock \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  jrei/systemd-ubuntu:22.04
```

**macOS note:** On macOS, `/sys/fs/cgroup` is inside the Docker Desktop Linux VM — this mount works correctly. The `--privileged` flag is required for systemd's cgroup management.

### Pattern 3: Standard Sysadmin Lab (ubuntu:22.04)
```dockerfile
# docker/sysadmin/Dockerfile
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    procps sysstat cron \
    at passwd sudo \
    util-linux fdisk mount \
    curl wget vim nano less tree \
    && rm -rf /var/lib/apt/lists/*
COPY verify/ /usr/local/lib/learn-systems/verify/
COPY setup/ /usr/local/lib/learn-systems/setup/
RUN chmod +x /usr/local/lib/learn-systems/verify/*.sh \
             /usr/local/lib/learn-systems/setup/*.sh
RUN useradd -m -s /bin/bash student && \
    echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /home/student
CMD ["/bin/bash"]
```

### Pattern 4: Loopback Device for Disk Labs (SYS-04)
```bash
# Inside container — simulates a real block device for fdisk/mount practice
truncate -s 512M /tmp/disk.img
losetup /dev/loop0 /tmp/disk.img
fdisk /dev/loop0       # partition it
mkfs.ext4 /dev/loop0p1  # format partition
mkdir /mnt/data
mount /dev/loop0p1 /mnt/data
```
This requires `--privileged` or at minimum `--cap-add SYS_ADMIN --device /dev/loop0`. Use `--privileged` for simplicity.

### Pattern 5: GitHub Actions Workflow (production-quality YAML for CICD-05)
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test

  build-push:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v6
      - uses: docker/setup-buildx-action@v4
      - uses: docker/login-action@v4
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v7
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

### Pattern 6: Verify.sh PASS/FAIL (established, unchanged)
```bash
#!/usr/bin/env bash
set -euo pipefail
PASS=0; FAIL=0
check() {
  local desc="$1" result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"; PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"; FAIL=$((FAIL + 1))
  fi
}
# ... checks ...
echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"; exit 1
fi
```

### Anti-Patterns to Avoid

- **Using ubuntu:22.04 for systemd lessons:** systemctl commands will fail — `System has not been booted with systemd as init system` error. Must use jrei/systemd-ubuntu.
- **Mounting /sys/fs/cgroup read-write:** Use `:ro` — systemd inside the container manages its own cgroup subtree and doesn't need write access to the host cgroup root.
- **Skipping --tmpfs flags:** Without `--tmpfs /run --tmpfs /run/lock`, systemd fails at boot with lock file errors.
- **Creating a docker/cicd/ lab directory:** The CI/CD module exercises are YAML-in-MDX, not running containers. No runtime infrastructure needed.
- **Using actions/checkout@v2 or v3 in YAML examples:** These are outdated. Use v6 (current as of March 2026).
- **Using docker/build-push-action@v5 or v6:** v7 is current (March 2026, Node 24 runtime). Use v7.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| systemd in container | Custom init script | jrei/systemd-ubuntu:22.04 | Correct cgroup setup, tmpfs, proper PID 1; hand-rolling always misses edge cases |
| Disk partition lab | Real multi-disk container | loopback file device | Simpler, no --device flag hell; works in --privileged containers reliably |
| GitHub Actions YAML syntax reference | Custom YAML docs | Official workflow-syntax docs | GitHub docs are authoritative and current; no need to restate |
| Deployment strategy diagrams | Custom SVG/image files | ASCII art in Callout components | Consistent with course style; no image files to manage; MDX-native |
| log rotation config | Custom bash rotation | logrotate (pre-installed) | logrotate handles all edge cases; lesson teaches how to configure it, not replace it |

---

## Common Pitfalls

### Pitfall 1: systemd Container cgroup v2 on macOS
**What goes wrong:** On macOS with Docker Desktop (which uses Linux kernel with cgroup v2), mounting `/sys/fs/cgroup` read-only can cause `Failed to mount cgroup at /sys/fs/cgroup/systemd` errors in some Docker Desktop versions.
**Why it happens:** Docker Desktop's Linux VM uses cgroup v2 unified hierarchy; jrei/systemd-ubuntu expects the v1 hierarchy layout.
**How to avoid:** Test with `jrei/systemd-ubuntu:22.04` explicitly (not `latest`). If issues arise, the fallback is using `--cgroupns=host` flag. The CONTEXT.md decision is to document container limitations honestly — "In production you'd manage systemd on a real Linux host; we're using containers to practice the commands."
**Warning signs:** `systemctl` commands hang or return `Failed to connect to bus: No such file or directory`.

### Pitfall 2: MDX Lesson Count Breaking Vitest Test
**What goes wrong:** `lib/__tests__/modules.test.ts` has a test `'docker module has 9 lessons'`. Adding new module MDX files doesn't break existing tests, but adding sysadmin and cicd modules means the `getAllLessonPaths()` total will grow. The test currently checks `'docker module has 9 lessons'` specifically.
**Why it happens:** The modules test validates specific counts per module (docker = 9), not total count. New modules won't break the docker assertion, but a new test for `04-sysadmin` lesson count should be added as part of the phase work.
**How to avoid:** After writing MDX files, update `lib/__tests__/modules.test.ts` to add sysadmin (7 lessons) and cicd (5 lessons) count assertions. The `validColors` array and 8-module count are already correct.

### Pitfall 3: Disk Lab Loopback Persistence
**What goes wrong:** Loopback device (`/dev/loop0`) is not persistent across container restarts. If learner exits and re-enters the container, the loop device is gone.
**Why it happens:** `/dev/loop0` is a kernel construct set up at runtime — not stored in the container's writable layer.
**How to avoid:** Disk lab setup script (`setup/04-disk.sh`) must run `losetup` on every container start. Use `docker run --rm` pattern so learners start fresh each session. Verify script checks the loopback is set up before testing fdisk/mount steps.

### Pitfall 4: GitHub Actions YAML Indentation
**What goes wrong:** YAML workflow files fail with cryptic errors when indentation uses tabs or mixed spaces.
**Why it happens:** YAML spec requires spaces only; tabs are illegal. MDX CodeBlock rendering hides this visually.
**How to avoid:** Ensure all YAML in CodeBlock examples uses consistent 2-space indentation. Add a `<Callout type="warning">` near the YAML examples noting the spaces-not-tabs requirement.

### Pitfall 5: fstab Entry Causes Boot Failure (lesson clarification needed)
**What goes wrong:** Adding wrong entries to `/etc/fstab` on a real system prevents the system from booting.
**Why it happens:** Kernel mounts all fstab entries at boot; a bad entry causes emergency mode.
**How to avoid:** The lesson should emphasize testing with `mount -a` before rebooting, and teach `nofail` as a safety option for non-critical mounts. In the Docker lab, there's no "reboot" — this is a good place for a `<Callout type="warning">` about real-system behavior.

---

## Code Examples

### systemd Unit File (for SYS-02 lesson)
```ini
# /etc/systemd/system/hello.service
[Unit]
Description=Hello World Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/hello.sh
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

### journalctl Filtering (for SYS-02/03 lessons)
```bash
# Follow logs for a specific service
journalctl -u hello.service -f

# Logs since last boot
journalctl -b

# Logs in a time window
journalctl --since "1 hour ago"

# Only errors and above
journalctl -p err

# Filter by service AND time range
journalctl -u nginx.service --since "2026-01-01" --until "2026-01-02"
```

### Cron vs systemd Timer comparison (for SYS-05 lesson)
```bash
# cron syntax: min hour day month weekday command
# Run at 2:30 AM every day
30 2 * * * /usr/local/bin/backup.sh

# Run at 9 AM on weekdays
0 9 * * 1-5 /usr/local/bin/report.sh
```

```ini
# systemd timer equivalent — requires TWO files
# /etc/systemd/system/backup.timer
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=*-*-* 02:30:00
Persistent=true

[Install]
WantedBy=timers.target

# /etc/systemd/system/backup.service
[Unit]
Description=Daily Backup

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

```bash
# Validate calendar expression
systemd-analyze calendar "*-*-* 02:30:00"
```

### GitHub Actions: Manual trigger + environment variable (for CICD-02)
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deployment environment'
        required: true
        default: 'staging'
        type: choice
        options: [staging, production]

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: actions/checkout@v6
      - run: echo "Deploying to ${{ inputs.environment }}"
```

### Deployment Strategies ASCII Diagram (for CICD-04 lesson)
```
Blue-Green:
  Before:  [LB] → [v1][v1][v1]  (blue active)
           [v2][v2][v2]           (green idle)
  Switch:  [LB] → [v2][v2][v2]  (green active, instant)
           [v1][v1][v1]           (blue on standby for rollback)

Rolling:
  Start:   [v1][v1][v1][v1][v1]
  Step 1:  [v2][v1][v1][v1][v1]
  Step 2:  [v2][v2][v1][v1][v1]
  Done:    [v2][v2][v2][v2][v2]

Canary:
  Start:   [v1][v1][v1][v1][v1]  (100% traffic)
  Phase 1: [v2][v1][v1][v1][v1]  (5% → v2)
  Phase 2: [v2][v2][v2][v1][v1]  (25% → v2, monitor)
  Done:    [v2][v2][v2][v2][v2]  (100% if metrics OK)
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| SysV init (/etc/init.d scripts) | systemd units + systemctl | Ubuntu 15.04 (2015) | All modern Ubuntu uses systemd; SysV scripts still work via compatibility shim but don't teach correct mental model |
| docker-compose.yml (v2 file) | compose.yml (Compose v2 spec) | Docker Compose v2 (2021) | Already established in Phase 4; CI/CD lesson refers to the same compose.yml for the pipeline exercise |
| actions/checkout@v2-v3 | actions/checkout@v6 | March 2026 | Node 24 runtime; v2/v3 examples in tutorials are outdated |
| docker/build-push-action@v5 | docker/build-push-action@v7 | March 2026 | Node 24 runtime; major version bump |
| Docker Hub for registry | ghcr.io (GitHub Container Registry) | 2020–present | ghcr.io uses GITHUB_TOKEN with no extra setup; no Docker Hub rate limits |
| /etc/init.d/cron | cron as systemd-managed service | Ubuntu 16.04+ | On Ubuntu 22.04, cron runs as a systemd service — `systemctl status cron` |

**Deprecated/outdated:**
- `docker-compose` (with hyphen, v1 Python binary): Replaced by `docker compose` (v2 plugin). Phase 4 already uses v2; maintain consistency.
- `upstart`: Ubuntu init system before systemd. No longer relevant. Do not mention in lessons.
- `/var/log/syslog` direct writes: Modern Ubuntu routes most logs through journald; `/var/log/syslog` is populated by rsyslog as a journald consumer, not the primary store.

---

## Open Questions

1. **systemd inside Docker on Apple Silicon (M1/M2/M3) Macs**
   - What we know: jrei/systemd-ubuntu:22.04 is amd64; Docker Desktop on Apple Silicon uses Rosetta 2 emulation or arm64 images
   - What's unclear: Whether jrei/systemd-ubuntu:22.04 works on arm64 hosts without performance penalty; no confirmed arm64 variant
   - Recommendation: Add a `<Callout type="tip">` noting that on Apple Silicon, systemd exercises may be slow (emulation) — acceptable for learning. The lesson content is about commands, not performance. If the image fails to run, the fallback is `--platform linux/amd64` flag: `docker run --platform linux/amd64 --privileged ...`

2. **Number of MDX files per module for Vitest test assertion**
   - What we know: modules.test.ts checks docker module has 9 lessons; sysadmin has 7 files (01–06 lessons + 07 cheat-sheet), cicd has 5 files (01–04 lessons + 05 cheat-sheet)
   - What's unclear: Whether the planner adds the count-assertion update in the same plan wave as MDX authoring or as a dedicated task
   - Recommendation: Add Vitest assertion update as the final task in the last plan wave after all MDX files are confirmed written

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.0 |
| Config file | vitest.config.ts |
| Quick run command | `npx vitest run` |
| Full suite command | `npx vitest run --reporter=verbose` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| SYS-01 | MDX frontmatter parses without error | unit | `npx vitest run lib/__tests__/mdx.test.ts` | ✅ |
| SYS-02 | systemd MDX renders (lesson count passes) | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ (needs count update) |
| SYS-07 | Sysadmin module has 7 lessons in filesystem scan | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ (needs new assertion) |
| SYS-08 | accentColor 'sysadmin' is valid in module registry | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ already validates |
| CICD-02 | CI/CD MDX frontmatter parses | unit | `npx vitest run lib/__tests__/mdx.test.ts` | ✅ |
| CICD-05 | CI/CD module has 5 lessons | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ (needs new assertion) |
| CICD-06 | accentColor 'cicd' is valid in module registry | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ already validates |
| Docker labs (SYS-07) | verify.sh returns exit 0 after exercises | manual-only | `bash docker/sysadmin/verify/NN-<name>.sh` | ❌ Wave 0 — new files |

**Manual-only justification for Docker labs:** verify.sh scripts test interactive Docker container state that can't be simulated in Vitest (requires running containers with `--privileged`).

### Sampling Rate
- **Per task commit:** `npx vitest run`
- **Per wave merge:** `npx vitest run --reporter=verbose`
- **Phase gate:** Full suite green before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `lib/__tests__/modules.test.ts` — add `'04-sysadmin module has 7 lessons'` and `'05-cicd module has 5 lessons'` assertions
- [ ] `docker/sysadmin/verify/01-users.sh` through `06-monitoring.sh` — new verify scripts (6 files)
- [ ] `docker/sysadmin/setup/01-users.sh` through `06-monitoring.sh` — new setup scripts (6 files)
- [ ] `docker/sysadmin/Dockerfile` and `docker/sysadmin/Dockerfile.systemd` — two Dockerfiles needed

---

## Sources

### Primary (HIGH confidence)
- Docker Hub: `hub.docker.com/r/jrei/systemd-ubuntu` — image existence, supported tags (22.04 confirmed), run flags
- GitHub: `github.com/actions/checkout/releases` — v6.0.2 (verified 2026-03-19)
- GitHub: `github.com/docker/build-push-action/releases` — v7.0.0 (verified 2026-03-19)
- GitHub: `github.com/docker/login-action/releases` — v4.0.0 (verified 2026-03-19)
- GitHub: `github.com/docker/setup-buildx-action/releases` — v4.0.0 (verified 2026-03-19)
- Project codebase: `content/modules/index.ts` — confirmed `04-sysadmin`/`05-cicd` slugs and accentColors already registered
- Project codebase: `app/globals.css` lines 35–36 — confirmed CSS variables `--color-module-sysadmin` and `--color-module-cicd` exist
- Project codebase: `lib/__tests__/modules.test.ts` — confirmed `validColors` already includes 'sysadmin' and 'cicd'

### Secondary (MEDIUM confidence)
- WebSearch + official docs: GitHub Actions workflow syntax — triggers, jobs, steps, secrets, GITHUB_TOKEN patterns
- WebSearch: Deployment strategies (blue/green, rolling, canary) — multiple CNCF/authoritative sources confirming definitions
- WebSearch: systemd unit file format, journalctl filtering, cron/OnCalendar= syntax — ArchWiki and official freedesktop.org docs

### Tertiary (LOW confidence, flagged)
- WebSearch: cgroup v2 + systemd container compatibility on macOS Docker Desktop — multiple sources but no single authoritative "it works on M3 Mac" confirmation; marked as Open Question

---

## Metadata

**Confidence breakdown:**
- Standard stack (sysadmin Docker images, action versions): HIGH — directly verified from Docker Hub and GitHub release pages
- Architecture (MDX file naming, verify.sh pattern, module registry): HIGH — directly inspected from existing phases 2–4
- CI/CD YAML (action versions, ghcr.io auth pattern): HIGH — verified from official GitHub release pages March 2026
- Pitfalls (systemd/cgroup macOS): MEDIUM — multiple sources agree but not definitively tested on all Mac hardware generations

**Research date:** 2026-03-19
**Valid until:** 2026-04-19 (action versions move fast — re-verify major versions before authoring CICD-02/03 if planning is delayed more than 2 weeks)
