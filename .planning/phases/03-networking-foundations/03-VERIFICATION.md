---
phase: 03-networking-foundations
verified: 2026-03-19T13:30:00Z
status: gaps_found
score: 4/5 must-haves verified
gaps:
  - truth: "Learner can use the network troubleshooting lesson's tools (ping, traceroute, tcpdump, ss) to diagnose a deliberately broken network scenario and identify the fault"
    status: failed
    reason: "Lesson MDX uses service hostname 'app-server' in all 14 exercise commands, but compose.yml defines the service as 'app'. Every exercise instruction in the troubleshooting lesson points to a hostname that does not exist in the lab."
    artifacts:
      - path: "content/modules/02-networking/07-troubleshooting.mdx"
        issue: "Lines 297, 302, 307, 312, 317, 337, 361, 378, 379, 381, 420, 421, 422 use 'app-server' as the target hostname"
      - path: "docker/networking/07-troubleshooting/compose.yml"
        issue: "Service is named 'app', not 'app-server'. Compose DNS resolves 'app' not 'app-server'."
    missing:
      - "Rename compose.yml service from 'app' to 'app-server' to match lesson instructions; OR update all lesson MDX references from 'app-server' to 'app'. The verify.sh already uses 'app' (the correct name per compose.yml), so renaming the compose service is cleaner."
human_verification:
  - test: "Launch each networking lab with docker compose up -d and confirm multi-container environments start cleanly"
    expected: "DNS lab resolves learn.local names, HTTP lab serves nginx responses, SSH lab accepts key-based auth, firewall lab allows iptables commands, troubleshooting lab fails on port 80 but succeeds on port 8080"
    why_human: "Cannot run Docker containers programmatically in this environment"
  - test: "After fixing the app-server/app hostname mismatch, run the troubleshooting lesson exercise from start to finish"
    expected: "ping app-server works, curl http://app-server/ fails, nc confirms port 8080 is open, diagnosis.txt written, verify.sh shows RESULT: PASS"
    why_human: "Requires a running Docker environment to confirm the fix works end-to-end"
---

# Phase 3: Networking Foundations Verification Report

**Phase Goal:** Learners can complete all Networking Foundations lessons with multi-container lab environments and understand how Docker networking (covered next) builds on these primitives
**Verified:** 2026-03-19T13:30:00Z
**Status:** gaps_found
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths (from ROADMAP Success Criteria)

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Learner can follow a packet from physical layer through TCP/IP stack and articulate what happens at each layer | VERIFIED | 01-how-networks-work.mdx and 02-tcp-ip-stack.mdx exist with mechanism-first content; TCP handshake ASCII diagram confirmed; ExerciseCard + VerificationChecklist present |
| 2 | Learner can complete DNS, HTTP/HTTPS, and SSH lessons including hands-on exercises using dig, curl, and ssh within Docker Compose lab environments | VERIFIED | 03-dns.mdx, 04-http-https.mdx, 05-ssh.mdx all exist with correct lab paths; compose.yml files exist with proper service configurations; verify.sh scripts syntactically valid |
| 3 | Learner can complete the firewall lesson and write iptables/ufw rules in a lab container that verifiably block or allow expected traffic | VERIFIED | 06-firewalls.mdx exists; compose.yml has NET_ADMIN capability; verify.sh checks iptables rules; check() PASS/FAIL pattern confirmed |
| 4 | Learner can use the network troubleshooting lesson's tools (ping, traceroute, tcpdump, ss) to diagnose a deliberately broken network scenario and identify the fault | FAILED | Lesson MDX uses service hostname 'app-server' in all 14 exercise commands; compose.yml service is named 'app'. Docker DNS will not resolve 'app-server' — every exercise step fails at name resolution before any diagnostic work begins. |
| 5 | Learner can reference the networking cheat sheet for all commands and concepts from the module | VERIFIED | 08-cheat-sheet.mdx exists with 7 QuickReference components (one per lesson), What's Next callout bridging to Docker networking confirmed |

**Score:** 4/5 truths verified

---

## Required Artifacts

### Plan 03-01 Artifacts (NET-01, NET-02, NET-03)

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `content/modules/02-networking/01-how-networks-work.mdx` | Physical layer lesson | VERIFIED | Correct frontmatter (order: 1, moduleSlug: 02-networking, prereqs: linux shell); ExerciseCard, VerificationChecklist, Callout present; ARP callout, Docker bridge tip confirmed |
| `content/modules/02-networking/02-tcp-ip-stack.mdx` | TCP/IP stack lesson | VERIFIED | Correct frontmatter (order: 2, prereqs: 01-how-networks-work); SYN/ACK/handshake content confirmed; 8 interactive components |
| `content/modules/02-networking/03-dns.mdx` | DNS resolution lesson | VERIFIED | Correct frontmatter (order: 3, prereqs: 02-tcp-ip-stack); dig commands, docker compose lab path, resolution content confirmed |

