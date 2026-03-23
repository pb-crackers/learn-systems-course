---
phase: 05
slug: system-administration-ci-cd
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-19
---

# Phase 05 — Validation Strategy

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | vitest + npm run build |
| **Quick run command** | `npx vitest run --reporter=verbose` |
| **Full suite command** | `npx vitest run && npm run build` |
| **Estimated runtime** | ~15s + ~30s |

## Sampling Rate

- **After every task commit:** `npx vitest run --reporter=verbose`
- **After every plan wave:** `npm run build`
- **Max feedback latency:** 15 seconds

## Manual-Only Verifications

| Behavior | Requirement | Why Manual |
|----------|-------------|------------|
| systemd labs work with --privileged | SYS-02, SYS-03 | Requires Docker + privileged mode |
| Disk management labs work | SYS-04 | Requires --privileged for loopback |
| GitHub Actions YAML is valid | CICD-02–05 | Would need GitHub runner to validate |
| Lessons render correctly | ALL | Visual check |

**Approval:** pending
