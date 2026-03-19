# Phase 5: System Administration & CI/CD - Context

**Gathered:** 2026-03-19
**Status:** Ready for planning

<domain>
## Phase Boundary

Write all System Administration lessons (SYS-01 through SYS-06), build sysadmin Docker lab environments with verification (SYS-07), create the sysadmin cheat sheet (SYS-08), write all CI/CD lessons (CICD-01 through CICD-04), build CI/CD exercises (CICD-05), and create the CI/CD cheat sheet (CICD-06). Two separate content modules delivered in one phase.

</domain>

<decisions>
## Implementation Decisions

### System Administration Lesson Approach
- Docker containers with systemd using systemd-enabled images (jrei/systemd-ubuntu or similar, --privileged) for realistic service management exercises
- Practical disk management: df, du, mount, fstab with mechanism explanations of block devices and filesystems — not full LVM deep-dive
- Monitoring lesson focuses on top/htop/vmstat/iostat with real bottleneck identification scenarios — sets up Phase 7's Prometheus/Grafana
- Cron and systemd timers covered with real scheduling exercises

### CI/CD Lesson Approach
- GitHub Actions as the CI/CD platform — most popular, free tier, learner likely has a GitHub account
- Exercises are primarily about understanding and writing YAML workflow files — provide complete workflow YAML that learner can copy into their own repo
- Deployment strategies (blue/green, rolling, canary) covered conceptually with diagrams, not implemented
- Real pipeline exercise: complete workflow YAML for the progressive Docker app — lint → test → build image → push to registry

### Content Organization
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

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- All content components from Phase 1
- Phase 2-4 patterns: MDX structure, verify.sh PASS/FAIL, Docker labs, Compose labs
- Progressive Node.js app at docker/app/ (reused in CI/CD pipeline exercise)
- lib/modules.ts filesystem scanning, search, progress — all working

### Established Patterns
- MDX frontmatter, lesson ordering, verify.sh pattern, Docker base image approach
- Module content at content/modules/{slug}/ with numbered MDX files
- Module metadata in content/modules/index.ts

### Integration Points
- New MDX files in content/modules/04-sysadmin/ and content/modules/05-cicd/
- Module index needs both module entries
- Docker labs in docker/sysadmin/ directory
- CI/CD workflow examples in docker/cicd/ or similar

</code_context>

<specifics>
## Specific Ideas

- Systemd lessons must acknowledge container limitations honestly — "In production you'd manage systemd on a real Linux host; we're using containers to practice the commands"
- CI/CD pipeline should build the same Docker app from Phase 4 — continuity across the course
- GitHub Actions YAML should be production-quality, not toy examples

</specifics>

<deferred>
## Deferred Ideas

- Ansible/configuration management (ADV-02, v2)
- Security hardening module (ADV-03, v2)

</deferred>

---

*Phase: 05-system-administration-ci-cd*
*Context gathered: 2026-03-19*
