---
phase: 13
slug: quiz-component-build
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-22
---

# Phase 13 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Vitest 4.1.0 + @testing-library/react 16.3.2 |
| **Config file** | vitest.config.ts |
| **Quick run command** | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` |
| **Full suite command** | `npx vitest run` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `npx vitest run components/lesson/__tests__/Quiz.test.tsx`
- **After every plan wave:** Run `npx vitest run`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 13-01-01 | 01 | 1 | QUIZ-01, QUIZ-02, QUIZ-04 | unit (reducer) | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` | ❌ W0 | ⬜ pending |
| 13-01-02 | 01 | 1 | QUIZ-03, QUIZ-05, QUIZ-06 | unit (reducer) + integration | `npx vitest run components/lesson/__tests__/Quiz.test.tsx` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `components/lesson/__tests__/` directory — does not exist yet
- [ ] `components/lesson/__tests__/Quiz.test.tsx` — stubs for QUIZ-01 through QUIZ-06

*Wave 0 creates test infrastructure as part of TDD task execution.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| 2s auto-dismiss animation | QUIZ-02 | Visual timing | Open quiz, select wrong answer, verify banner dismisses after ~2s |
| Pass screen visual appearance | QUIZ-06 | Visual design | Answer all questions correctly, verify celebratory card renders |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
