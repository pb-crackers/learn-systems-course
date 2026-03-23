---
phase: 07
slug: monitoring-advanced-capstone
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-19
---

# Phase 07 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | vitest |
| **Config file** | vitest.config.ts |
| **Quick run command** | `npx vitest run --reporter=verbose` |
| **Full suite command** | `npx vitest run --reporter=verbose` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `npx vitest run --reporter=verbose`
- **After every plan wave:** Run `npx vitest run --reporter=verbose`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 07-01-01 | 01 | 1 | MON-01 | unit | `npx vitest run` | ❌ W0 | ⬜ pending |
| 07-01-02 | 01 | 1 | MON-02 | unit | `npx vitest run` | ❌ W0 | ⬜ pending |
| 07-01-03 | 01 | 1 | MON-03 | unit | `npx vitest run` | ❌ W0 | ⬜ pending |
| 07-01-04 | 01 | 1 | MON-04 | unit | `npx vitest run` | ❌ W0 | ⬜ pending |
| 07-01-05 | 01 | 1 | MON-05 | unit | `npx vitest run` | ❌ W0 | ⬜ pending |
| 07-02-01 | 02 | 1 | MON-06 | unit | `npx vitest run` | ❌ W0 | ⬜ pending |
| 07-02-02 | 02 | 1 | MON-07 | unit | `npx vitest run` | ❌ W0 | ⬜ pending |
| 07-03-01 | 03 | 2 | CAP-02 | integration | `npx vitest run` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] Vitest assertions for 08-monitoring module lessons (MON-01 through MON-05)
- [ ] Vitest assertions for monitoring exercises and cheat sheet (MON-06, MON-07)
- [ ] Vitest assertions for advanced capstone project files (CAP-02)

*Existing Vitest infrastructure covers framework setup — only module-specific assertions needed.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Docker Compose monitoring stack runs | MON-06 | Requires Docker runtime | `cd docker/monitoring && docker compose up -d` and verify all services healthy |
| Grafana dashboard renders metrics | MON-06 | Requires browser + running stack | Open localhost:3000, verify dashboard panels show data |
| Alertmanager fires test alert | MON-04 | Requires running Prometheus + Alertmanager | Trigger test alert, verify notification arrives |
| Capstone failure scenario diagnosis | CAP-02 | Requires running full stack + manual investigation | Start capstone, observe memory leak in Grafana, identify root cause |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
