---
phase: 02
slug: linux-fundamentals
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-19
---

# Phase 02 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | vitest |
| **Config file** | vitest.config.ts |
| **Quick run command** | `npx vitest run --reporter=verbose` |
| **Full suite command** | `npx vitest run` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `npx vitest run --reporter=verbose`
- **After every plan wave:** Run `npx vitest run`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 02-01-01 | 01 | 1 | LNX-01 | content | `test -f content/modules/01-linux-fundamentals/01-how-computers-work.mdx` | ❌ W0 | ⬜ pending |
| 02-01-02 | 01 | 1 | LNX-02 | content | `test -f content/modules/01-linux-fundamentals/02-operating-systems.mdx` | ❌ W0 | ⬜ pending |
| 02-01-03 | 01 | 1 | LNX-03 | content | `test -f content/modules/01-linux-fundamentals/03-linux-filesystem.mdx` | ❌ W0 | ⬜ pending |
| 02-01-04 | 01 | 1 | LNX-04 | content | `test -f content/modules/01-linux-fundamentals/04-file-permissions.mdx` | ❌ W0 | ⬜ pending |
| 02-01-05 | 01 | 1 | LNX-05 | content | `test -f content/modules/01-linux-fundamentals/05-processes.mdx` | ❌ W0 | ⬜ pending |
| 02-02-01 | 02 | 1 | LNX-06 | content | `test -f content/modules/01-linux-fundamentals/06-shell-fundamentals.mdx` | ❌ W0 | ⬜ pending |
| 02-02-02 | 02 | 1 | LNX-07 | content | `test -f content/modules/01-linux-fundamentals/07-shell-scripting.mdx` | ❌ W0 | ⬜ pending |
| 02-02-03 | 02 | 1 | LNX-08 | content | `test -f content/modules/01-linux-fundamentals/08-text-processing.mdx` | ❌ W0 | ⬜ pending |
| 02-02-04 | 02 | 1 | LNX-09 | content | `test -f content/modules/01-linux-fundamentals/09-package-management.mdx` | ❌ W0 | ⬜ pending |
| 02-03-01 | 03 | 2 | LNX-10 | integration | `docker build -t learn-systems-linux docker/linux-fundamentals/` | ❌ W0 | ⬜ pending |
| 02-04-01 | 04 | 2 | LNX-11 | content | `test -f content/modules/01-linux-fundamentals/10-cheat-sheet.mdx` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] Content directory exists: `content/modules/01-linux-fundamentals/`
- [ ] Docker directory exists: `docker/linux-fundamentals/`
- [ ] Module index updated: `content/modules/index.ts`

*Existing infrastructure covers test framework — vitest already configured.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Lesson renders correctly in browser | LNX-01–09 | Visual rendering check | Open localhost:3000, navigate to each Linux lesson, verify layout |
| Docker lab launches on macOS | LNX-10 | Requires Docker Desktop running | Run `docker run` command from lesson, verify shell access |
| verify.sh prints PASS/FAIL | LNX-10 | Requires running inside container | Complete exercise steps, run verify.sh, check output |
| Sidebar progress updates | LNX-11 | Visual state check | Mark lessons complete, verify sidebar checkmarks update |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
