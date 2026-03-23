# Phase 3: Networking Foundations - Research

**Researched:** 2026-03-19
**Domain:** MDX lesson content authoring, Docker Compose multi-container lab environments, network verification scripting
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Lesson Content & Depth**
- Deep mechanism explanations covering packet structure, TCP three-way handshake internals, windowing, congestion control, DNS resolution chain — same depth standard as Phase 2
- ASCII diagrams in CodeBlock for packet headers, TCP handshake flows, DNS resolution sequences, HTTP request/response cycles
- Every lesson opens with a "Why This Matters" real-world scenario (e.g., "Your API is timing out — here's how TCP retransmission explains why") — per CONT-08
- Each lesson targets 15-25 min reading time — same standard as Phase 2

**Multi-Container Lab Design**
- Docker Compose for networking labs — multiple containers needed to demonstrate real network interactions (client/server, DNS resolver, firewall host)
- Custom bridge networks per lab — learner sees isolated subnets, container DNS, and inter-container communication
- Troubleshooting lesson (NET-07) includes a deliberately broken Compose stack where learner must diagnose the fault
- Same `verify.sh` pattern as Phase 2 — scripts check network state (port open, DNS resolves, firewall rule active) and print PASS/FAIL

**Content Organization**
- Linear lesson ordering per REQUIREMENTS: physical/switches → TCP/IP stack → DNS → HTTP/HTTPS → SSH → firewalls → troubleshooting
- Difficulty progression: first 2 (physical, TCP/IP) Foundation; middle 3 (DNS, HTTP, SSH) Foundation/Intermediate; last 2 (firewalls, troubleshooting) Intermediate
- Module accent color: blue (networking accentColor = 'networking' per index.ts, CSS var --color-module-networking)
- Final lesson or cheat sheet includes a "What's Next" callout explaining how Docker networking builds on these primitives — bridges to Phase 4

### Claude's Discretion
- Exact Docker Compose service names and network configurations
- Specific broken scenarios for troubleshooting lesson
- ASCII diagram style and detail level per lesson
- Exercise design specifics (what tasks, what verification checks)
- Callout placement and deep-dive content selection
- verify.sh implementation details for network state checks
- Which services to run in each multi-container lab (nginx, bind9, etc.)

### Deferred Ideas (OUT OF SCOPE)
- Animated packet flow diagrams (INT-03, v2)
- Interactive network topology visualizer
- Wireshark integration (too complex for v1 labs)
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| NET-01 | Lesson on how networks work — physical layer, switches, routers, packets | ASCII packet diagrams in CodeBlock; Docker bridge network demonstrates switching/routing at container level |
| NET-02 | Lesson on the TCP/IP stack — layers, encapsulation, IP addressing, subnets | ASCII diagram of encapsulation layers; multi-container compose lab for IP/subnet inspection (ip addr, ip route) |
| NET-03 | Lesson on DNS — resolution process, record types, caching, troubleshooting with dig/nslookup | Docker Compose lab with custom bridge network demonstrates container DNS; dig/nslookup commands; bind9 or dnsmasq as DNS service |
| NET-04 | Lesson on HTTP/HTTPS — request/response cycle, methods, headers, TLS handshake | nginx container as server; curl from client container; openssl s_client for TLS inspection |
| NET-05 | Lesson on SSH — key-based auth, tunneling, config files, agent forwarding | Two-container lab (client + sshd server); ssh-keygen, authorized_keys, ProxyJump pattern |
| NET-06 | Lesson on firewalls — iptables, ufw, security groups concepts, netfilter | Container with NET_ADMIN capability for iptables; ufw available in Ubuntu 22.04; verify.sh checks nc/curl blocked/allowed |
| NET-07 | Lesson on network troubleshooting — ping, traceroute, tcpdump, netstat/ss, curl | Deliberately broken Compose stack; verify.sh asks learner to diagnose; tools: ping, traceroute, ss, tcpdump, curl |
| NET-08 | Hands-on exercises for each networking lesson with multi-container lab environments | Docker Compose files per lab; docker compose up/down pattern; verify.sh checks network state |
| NET-09 | Module cheat sheet with networking commands and concepts | QuickReference component per lesson topic; follows LNX-11 pattern as regular lesson MDX file |
</phase_requirements>

---

## Summary

Phase 3 is a content-authoring and Docker Compose infrastructure phase. The Next.js platform is fully operational. The critical new element compared to Phase 2 is that networking labs require multiple containers interacting over custom bridge networks — a `docker run` single-container approach cannot demonstrate DNS resolution, HTTP client/server exchange, or firewall rules meaningfully. Each lab uses `docker compose up` to bring up a named network with 2-3 services.

