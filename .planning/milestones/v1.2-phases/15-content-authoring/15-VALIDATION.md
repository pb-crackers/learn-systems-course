---
phase: 15
slug: content-authoring
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-22
---

# Phase 15 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | TypeScript compiler (tsc) |
| **Config file** | tsconfig.json |
| **Quick run command** | `npx tsc --noEmit 2>&1 \| grep -v "__tests__\|\.test\." \| grep "error TS" \| head -20` |
| **Full suite command** | `npx tsc --noEmit 2>&1 \| grep -v "__tests__\|\.test\." \| grep "error TS" \| wc -l` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run quick tsc check (scoped to non-test files)
- **After every plan wave:** Run full tsc check + count errors
- **Before `/gsd:verify-work`:** Full suite must show 0 non-test errors
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 15-0X-01 | 01-08 | 1-4 | DATA-03 | type-check | `npx tsc --noEmit` | ✅ | ⬜ pending |

*Each module plan has one task per module. All verified via tsc --noEmit.*

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- Existing infrastructure covers all phase requirements (quiz type, MDX pipeline, layout integration all complete from Phases 12-14)

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Quiz quality | DATA-03 | Content quality judgment | Review distractor plausibility, explanation accuracy for each module |
| Quiz renders on every lesson | DATA-03 | Visual confirmation | Navigate to random lessons across modules, verify quiz renders |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
