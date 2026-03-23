---
phase: 03-networking-foundations
plan: "03"
subsystem: docker-labs
tags: [docker, compose, networking, labs, verify-scripts]
dependency_graph:
  requires: ["03-01", "03-02"]
  provides: ["docker/networking/ lab infrastructure for all networking lessons"]
  affects: ["content/modules/02-networking/*.mdx exercise steps"]
tech_stack:
  added:
    - ubuntu:22.04 networking base image (docker/networking/Dockerfile)
    - coredns/coredns:latest (DNS lab)
    - nginx:alpine (HTTP, firewall, troubleshooting labs)
    - custom ubuntu+openssh-server sshd image (SSH lab)
  patterns:
    - Docker Compose multi-container labs with custom bridge networks
    - Volume-mounted verify.sh scripts (not baked into image)
    - NET_ADMIN capability for iptables/ufw
    - NET_ADMIN+NET_RAW for tcpdump
    - CoreDNS hosts plugin for learn.local zone
key_files:
  created:
    - docker/networking/Dockerfile
    - docker/networking/02-tcp-ip/compose.yml
    - docker/networking/02-tcp-ip/setup.sh
    - docker/networking/02-tcp-ip/verify.sh
    - docker/networking/03-dns/compose.yml
    - docker/networking/03-dns/Corefile
    - docker/networking/03-dns/setup.sh
    - docker/networking/03-dns/verify.sh
    - docker/networking/04-http/compose.yml
    - docker/networking/04-http/nginx.conf
    - docker/networking/04-http/setup.sh
    - docker/networking/04-http/verify.sh
    - docker/networking/05-ssh/Dockerfile.sshd
    - docker/networking/05-ssh/compose.yml
    - docker/networking/05-ssh/setup.sh
    - docker/networking/05-ssh/verify.sh
    - docker/networking/06-firewalls/compose.yml
    - docker/networking/06-firewalls/setup.sh
    - docker/networking/06-firewalls/verify.sh
    - docker/networking/07-troubleshooting/compose.yml
    - docker/networking/07-troubleshooting/setup.sh
    - docker/networking/07-troubleshooting/verify.sh
  modified: []
decisions:
  - "CoreDNS hosts plugin used instead of zone file for learn.local: simpler syntax with no external zone file; forward PTR lookups served from same hosts block"
  - "HTTP lab is HTTP-only (no TLS): nginx self-signed cert setup adds complexity; lesson teaches TLS concepts via curl flags and openssl s_client without requiring nginx TLS config"
  - "Troubleshooting fault: app on port 8080 not 80: most discoverable with nc/curl/ss; learner goes through the full layer-by-layer diagnostic workflow"
  - "verify.sh scripts use service hostnames not IPs: avoids Pitfall 7 (dynamic IP assignment); Compose DNS resolves service names reliably"
  - "Troubleshooting verify.sh checks three conditions: diagnosis.txt written, app:8080 works, app:80 fails — confirms learner both documented and confirmed the fault"
metrics:
  duration: 4min
  completed: 2026-03-19
  tasks_completed: 2
  files_created: 22
---

# Phase 03 Plan 03: Docker Networking Lab Infrastructure Summary

**One-liner:** Docker Compose multi-container labs for all six networking lessons — base ubuntu image with full network toolset, CoreDNS DNS lab, nginx HTTP lab, custom sshd SSH lab, NET_ADMIN firewall lab, and deliberately broken port-mismatch troubleshooting lab.

## What Was Built

A complete `docker/networking/` directory tree with one shared Dockerfile and six lab subdirectories, each self-contained with `compose.yml`, `setup.sh`, and `verify.sh`. The base image is built once and used as the `client` service across all labs. Specialized server services use their own images.

### Lab Structure

| Lab | Services | Key Config | Fault |
|-----|----------|------------|-------|
| 02-tcp-ip | server (10.0.0.10), client (10.0.0.20) | Static IPs on /24 subnet | None |
| 03-dns | CoreDNS, client | hosts plugin, learn.local zone, PTR records | None |
| 04-http | nginx:alpine, client | /api and / endpoints | None |
| 05-ssh | custom sshd, client | student user, key-copy exercises | None |
| 06-firewalls | client+NET_ADMIN, nginx target | iptables/ufw exercises | None |
| 07-troubleshooting | client+NET_ADMIN+NET_RAW, app (broken), database | port 8080 not 80 | Intentional |

### verify.sh Pattern

All scripts use the Phase 2 `check()` function pattern with colored PASS/FAIL output and `$((N + 1))` arithmetic (not `((N++))` which exits 1 under `set -e`). Volume-mounted at `/verify/<lesson>.sh` inside the client container.

## Decisions Made

1. **CoreDNS hosts plugin**: The `hosts` plugin is simpler than a zone file for the lab's needs — no separate file to mount, inline A record definitions. PTR reverse lookups work from the same block via the automatic `.in-addr.arpa` zone handling.

2. **HTTP lab is HTTP-only**: The plan noted "choose the simpler approach" for TLS. nginx self-signed cert generation adds Docker entrypoint complexity (openssl not in alpine). The lesson teaches TLS concepts; the exercise focus is HTTP request inspection with curl. A learner can explore TLS with `openssl s_client` against public servers.

3. **Troubleshooting fault — port mismatch (8080)**: Chosen as the most instructive fault. Ping works (Layer 3 OK), `nc -zv app 80` fails, `nc -zv app 8080` succeeds, `curl http://app:8080/` works. This forces the learner through the full layer-by-layer checklist and the answer is unambiguous.

4. **Service hostnames in verify.sh**: All curl/nc/ssh checks use Compose service names (`webserver`, `target`, `sshd-server`) not IPs. Avoids dynamic IP assignment brittleness.

## Deviations from Plan

None — plan executed exactly as written. The HTTP lab chose HTTP-only (explicitly permitted by the plan: "choose the simpler approach that still demonstrates TLS").

## Self-Check: PASSED

All 22 files confirmed on disk. Both task commits verified:
- `5162ec7`: feat(03-03): networking Dockerfile + tcp-ip, dns, http labs
- `842e26a`: feat(03-03): ssh, firewalls, troubleshooting labs