**Critical slug finding:** The module registry in `content/modules/index.ts` defines the networking module slug as `'02-networking'` (not `'02-networking-foundations'`). All MDX files must use `moduleSlug: "02-networking"` in frontmatter, and all lesson content must live in `content/modules/02-networking/`. This is the canonical slug — the filesystem scan in `getLessonsForModule()` uses this slug to find content. Any mismatch results in lessons returning empty arrays silently.

Docker Compose v2 (v2.31.0) is available on host. The `docker compose` subcommand (no hyphen) is the current syntax. Each networking lab is a directory under `docker/networking/` containing a `compose.yml` and per-lab `setup.sh` and `verify.sh`. Labs run with `docker compose -f docker/networking/03-dns/compose.yml up -d` and the learner runs verify from inside a container via `docker compose exec client bash /verify/03-dns.sh`.

**Primary recommendation:** Write MDX lessons first (NET-01 through NET-07) as the critical path, then build Compose labs for each, wire the module index update as a discrete task, and deliver the cheat sheet last. Follow Phase 2 patterns exactly — no platform changes required.

---

## Standard Stack

### Core — No new npm dependencies needed

Phase 3 adds zero new npm packages. All tools were installed in Phase 1.

| Tool | Version | Purpose | Notes |
|------|---------|---------|-------|
| `@next/mdx` | 16.2.0 | Compiles MDX at build time | Already configured in `next.config.ts` |
| `gray-matter` | 4.0.3 | Frontmatter parsing | Used in `lib/mdx.ts` — no changes needed |
| `rehype-pretty-code` | 0.14.3 | Syntax highlighting | Configured with `one-dark-pro` theme |
| `remark-gfm` | 4.0.1 | Tables, task lists in MDX | Already in MDX pipeline |
| Docker | 27.4.0 (host) | Lab container runtime | Confirmed via `docker --version` |
| Docker Compose | v2.31.0 (host) | Multi-container lab orchestration | Confirmed via `docker compose version` |

### Supporting — Docker images for networking labs

| Image | Tag | Purpose | Why This Choice |
|-------|-----|---------|----------------|
| `ubuntu` | `22.04` | Base for learn-systems-networking | Same as Phase 2; has apt/bash/iproute2/nettools available; familiar to learners |
| `nginx` | `alpine` | HTTP/HTTPS server for NET-04 lab | Lightweight, official, starts in <1s; Alpine fine here since it's a service not a learner shell |
| `coredns/coredns` | `latest` | DNS server for NET-03 lab | Lightweight Go binary, simple Corefile config, widely used in Kubernetes — directly relevant to Phase 4+ |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `coredns/coredns` | `internetsystemsconsortium/bind9` | bind9 is more realistic but ~50MB image vs ~15MB; CoreDNS config is simpler for teaching resolution chain |
| `nginx:alpine` | `python3 -m http.server` inside ubuntu | python approach is simpler but can't demonstrate TLS without additional setup; nginx handles HTTPS with self-signed cert more naturally |
| Custom sshd container | `linuxserver/openssh-server` | linuxserver image is pre-configured but teaches nothing; custom sshd build forces learner to see what SSH requires |
| `iptables` inside ubuntu container | `nftables` | iptables more familiar, more content online, directly maps to AWS security group mental model; nftables is modern but unfamiliar |

**Installation:** No npm install needed. Docker images are pulled automatically on first `docker compose up`.

---

## Architecture Patterns

### Recommended Project Structure additions

```
content/
└── modules/
    └── 02-networking/
        ├── 01-how-networks-work.mdx
        ├── 02-tcp-ip-stack.mdx
        ├── 03-dns.mdx
        ├── 04-http-https.mdx
        ├── 05-ssh.mdx
        ├── 06-firewalls.mdx
        ├── 07-troubleshooting.mdx
        └── 08-cheat-sheet.mdx

docker/
└── networking/
    ├── 02-tcp-ip/
    │   ├── compose.yml
    │   ├── setup.sh
    │   └── verify.sh
    ├── 03-dns/
    │   ├── compose.yml
    │   ├── Corefile          (CoreDNS config)
    │   ├── setup.sh
    │   └── verify.sh
    ├── 04-http/
    │   ├── compose.yml
    │   ├── nginx.conf
    │   ├── setup.sh
    │   └── verify.sh
    ├── 05-ssh/
    │   ├── compose.yml
    │   ├── Dockerfile.sshd   (custom sshd image)
    │   ├── setup.sh
    │   └── verify.sh
    ├── 06-firewalls/
    │   ├── compose.yml
    │   ├── setup.sh
    │   └── verify.sh
    └── 07-troubleshooting/
        ├── compose.yml       (deliberately broken)
        ├── setup.sh
        └── verify.sh
```

