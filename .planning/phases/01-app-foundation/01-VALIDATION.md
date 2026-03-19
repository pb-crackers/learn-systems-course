---
phase: 1
slug: app-foundation
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-18
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | vitest (bundled with Next.js ecosystem) |
| **Config file** | vitest.config.ts (Wave 0 installs) |
| **Quick run command** | `npx vitest run --reporter=verbose` |
| **Full suite command** | `npx vitest run && npx next build` |
| **Estimated runtime** | ~15 seconds |

---

## Sampling Rate

- **After every task commit:** Run `npx vitest run --reporter=verbose`
- **After every plan wave:** Run `npx vitest run && npx next build`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 1 | APP-01 | build | `npx next build` | ❌ W0 | ⬜ pending |
| 01-02-01 | 02 | 1 | APP-03 | unit | `npx vitest run src/components/sidebar` | ❌ W0 | ⬜ pending |
| 01-02-02 | 02 | 1 | APP-04 | unit | `npx vitest run src/hooks/use-progress` | ❌ W0 | ⬜ pending |
| 01-02-03 | 02 | 1 | APP-05 | unit | `npx vitest run src/hooks/use-theme` | ❌ W0 | ⬜ pending |
| 01-03-01 | 03 | 2 | CONT-01 | build | `npx next build` | ❌ W0 | ⬜ pending |
| 01-03-02 | 03 | 2 | APP-08 | unit | `npx vitest run src/components/code-block` | ❌ W0 | ⬜ pending |
| 01-03-03 | 03 | 2 | APP-07 | unit | `npx vitest run src/components/search` | ❌ W0 | ⬜ pending |
| 01-04-01 | 04 | 2 | CONT-02 | manual | Visual inspection | N/A | ⬜ pending |
| 01-04-02 | 04 | 2 | CONT-05 | manual | Visual inspection | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `vitest` + `@testing-library/react` — test framework setup
- [ ] `vitest.config.ts` — vitest configuration
- [ ] `src/__tests__/setup.ts` — test setup file

*Wave 0 is handled within Plan 01 (project scaffold).*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Dark mode visual correctness | APP-05 | Visual appearance check | Toggle dark/light, verify no contrast issues |
| Mobile responsive layout | APP-06 | Layout reflow check | Resize to 768px, verify sidebar collapses to drawer |
| Lesson page visual structure | CONT-02 | Content rendering quality | Open sample lesson, verify section ordering |
| Exercise card expandability | CONT-05 | Interactive component | Click exercise cards, verify expand/collapse |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
