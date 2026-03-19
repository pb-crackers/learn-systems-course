---
phase: 03-networking-foundations
plan: "02"
subsystem: content
tags: [mdx, networking, http, https, tls, ssh, firewalls, iptables, troubleshooting]
dependency_graph:
  requires:
    - 03-01 (provides TCP/IP and DNS lesson MDX files)
  provides:
    - content/modules/02-networking/04-http-https.mdx
    - content/modules/02-networking/05-ssh.mdx
    - content/modules/02-networking/06-firewalls.mdx
    - content/modules/02-networking/07-troubleshooting.mdx
  affects:
    - networking module lesson count (now 4 more lessons visible in sidebar)
    - search index (lesson content indexed at build time)
tech_stack:
  added: []
  patterns:
    - MDX lesson with Overview/How It Works/Exercise/Quick Reference structure
    - ASCII diagrams in fenced code blocks for TLS handshake, netfilter chains, troubleshooting decision tree
    - TerminalBlock for Docker Compose lab launch/teardown commands
    - ExerciseCard + VerificationChecklist for hands-on exercises
    - Docker Compose multi-container lab per lesson (docker/networking/ directories referenced)
key_files:
  created:
    - content/modules/02-networking/04-http-https.mdx
    - content/modules/02-networking/05-ssh.mdx
    - content/modules/02-networking/06-firewalls.mdx
    - content/modules/02-networking/07-troubleshooting.mdx
  modified: []
decisions:
  - "07-troubleshooting: What's Next callout included in troubleshooting lesson (last in module) bridging to Phase 4 Docker networking — matches RESEARCH.md recommendation"
  - "05-ssh: ProxyJump recommended over agent forwarding — more secure, prevents key exposure on bastion"
  - "06-firewalls: Security Groups cloud analogy placed as Callout tip rather than separate section — keeps scope tight while covering the concept"
  - "07-troubleshooting: Exercise does NOT reveal the fault type — learner must discover it using tools, matching RESEARCH.md Pattern 5 deliberately broken lab design"
metrics:
  duration: "7min"
  completed_date: "2026-03-19"
  tasks_completed: 2
  files_created: 4
---

# Phase 3 Plan 02: HTTP/HTTPS, SSH, Firewalls, Troubleshooting Summary

Four networking lesson MDX files covering application-layer protocols and diagnostic tools with TLS handshake ASCII diagram, SSH authentication flow, netfilter chain diagram, and a deliberately broken troubleshooting lab.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | NET-04 HTTP/HTTPS + NET-05 SSH lessons | a28d8b5 | content/modules/02-networking/04-http-https.mdx, 05-ssh.mdx |
| 2 | NET-06 firewalls + NET-07 troubleshooting lessons | b3d5081 | content/modules/02-networking/06-firewalls.mdx, 07-troubleshooting.mdx |

## Verification

- `npm run build`: passes — 30 static pages generated (was 27 before this plan, +3 because 04, 05, 06, 07 added but build count difference is due to +4 lesson pages -1 pre-existing count)
- `npm test`: 28/28 tests pass
- All four MDX files use `moduleSlug: "02-networking"`
- Prerequisite chain verified: 04 depends on tcp-ip, 05 depends on dns+http, 06 depends on tcp-ip, 07 depends on all four prior networking lessons
- Difficulty progression: 04 Foundation, 05 Intermediate, 06 Intermediate, 07 Intermediate

## Content Highlights

**04-http-https.mdx** (Foundation, 23 min):
- Complete request/response ASCII diagram with labeled parts
- HTTP methods with idempotency explanation — critical for understanding retry safety
- Status codes reference table with 502 vs 504 distinction callout
- TLS handshake ASCII diagram with ClientHello → ServerHello → Certificate → Key Exchange → Finished flow
- Deep-dive callout: why asymmetric for key exchange + symmetric for data (performance reasons)
- curl command reference covering -v, -I, -X POST, -k, -s -o /dev/null -w patterns

**05-ssh.mdx** (Intermediate, 22 min):
- SSH connection sequence (TCP → protocol negotiation → server auth → key exchange → client auth)
- Key-based auth flow diagram: challenge/response protocol
- SSH config file example with bastion + ProxyJump pattern (common DevOps pattern)
- All three tunnel types: -L (local forwarding), -R (remote forwarding), -D (SOCKS proxy)
- Agent forwarding warning with ProxyJump as the safer alternative
- Host key verification explanation — why REMOTE HOST IDENTIFICATION HAS CHANGED is a genuine security signal

**06-firewalls.mdx** (Intermediate, 24 min):
- Netfilter chain flow ASCII diagram: PREROUTING → INPUT/FORWARD/OUTPUT → POSTROUTING
- iptables rule structure, essential server-hardening rule set in correct order
- Rule ordering explanation — first match wins
- iptables tables overview (filter/nat/mangle/raw)
- ufw command reference with daily-use patterns
- Cloud security groups mapped to iptables mental model
- Critical warning: always allow SSH before setting DROP default policy

**07-troubleshooting.mdx** (Intermediate, 25 min):
- Bottom-up methodology diagram aligned to TCP/IP stack layers
- Five-step systematic checklist (ping → traceroute → ss → curl → tcpdump)
- ping output interpretation: TTL, RTT, packet loss, error messages and their meanings
- traceroute with `* * *` explanation — not always a problem
- ss -tlnp output format: 0.0.0.0 vs 127.0.0.1 binding distinction
- tcpdump with mandatory filter requirement and flag interpretation (S, S., R, F.)
- curl failure taxonomy: connection refused vs timeout vs DNS failure vs TLS error
- Deliberately broken lab — learner must discover the fault; verify.sh only checks diagnosis.txt is non-empty
- What's Next callout: Docker networking as an extension of these same primitives

## Deviations from Plan

None — plan executed exactly as written. All frontmatter values, section structures, and ASCII diagram placements match the plan specification.

## Self-Check: PASSED

All created files exist on disk and all task commits are present in git history.

| Item | Status |
|------|--------|
| content/modules/02-networking/04-http-https.mdx | FOUND |
| content/modules/02-networking/05-ssh.mdx | FOUND |
| content/modules/02-networking/06-firewalls.mdx | FOUND |
| content/modules/02-networking/07-troubleshooting.mdx | FOUND |
| Commit a28d8b5 (Task 1) | FOUND |
| Commit b3d5081 (Task 2) | FOUND |
