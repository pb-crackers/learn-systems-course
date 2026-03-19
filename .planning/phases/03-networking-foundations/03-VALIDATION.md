---
phase: 03
slug: networking-foundations
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-19
---

# Phase 03 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | vitest + docker compose |
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

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | NET-01, NET-02 | content | `test -f content/modules/02-networking/01-how-networks-work.mdx` | ❌ W0 | ⬜ pending |
| 03-01-02 | 01 | 1 | NET-03 | content | `test -f content/modules/02-networking/03-dns.mdx` | ❌ W0 | ⬜ pending |
| 03-02-01 | 02 | 1 | NET-04, NET-05 | content | `test -f content/modules/02-networking/04-http-https.mdx` | ❌ W0 | ⬜ pending |
| 03-02-02 | 02 | 1 | NET-06, NET-07 | content | `test -f content/modules/02-networking/06-firewalls.mdx` | ❌ W0 | ⬜ pending |
| 03-03-01 | 03 | 2 | NET-08 | integration | `docker compose -f docker/networking/labs/02-tcpip/compose.yml config` | ❌ W0 | ⬜ pending |
| 03-03-02 | 03 | 2 | NET-08 | integration | `docker compose -f docker/networking/labs/05-ssh/compose.yml config` | ❌ W0 | ⬜ pending |
| 03-04-01 | 04 | 2 | NET-09 | content | `test -f content/modules/02-networking/08-cheat-sheet.mdx` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] Content directory exists: `content/modules/02-networking/`
- [ ] Docker directory exists: `docker/networking/`
- [ ] Module index includes networking entry: `content/modules/index.ts`

*Existing infrastructure covers test framework — vitest already configured.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Lesson renders correctly in browser | NET-01–07 | Visual rendering check | Open localhost:3000, navigate to each networking lesson |
| Docker Compose labs launch correctly | NET-08 | Requires Docker Desktop running | Run `docker compose up` from each lab directory |
| Multi-container networking works | NET-08 | Runtime behavior | Verify client can reach server across custom bridge network |
| verify.sh prints PASS/FAIL | NET-08 | Requires running inside container | Complete exercise, run verify.sh |
| Deliberately broken lab is diagnosable | NET-07 | Pedagogical quality check | Follow troubleshooting lesson, verify fault is findable |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
