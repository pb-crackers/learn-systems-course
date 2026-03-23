---
phase: 03-networking-foundations
plan: "01"
subsystem: content
tags: [mdx, networking, tcp-ip, dns, ethernet, switches, routers, packets, dig]

requires:
  - phase: 02-linux-fundamentals
    provides: "Lesson MDX pattern (frontmatter, ExerciseCard, VerificationChecklist, QuickReference, Callout), content/modules/index.ts registry slug convention"
  - phase: 01-app-foundation
    provides: "MDX pipeline, getLessonContent, extractFrontmatter, getLessonsForModule filesystem scanner"
provides:
  - "NET-01: Physical networking lesson (01-how-networks-work.mdx) — Ethernet frames, switches, routers, ARP, packet vs frame"
  - "NET-02: TCP/IP stack lesson (02-tcp-ip-stack.mdx) — four layers, encapsulation, IP/subnets, TCP handshake, UDP, ports"
  - "NET-03: DNS lesson (03-dns.mdx) — resolution chain, record types, TTL/caching, dig, CoreDNS lab"
affects: [03-02-PLAN, 03-03-PLAN, 03-04-PLAN, 04-docker]

tech-stack:
  added: []
  patterns:
    - "Networking MDX frontmatter: moduleSlug must be '02-networking' (matches content/modules/index.ts registry)"
    - "Prerequisite chain: 01 depends on linux shell, 02 depends on 01, 03 depends on 02"
    - "Multi-container Compose labs: docker compose -f docker/networking/<lab>/compose.yml up -d"
    - "DNS lab uses CoreDNS image (coredns/coredns:latest) with Corefile config, client uses @dns server arg in dig"

key-files:
  created:
    - content/modules/02-networking/01-how-networks-work.mdx
    - content/modules/02-networking/02-tcp-ip-stack.mdx
    - content/modules/02-networking/03-dns.mdx
  modified: []

key-decisions:
  - "moduleSlug: '02-networking' used in all three files — confirmed against content/modules/index.ts registry slug"
  - "NET-01 exercise uses docker run (single container for ip/ARP inspection — no Compose needed)"
  - "NET-02 exercise uses docker run (TCP/IP inspection via ss, ip — no multi-container interaction needed)"
  - "NET-03 exercise references docker compose -f docker/networking/03-dns/compose.yml — Compose lab exists in Phase 3 plan 02+"
  - "TCP handshake diagram uses ASCII art in a fenced code block (no language tag) — monospace rendering via CodeBlock"

patterns-established:
  - "Networking lesson overview: 'Why This Matters' scenario where broken network is the pain point"
  - "ASCII diagrams in fenced code blocks without language tag for packet/frame/stack structures"
  - "Phase 4 bridge callout: Callout type=tip explaining Docker networking builds directly on these primitives"

requirements-completed: [NET-01, NET-02, NET-03]

duration: 6min
completed: 2026-03-19
---

# Phase 3 Plan 01: Networking Foundations Lessons 01-03 Summary

**Three MDX lesson files covering physical networking, TCP/IP stack, and DNS — mechanism-first with ASCII diagrams, ExerciseCard exercises, and QuickReference sections for the 02-networking module**

## Performance

- **Duration:** 6 min
- **Started:** 2026-03-19T11:27:27Z
- **Completed:** 2026-03-19T11:33:12Z
- **Tasks:** 2 (Task 1: two files; Task 2: one file)
- **Files modified:** 3 created

## Accomplishments
- Created `01-how-networks-work.mdx`: Ethernet frames with ASCII header diagram, switch MAC table learning/forwarding, router routing table + ASCII topology, packet-in-frame encapsulation diagram, ARP deep-dive callout, Docker bridge tip
- Created `02-tcp-ip-stack.mdx`: TCP/IP four-layer model, encapsulation flow diagram, IPv4/CIDR subnet addressing, TCP three-way handshake ASCII diagram, congestion control deep-dive, UDP comparison table, port multiplexing diagram, ss -tlnp tip callout
- Created `03-dns.mdx`: Full resolution chain ASCII diagram (browser → OS → recursive → root → TLD → authoritative), DNS record types table, TTL/caching layer diagram, DNS propagation warning, Docker embedded resolver tip, DNSSEC deep-dive, ExerciseCard using CoreDNS Compose lab with dig/+trace/-x

## Task Commits

1. **Task 1: NET-01 physical networking + NET-02 TCP/IP stack lessons** - `40be141` (feat)
2. **Task 2: NET-03 DNS lesson** - `fe36f3d` (feat)

**Plan metadata:** (pending final commit)

## Files Created/Modified
- `content/modules/02-networking/01-how-networks-work.mdx` - Physical networking: Ethernet frames, switches, routers, ARP, packet/frame encapsulation
- `content/modules/02-networking/02-tcp-ip-stack.mdx` - TCP/IP stack: four layers, encapsulation, IPv4/subnets, TCP handshake, UDP, ports
- `content/modules/02-networking/03-dns.mdx` - DNS: resolution chain, record types, TTL/caching, dig commands, CoreDNS Compose lab

## Decisions Made
- Used `docker run` for lessons 01 and 02 exercises (single container sufficient — no multi-container interaction needed for IP/ARP/TCP inspection)
- DNS lesson references Compose lab at `docker/networking/03-dns/compose.yml` — this lab file is created in plan 02+
- All lessons use `moduleSlug: "02-networking"` to match the canonical slug in `content/modules/index.ts`

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

Build had a stale lock file from a previous `next build` process; killed with `pkill -f "next build"` before re-running. Not a code issue — environmental.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness
- Three foundational networking lessons are complete and building successfully
- Prerequisite chain is established: DNS (03) depends on TCP/IP (02) depends on physical (01)
- Plan 02 can build lessons 04-07 (HTTP/HTTPS, SSH, firewalls, troubleshooting) and Compose labs
- DNS Compose lab (`docker/networking/03-dns/`) is referenced in lesson 03 but not yet created — plan 02 must include it

---
*Phase: 03-networking-foundations*
*Completed: 2026-03-19*