Notes:
- NET-01 (physical/switches) is concept-heavy with minimal hands-on; uses a single container for IP/ARP inspection — no Compose needed, uses `docker run` like Phase 2
- `08-cheat-sheet.mdx` uses order: 8, difficulty: "Foundation", estimatedMinutes: 5 — same pattern as LNX-11

### Pattern 1: MDX Lesson Frontmatter for Networking Module

The `moduleSlug` MUST be `"02-networking"` to match the registry slug in `content/modules/index.ts`. This is the canonical value — a mismatch causes lessons to not appear in the sidebar (silently returns empty lessons array).

```mdx
---
title: "DNS: The Internet's Phone Book"
description: "How domain names resolve to IP addresses — resolution chain, record types, caching, and debugging with dig"
module: "Networking Foundations"
moduleSlug: "02-networking"
lessonSlug: "03-dns"
order: 3
difficulty: "Foundation"
estimatedMinutes: 22
prerequisites: ["02-networking/02-tcp-ip-stack"]
tags: ["dns", "dig", "nslookup", "records", "resolution"]
---
```

Required frontmatter fields are validated by `extractFrontmatter()` in `lib/mdx.ts` — missing any field throws at build time. Field names and casing must match exactly.

### Pattern 2: Docker Compose Lab Architecture

Each lab is a self-contained directory. The learner runs `docker compose up -d` to start the environment, does the exercise inside a container, then runs verify.sh.

**Standard compose.yml structure:**

```yaml
# docker/networking/03-dns/compose.yml
services:
  dns:
    image: coredns/coredns:latest
    volumes:
      - ./Corefile:/Corefile:ro
    networks:
      lab-net:
        ipv4_address: 10.0.0.2
    command: -conf /Corefile

  client:
    image: ubuntu:22.04
    depends_on: [dns]
    dns: ["10.0.0.2"]
    volumes:
      - ./verify.sh:/verify/03-dns.sh:ro
    networks:
      - lab-net
    command: sleep infinity
    cap_add: []  # No special caps needed for DNS lesson

networks:
  lab-net:
    driver: bridge
    ipam:
      config:
        - subnet: 10.0.0.0/24
```

**Learner launch commands shown in each lesson via TerminalBlock:**

```
# Start the lab
docker compose -f docker/networking/03-dns/compose.yml up -d

# Open a shell in the client container
docker compose -f docker/networking/03-dns/compose.yml exec client bash

# Run verification (from inside the client container)
bash /verify/03-dns.sh

# Tear down when done
docker compose -f docker/networking/03-dns/compose.yml down
```

### Pattern 3: Network verify.sh — Checking Network State

Network verification differs from Phase 2 filesystem checks. Tools used: `curl` (HTTP), `nc` (port open/closed), `dig` (DNS), `ss` (socket state), `ssh` (connection test).

```bash
#!/usr/bin/env bash
# docker/networking/04-http/verify.sh
set -euo pipefail

PASS=0
FAIL=0

check() {
  local desc="$1"
  local result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Verifying: HTTP/HTTPS Exercise ==="
echo ""

# Check 1: HTTP server responds on port 80
if curl -s -o /dev/null -w "%{http_code}" http://webserver/ | grep -q "200"; then
  check "HTTP server responds with 200 OK" "pass"
else
  check "HTTP server not responding — is nginx running? (docker compose ps)" "fail"
fi

# Check 2: HTTPS responds on port 443 (self-signed cert — skip verify)
if curl -sk -o /dev/null -w "%{http_code}" https://webserver/ | grep -q "200"; then
  check "HTTPS server responds with 200 OK (TLS working)" "pass"
else
  check "HTTPS not responding — check nginx SSL config" "fail"
fi

# Check 3: Learner inspected response headers (captured to file)
if [ -f /tmp/exercise/headers.txt ] && grep -qi "content-type" /tmp/exercise/headers.txt; then
  check "HTTP response headers captured to /tmp/exercise/headers.txt" "pass"
else
  check "Run: curl -I http://webserver/ > /tmp/exercise/headers.txt" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
```

**Key tools to install in networking containers:**

```dockerfile
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    # DNS tools
    dnsutils \          # dig, nslookup, host
    # HTTP tools
    curl wget \
    # Network inspection
    iproute2 \          # ip addr, ip route, ss
    iputils-ping \      # ping
    traceroute \
    # Port checking
    netcat-openbsd \    # nc — NOTE: use netcat-openbsd not netcat-traditional
    # Packet capture
    tcpdump \
    # SSH client
    openssh-client \
    # Firewall tools
    iptables \
    ufw \
    # General
    vim nano less \
    && rm -rf /var/lib/apt/lists/*
```

### Pattern 4: Firewall Lab — NET_ADMIN Capability

