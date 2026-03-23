# Phase 3: Networking Foundations - Context

**Gathered:** 2026-03-19
**Status:** Ready for planning

<domain>
## Phase Boundary

Write all Networking Foundations lesson content (NET-01 through NET-07), build Docker Compose-based multi-container lab environments with automated verification (NET-08), and create the module cheat sheet (NET-09). This phase produces curriculum content using the patterns established in Phase 1 and followed in Phase 2 — no platform changes.

</domain>

<decisions>
## Implementation Decisions

### Lesson Content & Depth
- Deep mechanism explanations covering packet structure, TCP three-way handshake internals, windowing, congestion control, DNS resolution chain — same depth standard as Phase 2
- ASCII diagrams in CodeBlock for packet headers, TCP handshake flows, DNS resolution sequences, HTTP request/response cycles
- Every lesson opens with a "Why This Matters" real-world scenario (e.g., "Your API is timing out — here's how TCP retransmission explains why") — per CONT-08
- Each lesson targets 15-25 min reading time — same standard as Phase 2

### Multi-Container Lab Design
- Docker Compose for networking labs — multiple containers needed to demonstrate real network interactions (client/server, DNS resolver, firewall host)
- Custom bridge networks per lab — learner sees isolated subnets, container DNS, and inter-container communication
- Troubleshooting lesson (NET-07) includes a deliberately broken Compose stack where learner must diagnose the fault
- Same `verify.sh` pattern as Phase 2 — scripts check network state (port open, DNS resolves, firewall rule active) and print PASS/FAIL

### Content Organization
- Linear lesson ordering per REQUIREMENTS: physical/switches → TCP/IP stack → DNS → HTTP/HTTPS → SSH → firewalls → troubleshooting
- Difficulty progression: first 2 (physical, TCP/IP) Foundation; middle 3 (DNS, HTTP, SSH) Foundation/Intermediate; last 2 (firewalls, troubleshooting) Intermediate
- Module accent color: blue (per Phase 1 CONTEXT decision)
- Final lesson or cheat sheet includes a "What's Next" callout explaining how Docker networking builds on these primitives — bridges to Phase 4

### Claude's Discretion
- Exact Docker Compose service names and network configurations
- Specific broken scenarios for troubleshooting lesson
- ASCII diagram style and detail level per lesson
- Exercise design specifics (what tasks, what verification checks)
- Callout placement and deep-dive content selection
- verify.sh implementation details for network state checks
- Which services to run in each multi-container lab (nginx, bind9, etc.)

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- All Phase 1 content components: CodeBlock, TerminalBlock, ExerciseCard, VerificationChecklist, Callout, QuickReference
- LessonLayout, MDX pipeline, progress tracking, search — all working from Phase 1
- Phase 2 patterns: MDX frontmatter structure, lesson section ordering, verify.sh PASS/FAIL pattern, Docker base image approach
- `lib/modules.ts` — filesystem-based lesson discovery (updated in Phase 2)
- `app/api/search-index/route.ts` — MDX corpus indexing (updated in Phase 2)

### Established Patterns
- MDX frontmatter: title, description, module, moduleSlug, lessonSlug, order, difficulty, estimatedMinutes, prerequisites, tags
- Lesson section ordering: Overview → How It Works → Hands-On Exercise → Verification → Quick Reference
- Docker labs: setup scripts prepare environment, verify scripts check state with PASS/FAIL
- Content directory: content/modules/{moduleSlug}/ with numbered MDX files

### Integration Points
- New MDX files drop into content/modules/02-networking-foundations/ and are auto-discovered
- Module index at content/modules/index.ts needs networking module metadata
- Docker Compose files go into docker/networking/ directory
- Sidebar auto-populates, search index rebuilds automatically

</code_context>

<specifics>
## Specific Ideas

- Multi-container is the key differentiator from Phase 2's single-container labs — networking requires interaction between services
- Deliberately broken scenarios teach real debugging skills — this is how ops engineers actually learn
- Forward bridge to Phase 4 (Docker) helps learner see how these networking primitives underpin container networking
- Same mechanism-first teaching pattern: understand the protocol before using the tool

</specifics>

<deferred>
## Deferred Ideas

- Animated packet flow diagrams (INT-03, v2)
- Interactive network topology visualizer
- Wireshark integration (too complex for v1 labs)

</deferred>

---

*Phase: 03-networking-foundations*
*Context gathered: 2026-03-19*