### Plan 03-02 Artifacts (NET-04, NET-05, NET-06, NET-07)

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `content/modules/02-networking/04-http-https.mdx` | HTTP/HTTPS lesson | VERIFIED | Correct frontmatter (order: 4, Foundation, prereqs: 02-tcp-ip-stack); TLS, curl, docker/networking/04-http lab path confirmed |
| `content/modules/02-networking/05-ssh.mdx` | SSH lesson | VERIFIED | Correct frontmatter (order: 5, Intermediate, prereqs: dns+http); ssh-keygen, tunneling, docker/networking/05-ssh lab path confirmed |
| `content/modules/02-networking/06-firewalls.mdx` | Firewalls lesson | VERIFIED | Correct frontmatter (order: 6, Intermediate, prereqs: 02-tcp-ip-stack); iptables, ufw, Netfilter section, docker/networking/06-firewalls lab path confirmed |
| `content/modules/02-networking/07-troubleshooting.mdx` | Troubleshooting lesson | STUB/WIRED | File exists with correct frontmatter and substantive content; exercise commands use wrong service hostname ('app-server' vs compose service 'app') |

### Plan 03-03 Artifacts (NET-08)

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `docker/networking/Dockerfile` | Base networking image | VERIFIED | FROM ubuntu:22.04; all required tools: dnsutils, curl, iproute2, tcpdump, openssh-client, iptables, ufw, netcat-openbsd |
| `docker/networking/03-dns/compose.yml` | DNS lab | VERIFIED | coredns/coredns image, lab-net bridge, client uses @dns server |
| `docker/networking/03-dns/Corefile` | CoreDNS config | VERIFIED | learn.local zone with A records for app/db/web, PTR records |
| `docker/networking/04-http/compose.yml` | HTTP lab | VERIFIED | nginx:alpine, lab-net bridge |
| `docker/networking/06-firewalls/compose.yml` | Firewall lab | VERIFIED | NET_ADMIN capability present, lab-net bridge |
| `docker/networking/07-troubleshooting/compose.yml` | Broken lab | PARTIAL | NET_ADMIN+NET_RAW present, lab-net present, intentional port 8080 fault present; service name is 'app' but lesson expects 'app-server' |
| `docker/networking/05-ssh/Dockerfile.sshd` | SSH server image | VERIFIED | openssh-server installed, student user created |
| All verify.sh scripts | PASS/FAIL feedback | VERIFIED | All 6 verify.sh scripts pass bash -n syntax check; check() pattern with colored output confirmed in all |
| All setup.sh scripts | Lab initialization | VERIFIED | All 6 setup.sh scripts pass bash -n syntax check |

### Plan 03-04 Artifacts (NET-09)

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `content/modules/02-networking/08-cheat-sheet.mdx` | Module cheat sheet | VERIFIED | order: 8, difficulty: Foundation, estimatedMinutes: 5, prerequisites: []; 7 QuickReference components confirmed; What's Next Docker Networking callout present |

---

## Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| All 02-networking/*.mdx | content/modules/index.ts | moduleSlug: "02-networking" | VERIFIED | index.ts has slug: '02-networking' confirmed; all 8 MDX files use this slug |
| 02-tcp-ip-stack.mdx | 01-how-networks-work.mdx | prerequisites array | VERIFIED | prerequisites: ["02-networking/01-how-networks-work"] confirmed |
| 03-dns.mdx | 02-tcp-ip-stack.mdx | prerequisites array | VERIFIED | prerequisites: ["02-networking/02-tcp-ip-stack"] confirmed |
| 04-http-https.mdx | 02-tcp-ip-stack.mdx | prerequisites array | VERIFIED | prerequisites: ["02-networking/02-tcp-ip-stack"] confirmed |
| 07-troubleshooting.mdx | all prior networking lessons | prerequisites array | VERIFIED | prerequisites: ["02-networking/03-dns", "02-networking/04-http-https", "02-networking/05-ssh", "02-networking/06-firewalls"] confirmed |
| docker/networking/*/verify.sh | compose.yml | Volume mount at /verify/ | VERIFIED | All compose.yml files mount verify.sh at /verify/<lesson>.sh |
| docker/networking/*/compose.yml | docker/networking/Dockerfile | build: .. | VERIFIED | Client service in all labs uses build: .. referencing parent Dockerfile |
| 07-troubleshooting.mdx exercise commands | docker/networking/07-troubleshooting/compose.yml service | Hostname 'app-server' | NOT_WIRED | Lesson references 'app-server' 14 times; compose service is named 'app'. Docker DNS resolves 'app', not 'app-server'. |

---

## Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| NET-01 | 03-01 | Lesson on how networks work — physical layer, switches, routers, packets | SATISFIED | 01-how-networks-work.mdx verified with Ethernet frames, switch MAC table, router, ARP |
| NET-02 | 03-01 | Lesson on the TCP/IP stack — layers, encapsulation, IP addressing, subnets | SATISFIED | 02-tcp-ip-stack.mdx verified with 4 layers, encapsulation diagram, TCP handshake, UDP, ports |
| NET-03 | 03-01 | Lesson on DNS — resolution process, record types, caching, dig/nslookup | SATISFIED | 03-dns.mdx verified with resolution chain, record types, TTL, dig commands, CoreDNS lab |
| NET-04 | 03-02 | Lesson on HTTP/HTTPS — request/response cycle, methods, headers, TLS handshake | SATISFIED | 04-http-https.mdx verified with full cycle, status codes, TLS handshake, curl reference |
| NET-05 | 03-02 | Lesson on SSH — key-based auth, tunneling, config files, agent forwarding | SATISFIED | 05-ssh.mdx verified with key auth flow, all tunnel types (-L/-R/-D), config file, ProxyJump |
| NET-06 | 03-02 | Lesson on firewalls — iptables, ufw, security groups concepts, netfilter | SATISFIED | 06-firewalls.mdx verified with netfilter chains, iptables rules, ufw, cloud security group analogy |
| NET-07 | 03-02 | Lesson on network troubleshooting — ping, traceroute, tcpdump, netstat/ss, curl | BLOCKED | Lesson content substantive; exercise hostname mismatch ('app-server' vs 'app') prevents learner from executing any exercise step in the deliberately broken lab |
| NET-08 | 03-03 | Hands-on exercises with multi-container lab environments | PARTIAL | 5 of 6 labs fully functional; troubleshooting lab has intentional fault but lesson/compose hostname mismatch blocks the exercise |
| NET-09 | 03-04 | Module cheat sheet with networking commands and concepts | SATISFIED | 08-cheat-sheet.mdx verified with 7 QuickReference sections and What's Next callout |

---

## Anti-Patterns Found

| File | Lines | Pattern | Severity | Impact |
|------|-------|---------|----------|--------|
| `content/modules/02-networking/07-troubleshooting.mdx` | 297, 302, 307, 312, 317, 337, 378-422 | Wrong service hostname: 'app-server' used throughout exercise, but compose service is 'app' | Blocker | Every exercise instruction fails at DNS resolution; learner cannot begin the diagnostic workflow |

No other anti-patterns found. No TODO/FIXME/placeholder comments in any lesson or lab file. No empty implementations.

---

## Human Verification Required

### 1. Full Lab Smoke Test

**Test:** Run `docker compose -f docker/networking/03-dns/compose.yml up -d`, exec into client, run `dig app.learn.local @dns`, then run `/verify/03-dns.sh`
**Expected:** Forward lookup returns 10.0.0.10, reverse lookup returns app.learn.local, dns-trace.txt check requires learner action, verify.sh shows RESULT: PASS after completing exercises
**Why human:** Cannot run Docker containers programmatically in this environment

### 2. SSH Lab Key-Based Auth Flow

**Test:** Run `docker compose -f docker/networking/05-ssh/compose.yml up -d`, exec into client, run `ssh-keygen`, copy key to sshd-server, test login, then run `/verify/05-ssh.sh`
**Expected:** Password auth works initially, key-based auth works after setup, verify.sh passes all three checks (key pair, passwordless SSH, config file)
**Why human:** Requires interactive SSH key exchange in a running container

### 3. Firewall Lab iptables Exercise

**Test:** After fixing the app-server/app hostname mismatch, run the troubleshooting lab. Run `docker compose -f docker/networking/07-troubleshooting/compose.yml up -d`, exec into client, follow the lesson exercise steps using the corrected service name
**Expected:** `ping app` works (Layer 3 OK), `curl http://app/` fails, `nc -zv app 8080` succeeds, `curl http://app:8080/` works, diagnosis.txt written, verify.sh shows RESULT: PASS
**Why human:** Requires running containers and the fix must be applied first

---

## Gaps Summary

**One gap blocks goal achievement for Success Criterion 4.**

The troubleshooting lab has a service name mismatch between the lesson content and the Docker Compose configuration. The lesson (`07-troubleshooting.mdx`) consistently uses `app-server` as the target hostname across 14 references (ping, curl, nc, tcpdump commands in the exercise), while `docker/networking/07-troubleshooting/compose.yml` defines the service as `app`. Docker Compose DNS resolves services by their Compose service name — `app` works, `app-server` does not exist and will return NXDOMAIN or "Name or service not known."

This means a learner who follows the lesson instructions verbatim cannot begin the diagnostic exercise at all. The very first step (`ping -c 3 app-server`) fails before any learning happens.

The verify.sh correctly uses `app` as the hostname (its curl checks use `http://app:8080/`), so the verify script would pass if the learner already knew the correct hostname — but the lesson's guidance is wrong.

**Fix:** Rename the compose.yml `app` service to `app-server` (no other compose changes needed). This makes the compose.yml consistent with the lesson's 14 references and the teardown output (`07-troubleshooting-app-server-1 Removed`) that already appears in the lesson's TerminalBlock teardown output section.

All 8 other requirements (NET-01 through NET-06, NET-09) are fully satisfied. The networking cheat sheet is complete, the Docker bridge and Linux primitives connection is clearly articulated in both the lesson callouts and the cheat sheet's What's Next section.

---

_Verified: 2026-03-19T13:30:00Z_
_Verifier: Claude (gsd-verifier)_
