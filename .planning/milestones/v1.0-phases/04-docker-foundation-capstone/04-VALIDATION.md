---
phase: 04
slug: docker-foundation-capstone
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-19
---

# Phase 04 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | vitest + npm run build |
| **Config file** | vitest.config.ts |
| **Quick run command** | `npx vitest run --reporter=verbose` |
| **Full suite command** | `npx vitest run && npm run build` |
| **Estimated runtime** | ~15 seconds (vitest) + ~30 seconds (build) |

---

## Sampling Rate

- **After every task commit:** Run `npx vitest run --reporter=verbose`
- **After every plan wave:** Run `npm run build`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | Status |
|---------|------|------|-------------|-----------|-------------------|--------|
| 04-01-01 | 01 | 1 | DOC-01,02,03 | content | `test -f content/modules/03-docker/01-what-containers-are.mdx` | ⬜ pending |
| 04-01-02 | 01 | 1 | DOC-04,05 | content | `test -f content/modules/03-docker/04-volumes.mdx` | ⬜ pending |
| 04-02-01 | 02 | 1 | DOC-06,07 | content | `test -f content/modules/03-docker/06-compose.mdx` | ⬜ pending |
| 04-03-01 | 03 | 2 | DOC-08 | content | `test -f docker/app/package.json` | ⬜ pending |
| 04-04-01 | 04 | 2 | DOC-09 | content | `test -f content/modules/03-docker/08-cheat-sheet.mdx` | ⬜ pending |
| 04-05-01 | 05 | 3 | CAP-01 | integration | `test -f content/modules/03-docker/10-foundation-capstone.mdx` | ⬜ pending |

---

## Wave 0 Requirements

- [ ] Content directory exists: `content/modules/03-docker/`
- [ ] Module index includes docker entry: `content/modules/index.ts`

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Docker lessons render correctly | DOC-01–07 | Visual rendering | Navigate to each Docker lesson in browser |
| Progressive app exercises work | DOC-08 | Requires Docker running | Build and run the progressive app per each lesson |
| Capstone verify.sh passes | CAP-01 | Requires learner to complete project | Complete capstone, run verify.sh |

---

## Validation Sign-Off

- [ ] All tasks have automated verify
- [ ] Sampling continuity maintained
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