iptables and ufw require the `NET_ADMIN` Linux capability. The Compose service for the firewall lab must grant it explicitly:

```yaml
# docker/networking/06-firewalls/compose.yml
services:
  firewall-host:
    image: learn-systems-networking
    cap_add:
      - NET_ADMIN
    networks:
      - lab-net
    command: sleep infinity

  target:
    image: nginx:alpine
    networks:
      - lab-net
```

Without `cap_add: [NET_ADMIN]`, `iptables -A INPUT -j DROP` fails with "Permission denied". This is the most common pitfall for the firewall lab.

### Pattern 5: Deliberately Broken Troubleshooting Lab (NET-07)

The troubleshooting lab compose.yml has intentional faults. The learner's task is to diagnose them using ping, traceroute, ss, tcpdump, curl. Example faults to choose from (Claude's discretion):

- Service listening on wrong port (app configured for 8080, requests go to 80)
- DNS misconfiguration (custom_dns points to wrong IP, names don't resolve)
- Firewall rule blocking traffic (iptables DROP on correct port)
- Missing network connection between services (different compose networks, no shared network)
- Service not started (depends_on not satisfied, container exits immediately)

The verify.sh for this lesson has a different pattern — it does NOT check "exercise is complete" but instead checks "diagnosis is written":

```bash
# Verify the learner diagnosed the fault
if [ -f /tmp/diagnosis.txt ] && [ -s /tmp/diagnosis.txt ]; then
  check "Diagnosis written to /tmp/diagnosis.txt" "pass"
else
  check "Write your diagnosis: echo 'The fault is...' > /tmp/diagnosis.txt" "fail"
fi
```

### Pattern 6: Networking Lesson Prerequisite Chain

```
NET-01: prerequisites: ["01-linux-fundamentals/06-shell-fundamentals"]
NET-02: prerequisites: ["02-networking/01-how-networks-work"]
NET-03: prerequisites: ["02-networking/02-tcp-ip-stack"]
NET-04: prerequisites: ["02-networking/02-tcp-ip-stack"]
NET-05: prerequisites: ["02-networking/03-dns", "02-networking/04-http-https"]
NET-06: prerequisites: ["02-networking/02-tcp-ip-stack"]
NET-07: prerequisites: ["02-networking/03-dns", "02-networking/04-http-https", "02-networking/05-ssh", "02-networking/06-firewalls"]
NET-08: (no lesson — embedded in NET-01 through NET-07)
NET-09: prerequisites: ["02-networking/07-troubleshooting"]
```

NET-01 depends on shell fundamentals — learner needs to run commands and understand `docker run`. NET-05 (SSH) needs both DNS (for hostname resolution in SSH config) and HTTP (for understanding what SSH tunneling can proxy).

### Anti-Patterns to Avoid

- **Wrong moduleSlug in frontmatter:** Using `"02-networking-foundations"` instead of `"02-networking"`. The CONTEXT.md mentions `02-networking-foundations` as a directory path concept, but `content/modules/index.ts` defines the slug as `02-networking`. The filesystem scanner uses the slug from the registry. A wrong slug means lessons exist but never appear.
- **Using `docker-compose` (v1 syntax):** Docker Compose v2 uses `docker compose` (subcommand, no hyphen). The v1 CLI is not installed on the host. TerminalBlock examples must use `docker compose up -d`, not `docker-compose up -d`.
- **iptables without NET_ADMIN:** Any container running iptables/ufw must have `cap_add: [NET_ADMIN]`. Without it, firewall commands fail silently or with a misleading permission error.
- **`netcat-traditional` vs `netcat-openbsd`:** Ubuntu 22.04 has both in apt. `netcat-traditional` uses `nc -e` (insecure, may not be available). `netcat-openbsd` is the safe standard. Always specify `netcat-openbsd` in apt-get.
- **Hardcoded container IPs in verify.sh:** Docker Compose assigns IPs dynamically within the defined subnet. Use container hostnames (Compose service names) not IPs in verify.sh: `curl http://webserver/` not `curl http://10.0.0.3/`. Container DNS in the compose network resolves service names automatically.
- **`set -e` arithmetic with `((PASS++))` in verify.sh:** Use `PASS=$((PASS + 1))` not `((PASS++))` — inherited from Phase 2 research. `((PASS++))` exits 1 when PASS is 0, killing the script under `set -e`.
- **Order 0 for real lessons:** The 00-template.mdx uses order 0. Real lessons start at order 1. The filesystem scanner excludes `00-` prefixed files.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| DNS server for lab | Custom bind9 Dockerfile | `coredns/coredns:latest` image | CoreDNS has a simple Corefile config, is ~15MB, starts instantly |
| HTTP server for lab | Python http.server or custom Dockerfile | `nginx:alpine` image | nginx handles HTTP+HTTPS, official image, <5MB |
| Port reachability check | Custom TCP connect script | `nc -zv <host> <port>` (netcat-openbsd) | Single command, exit code is reliable for verify.sh |
| TLS certificate inspection | Parsing openssl output with awk | `curl -sk` for HTTPS check + `openssl s_client` for display | curl exit codes are reliable; openssl s_client shows TLS details readably |
| SSH server for lab | Installing sshd in ubuntu container | Custom minimal Dockerfile FROM ubuntu + `openssh-server` | Single apt install, shows learner exactly what SSH requires — nothing opaque |
| Firewall verification | Parsing iptables -L output | `nc -zv target port` or `curl` — test the effect, not the rule | Network behavior verification is more reliable than parsing iptables text output |

**Key insight:** For networking labs, test the observable network behavior (can I connect? does DNS resolve? is the port blocked?) rather than inspecting configuration. A verify.sh that checks `curl http://server/` is more robust than one parsing iptables chain listings.

---

## Common Pitfalls

### Pitfall 1: Module Slug Mismatch

**What goes wrong:** Lessons don't appear in the sidebar; `getAllLessonPaths()` returns 0 networking paths; the module page shows "0 lessons".

**Why it happens:** `content/modules/index.ts` registers the module as `slug: '02-networking'`. The filesystem scanner in `getLessonsForModule()` builds the path as `content/modules/02-networking/`. If MDX files are placed in `content/modules/02-networking-foundations/`, no files are found — but no error is thrown.

**How to avoid:** Always verify the slug by reading `content/modules/index.ts` before creating any content directory. MDX content path: `content/modules/02-networking/`. frontmatter `moduleSlug`: `"02-networking"`.

**Warning signs:** Sidebar shows "Networking Foundations" module with "0 lessons" despite MDX files existing.

### Pitfall 2: Docker Compose Service DNS Resolution

**What goes wrong:** `dig example.com` inside the client container fails, or `curl http://webserver/` gets "Could not resolve host".

**Why it happens:** Container hostname resolution within a Compose network works automatically for service names, BUT custom DNS configuration (`dns:` key in compose.yml) overrides the default resolver. If the custom DNS container isn't healthy yet, all name resolution fails.

**How to avoid:** Use `depends_on` with a healthcheck for DNS-dependent services. For the DNS lab specifically, configure a healthcheck on the dns service:
```yaml
dns:
  image: coredns/coredns:latest
  healthcheck:
    test: ["CMD", "dig", "@127.0.0.1", "test.lab"]
    interval: 5s
    timeout: 3s
    retries: 3
```

**Warning signs:** `docker compose exec client dig example.com` returns `connection refused` or `SERVFAIL` immediately after `up`.

### Pitfall 3: NET_ADMIN Not Granted for Firewall Lab

**What goes wrong:** `iptables -A INPUT -p tcp --dport 80 -j DROP` returns `iptables: Permission denied (you must be root)` or `nftables: Permission denied`.

**Why it happens:** Containers run without `NET_ADMIN` capability by default. Even running as root inside the container is not sufficient — Linux capabilities are independent of uid=0.

**How to avoid:** Add `cap_add: [NET_ADMIN]` to the firewall-host service in compose.yml. If running with Docker Desktop, this works without any host-level changes.

**Warning signs:** iptables error message mentions "Permission denied" or "Operation not permitted" despite being root inside the container.

### Pitfall 4: tcpdump Permission Denied

**What goes wrong:** `tcpdump -i eth0` returns `eth0: You don't have permission to capture on that device`.

**Why it happens:** tcpdump requires `NET_RAW` capability (or root + NET_RAW). Docker strips this by default.

**How to avoid:** For the troubleshooting lab where `tcpdump` is a tool, add both capabilities:
```yaml
cap_add:
  - NET_ADMIN
  - NET_RAW
```

**Warning signs:** `tcpdump: eth0: You don't have permission to capture on that device`.

### Pitfall 5: SSH Lab — Host Key Verification Failure

**What goes wrong:** `ssh student@sshd-server` fails with "Host key verification failed" on repeated container restarts because the sshd server regenerates host keys each time.

**Why it happens:** When a Compose service is torn down and recreated, the container is fresh — new host keys are generated at sshd startup. But the client container's `~/.ssh/known_hosts` (if written from a previous run) remembers the old key.

**How to avoid:** In the SSH lab, always start with a fresh client shell (`docker compose down` then `up`) so known_hosts is empty. Alternatively, use `ssh -o StrictHostKeyChecking=no` only for the first connection, then explain why production never does this. Lab setup.sh should clear known_hosts.

**Warning signs:** "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!" message blocking SSH connection.

### Pitfall 6: tcpdump Output Overwhelming Learner

**What goes wrong:** Running `tcpdump -i eth0` without filters produces hundreds of lines per second and the learner can't follow what's happening.

**Why it happens:** A busy container network generates constant traffic. Without filters, tcpdump shows everything.

**How to avoid:** Lesson content must teach filtered tcpdump usage:
```bash
# Filter for just HTTP traffic
tcpdump -i eth0 port 80 -A

# Filter by host
tcpdump -i eth0 host webserver -A -n

# Capture just 5 packets then stop
tcpdump -i eth0 port 80 -A -c 5
```
Exercises must specify exact tcpdump flags — don't let the learner run bare `tcpdump`.

**Warning signs:** Learner shell floods with output and Ctrl-C doesn't respond quickly.

### Pitfall 7: verify.sh Hostname vs IP

**What goes wrong:** `verify.sh` checks `curl http://10.0.0.3/` but the container was assigned a different IP in this run.

**Why it happens:** Docker Compose assigns IPs from the subnet, but the assignment order can vary. Static IPs require explicit `ipv4_address` configuration in the compose service definition AND in the `ipam` block.

**How to avoid:** Always use service names as hostnames in verify.sh: `curl http://webserver/` not `curl http://10.0.0.3/`. Compose's embedded DNS resolves service names reliably. Reserve static IPs only when the lesson specifically teaches IP addressing (e.g., the TCP/IP lab where learners need to see specific IPs).

**Warning signs:** verify.sh FAIL on a curl check despite the service appearing to be running.

---

## Code Examples

All examples are derived from the established Phase 2 codebase patterns.

### ASCII Packet Diagram in CodeBlock

```mdx
```
Ethernet Frame
┌──────────────┬──────────────┬──────┬─────────────────────┬─────┐
│ Dst MAC (6B) │ Src MAC (6B) │ Type │ IP Packet (payload) │ FCS │
│ ff:ff:ff:ff  │ aa:bb:cc:dd  │ 0800 │ ...                 │     │
└──────────────┴──────────────┴──────┴─────────────────────┴─────┘

IP Packet (inside Ethernet payload)
┌────────┬───────┬──────────┬─────────────┬─────────────┬─────────────────┐
│Ver│IHL │  ToS  │ Total Len│ Flags/Frag  │  TTL │Proto │   Src IP        │
│ 4 │ 5  │  00   │  0044    │   4000      │ 40   │  06  │ 192.168.1.100   │
└────────┴───────┴──────────┴─────────────┴─────────────┴─────────────────┘
```
```

Surround with triple backticks (no language tag) for monospace rendering in CodeBlock.

### TerminalBlock for Docker Compose Lab Launch

```mdx
<TerminalBlock
  title="Launch the DNS lab"
  lines={[
    { type: 'comment', content: 'Start all containers in the background' },
    { type: 'command', content: 'docker compose -f docker/networking/03-dns/compose.yml up -d' },
    { type: 'output', content: '[+] Running 2/2' },
    { type: 'output', content: ' ✔ Container dns-lab-dns-1     Started' },
    { type: 'output', content: ' ✔ Container dns-lab-client-1  Started' },
    { type: 'comment', content: 'Open a shell in the client container' },
    { type: 'command', content: 'docker compose -f docker/networking/03-dns/compose.yml exec client bash' },
    { type: 'output', content: 'root@a1b2c3d4e5f6:/# ' },
  ]}
/>
```

### TerminalBlock for Network Verification Output

```mdx
<TerminalBlock
  title="Run verification"
  lines={[
    { type: 'command', content: 'bash /verify/03-dns.sh' },
    { type: 'output', content: '=== Verifying: DNS Resolution Exercise ===' },
    { type: 'output', content: '' },
    { type: 'output', content: '  PASS: dig resolves app.learn.local to 10.0.0.10' },
    { type: 'output', content: '  PASS: dig resolves db.learn.local to 10.0.0.11' },
    { type: 'output', content: '  PASS: DNS query captures saved to /tmp/exercise/dns-trace.txt' },
    { type: 'output', content: '' },
    { type: 'output', content: 'RESULT: PASS — All 3 checks passed.' },
  ]}
/>
```

### Compose Teardown in TerminalBlock

```mdx
<TerminalBlock
  title="Tear down the lab"
  lines={[
    { type: 'comment', content: 'Exit the container shell first (Ctrl-D or exit)' },
    { type: 'command', content: 'exit' },
    { type: 'command', content: 'docker compose -f docker/networking/03-dns/compose.yml down' },
    { type: 'output', content: '[+] Running 3/3' },
    { type: 'output', content: ' ✔ Container dns-lab-client-1  Removed' },
    { type: 'output', content: ' ✔ Container dns-lab-dns-1     Removed' },
    { type: 'output', content: ' ✔ Network dns-lab_lab-net     Removed' },
  ]}
/>
```

### Callout for Phase 4 Bridge (in cheat sheet or final lesson)

```mdx
<Callout type="tip" title="What's Next: Docker Networking">
Everything you just learned — bridge networks, container DNS, IP routing, port
mapping — is exactly what Docker networking builds on. When you run
`docker network create mynet`, you're creating a Linux bridge interface.
When containers resolve each other by service name, that's the same DNS
mechanism you explored here. Phase 4 will feel familiar.
</Callout>
```

### verify.sh for DNS Check

```bash
#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

check() {
  local desc="$1"
  local result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Verifying: DNS Resolution Exercise ==="
echo ""

# Check 1: Can dig resolve a name on the custom DNS server
if dig +short app.learn.local @dns | grep -q "10\\.0\\.0\\."; then
  check "dig resolves app.learn.local to expected IP" "pass"
else
  check "dig could not resolve app.learn.local — check CoreDNS is running" "fail"
fi

# Check 2: Reverse lookup works
if dig +short -x 10.0.0.10 @dns | grep -q "app.learn.local"; then
  check "Reverse DNS lookup returns app.learn.local" "pass"
else
  check "Reverse lookup failed — PTR record may be missing from Corefile" "fail"
fi

# Check 3: Learner saved a dig trace
if [ -f /tmp/exercise/dns-trace.txt ] && [ -s /tmp/exercise/dns-trace.txt ]; then
  check "DNS trace saved to /tmp/exercise/dns-trace.txt" "pass"
else
  check "Run: dig +trace app.learn.local > /tmp/exercise/dns-trace.txt" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
```

---

## State of the Art

| Old Approach | Current Approach | Relevant To |
|--------------|------------------|-------------|
| `docker-compose` v1 CLI | `docker compose` v2 subcommand (no hyphen) | All TerminalBlock examples — must use `docker compose` |
| Single-container `docker run` labs | Multi-container `docker compose` labs | NET-02 through NET-07 all require Compose |
| `netcat-traditional` (nc -e) | `netcat-openbsd` (safer, available in Ubuntu 22.04) | verify.sh port checks: `apt-get install netcat-openbsd` |
| Manual iptables rules | ufw as a frontend (wraps iptables/nftables) | NET-06 teaches both iptables concepts AND ufw practical usage |

**Key constraint carried forward from Phase 1:**
- Build scripts must keep `--webpack` flag: `"dev": "next dev --webpack"` — already in package.json. rehype-pretty-code is incompatible with Turbopack.

---

## Open Questions

1. **Networking module content directory name: `02-networking` vs `02-networking-foundations`**
   - What we know: `content/modules/index.ts` defines the slug as `'02-networking'`. The filesystem scanner uses this slug as the directory name. CONTEXT.md mentions `02-networking-foundations` as the directory path.
   - What's unclear: Was `02-networking-foundations` a planning error in CONTEXT.md, or was the module registry slug intended to be `02-networking-foundations` and hasn't been updated?
   - Recommendation: Use `'02-networking'` as defined in the live code registry. This is the canonical source of truth. The CONTEXT.md reference to `02-networking-foundations` appears to be a planning-phase naming inconsistency. Content goes in `content/modules/02-networking/`.

2. **Single Networking Dockerfile vs per-lab Compose builds**
   - What we know: Phase 2 used one shared base image (`learn-systems-linux`) with per-lesson setup scripts. Networking labs are multi-container and vary in tooling needs.
   - What's unclear: Should there be a single `learn-systems-networking` image used as the `client` container across all labs, or should each lab define its own client image?
   - Recommendation: Build one `learn-systems-networking` base image (dockerfile at `docker/networking/Dockerfile`) with all networking tools installed (dnsutils, curl, iproute2, iputils-ping, traceroute, netcat-openbsd, tcpdump, openssh-client, iptables, ufw). Use it as the `client` service across all Compose labs. Specialized server services (nginx, CoreDNS, custom sshd) use their own images as needed.

3. **verify.sh delivery mechanism for Compose labs**
   - What we know: Phase 2 baked verify.sh into the Docker image. For Compose labs, verify.sh needs to be accessible inside the `client` container.
   - What's unclear: Bake all verify scripts into the base image (like Phase 2) or mount them as volumes at compose-up time?
   - Recommendation: Use volume mounts in compose.yml (`./verify.sh:/verify/03-dns.sh:ro`). This is simpler — each lab's verify.sh is co-located with its compose.yml. The learner command is the same: `bash /verify/03-dns.sh` from inside the container. Volume mount also means verify.sh can be updated without rebuilding the image.

---

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.0 |
| Config file | `vitest.config.ts` (project root) |
| Quick run command | `npm test` |
| Full suite command | `npm run build && npm test` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| NET-01 through NET-07 | MDX files render without build errors | smoke | `npm run build` | ❌ Wave 0: MDX files don't exist yet |
| NET-08 | Docker Compose labs exist and verify.sh scripts are valid bash | manual | `bash -n docker/networking/*/verify.sh` | ❌ Wave 0 |
| NET-09 | Cheat sheet MDX renders all QuickReference sections | smoke | `npm run build` | ❌ Wave 0 |
| Integration | `getAllLessonPaths()` returns 7+ networking paths | unit | `npm test` | ✅ `lib/__tests__/modules.test.ts` exists (but test currently accepts empty array — needs update for Phase 3) |
| Integration | Search index includes networking lesson content | unit | `npm test` | ✅ `lib/__tests__/search.test.ts` exists |
| Integration | `moduleSlug: "02-networking"` in frontmatter matches registry | unit | `npm test` (modules test) | ✅ Indirectly covered — modules test validates lessons array |

Note: The existing `getAllLessonPaths` test in `lib/__tests__/modules.test.ts` currently reads: `'returns an array (empty in Phase 1)'`. This description is stale once Phase 3 content is added. The test logic `expect(Array.isArray(getAllLessonPaths())).toBe(true)` still passes, but a stronger assertion should be added in Phase 3: `expect(paths.some(p => p.moduleSlug === '02-networking')).toBe(true)`.

### Sampling Rate

- **Per task commit:** `npm test` (unit tests, < 5s)
- **Per wave merge:** `npm run build` (verifies MDX compilation, frontmatter validation, static params)
- **Phase gate:** Full suite green + manual review of all 7 lessons + docker compose up test for each lab before `/gsd:verify-work`

### Wave 0 Gaps

- [ ] `content/modules/02-networking/` directory — does not exist yet; must be created before any MDX files
- [ ] `docker/networking/` directory — does not exist yet; must be created before Compose labs
- [ ] Update `lib/__tests__/modules.test.ts` — add assertion for networking lessons once MDX files exist:
  ```typescript
  it('networking module has 7 lessons after Phase 3', () => {
    const paths = getAllLessonPaths()
    const netPaths = paths.filter(p => p.moduleSlug === '02-networking')
    expect(netPaths).toHaveLength(7)
  })
  ```
- [ ] Docker verify.sh scripts are tested manually (run inside container) — no automated harness for v1

---

## Sources

### Primary (HIGH confidence)

- Phase 2 codebase — direct inspection of `content/modules/index.ts` (confirmed slug: `'02-networking'`), `lib/modules.ts` (confirmed filesystem scanner logic), `lib/__tests__/modules.test.ts`, `docker/linux/Dockerfile`, `docker/linux/verify/04-permissions.sh`, `docker/linux/setup/03-filesystem.sh`
- `.planning/phases/03-networking-foundations/03-CONTEXT.md` — locked user decisions
- `.planning/REQUIREMENTS.md` — NET-01 through NET-09 definitions
- `docker --version` → 27.4.0; `docker compose version` → v2.31.0-desktop.2 (confirmed on host)
- `vitest.config.ts` — confirmed Vitest 4.1.0 still current config

### Secondary (MEDIUM confidence)

- Docker Compose v2 syntax confirmed: `docker compose` (not `docker-compose`) — v1 CLI deprecated upstream since 2023
- Ubuntu 22.04 package names: `netcat-openbsd`, `dnsutils`, `iputils-ping`, `iproute2`, `tcpdump` — standard Ubuntu package names, confirmed from Ubuntu 22.04 package index

### Tertiary (LOW confidence)

- CoreDNS Corefile configuration syntax — based on training knowledge (CoreDNS 1.x); verify against CoreDNS docs when writing the DNS lab compose.yml and Corefile
- `cap_add: [NET_ADMIN]` for iptables — standard Docker capability; confirmed in concept, verify against Docker Compose v2 spec during plan execution

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — zero new npm packages; Docker tools confirmed on host
- Architecture: HIGH — patterns derived directly from Phase 2 codebase inspection; module slug conflict confirmed by reading index.ts
- Pitfalls: HIGH for slug mismatch and compose syntax (confirmed from code); MEDIUM for CoreDNS-specific healthcheck behavior (training knowledge, needs verification)
- Content topics: HIGH — networking fundamentals (TCP/IP, DNS, HTTP, SSH, firewalls) are stable; tool syntax (dig, curl, iptables) does not change at this timescale

**Research date:** 2026-03-19
**Valid until:** 2026-06-19 (stable domain — networking fundamentals do not change; Docker Compose v2 API stable)
