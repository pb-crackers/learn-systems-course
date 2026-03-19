---
phase: 06
slug: infrastructure-as-code-cloud
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-19
---

# Phase 06 — Validation Strategy

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | vitest + npm run build |
| **Quick run command** | `npx vitest run --reporter=verbose` |
| **Full suite command** | `npx vitest run && npm run build` |

## Sampling Rate
- **After every task commit:** `npx vitest run --reporter=verbose`
- **After every plan wave:** `npm run build`
- **Max feedback latency:** 15 seconds

## Manual-Only Verifications
| Behavior | Requirement | Why Manual |
|----------|-------------|------------|
| OpenTofu exercises run | IAC-05 | Requires tofu CLI installed |
| HCL creates Docker containers | IAC-05 | Live Docker daemon needed |
| Lessons render correctly | ALL | Visual check |

**Approval:** pending
