# Stack Research

**Domain:** Interactive DevOps & Systems Engineering Course (local, file-based)
**Researched:** 2026-03-18
**Confidence:** MEDIUM-HIGH (core tools verified against official sources; some version claims from official releases pages)

---

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Docker Desktop | 4.65.0 | Primary lab environment for containerized exercises | Industry standard (71% developer adoption per StackOverflow 2025); enables Linux-specific content on macOS without a full VM; single install for all container-based labs; supports Docker Compose networking simulations natively |
| Docker Compose | v2 (bundled with Desktop) | Multi-container lab environments (networking, service meshes, multi-tier apps) | Declarative YAML config enables students to spin up complex lab topologies in one command; version 2 CLI is now the default and v1 is deprecated |
| Multipass | 1.16.1 | Lightweight Ubuntu VMs for OS-level content (kernel, init systems, package management) | Canonical-maintained; uses Apple Hypervisor Framework on macOS for near-native performance; single command to launch named Ubuntu instances; essential when containers are insufficient (e.g., systemd, full kernel module labs) |
| Material for MkDocs | 9.7.5 | Static site generator for course content delivery | Best-in-class documentation theme; supports code annotations, search-in-code, tabbed content, admonitions, and offline browsing — all features a course site needs; all Insiders features are now free (as of 9.7.0); pure Markdown input |
| bats-core | 1.13.0 | Shell script exercise verification | TAP-compliant Bash testing framework; lets exercises have machine-checkable pass/fail criteria; students run `bats verify.bats` and see exactly which checks pass; integrates with CI if course is ever automated |
| ShellCheck | 0.11.0 | Static analysis for course shell scripts and student scripts | Catches common Bash mistakes before runtime; used both as a linting gate on course scripts and as a teachable tool in the shell scripting module |
| just | 1.47.1 | Task runner for lab lifecycle commands | Modern Makefile replacement without tab/PHONY ceremony; `just up`, `just reset`, `just verify` become the consistent interface for every lab; cross-platform (macOS and Linux); self-documenting via `just --list` |
| OpenTofu | 1.11.0 | Infrastructure as Code labs (Terraform module) | Open-source, MPL 2.0 fork of Terraform under Linux Foundation governance; drop-in HCL compatibility with Terraform; preferred over HashiCorp Terraform for a course because no license ambiguity for learners; v1.11 introduces state encryption |

### Supporting Libraries / Tools

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| bats-assert | latest (compatible with bats 1.x) | Assertion helpers for bats test files | Use in every `verify.bats` file — provides readable `assert_output`, `assert_success`, `refute_output` helpers instead of raw bash comparisons |
| bats-support | latest (compatible with bats 1.x) | Formatting helpers for bats failure output | Required dependency of bats-assert; include in every lab that uses bats-assert |
| mkdocs-minify-plugin | latest | Minify HTML/CSS/JS output for MkDocs site | Use when publishing the course site; skip during local development |
| mkdocs-git-revision-date-localized | latest | Show last-updated dates on lesson pages | Adds "last updated" metadata to lessons automatically from git history |
| Ansible | latest stable (2.x via pip) | Configuration management module labs | Use only for the configuration management module; install via pip in a dedicated virtual environment; target Docker containers or Multipass VMs as inventory |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| VS Code | Primary authoring environment | Install the `ShellCheck` extension (timonwong.shellcheck) and `markdownlint` extension (davidanson.vscode-markdownlint) for inline feedback while writing lessons and scripts |
| Homebrew | macOS package manager for toolchain installation | Install Docker Desktop, Multipass, just, ShellCheck, bats-core, and OpenTofu all via `brew`; keeps versions consistent and upgradeable |
| git | Version control and course structure backbone | Course repo IS the course; each module is a directory; `git log` teaches students about real repo history as they work through it |
| Python 3.11+ (via pyenv or system) | Required runtime for MkDocs / Material | Use pyenv if system Python is outdated; pin version in `.python-version` file; MkDocs + Material install via pip into a virtualenv |

---

## Installation

```bash
# macOS toolchain via Homebrew
brew install just shellcheck bats-core opentofu
brew install --cask docker multipass

# MkDocs site (Python virtual environment)
python3 -m venv .venv
source .venv/bin/activate
pip install mkdocs-material==9.7.5 mkdocs-minify-plugin mkdocs-git-revision-date-localized

# bats helper libraries (install as git submodules in test/libs/)
git submodule add https://github.com/bats-core/bats-support test/libs/bats-support
git submodule add https://github.com/bats-core/bats-assert  test/libs/bats-assert

# Ansible (isolated per-module, not global)
pip install ansible  # inside module-specific venv or just for the config-management module
```

---

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Docker Desktop | Podman Desktop | If the learner is on Linux and prefers a fully rootless daemon; not preferred here because Docker Compose v2 integration is simpler and Docker is what students will encounter in 90% of job contexts |
| Multipass | Lima | Lima v2.0 is excellent and lower-level; choose Lima if you need GPU acceleration, MCP integration, or want non-Ubuntu distros; Multipass wins on simplicity and Canonical-backed Ubuntu focus for this course |
| Multipass | Vagrant + VirtualBox | Vagrant provides richer provisioning scripts but VirtualBox is slower, requires a separate download, and is falling behind on Apple Silicon support; Multipass is the better choice for macOS learners in 2026 |
| Material for MkDocs | Docusaurus | Use Docusaurus if you need React components, i18n, or versioned docs; this course is pure-Markdown and single-user, MkDocs is lighter and requires no Node.js toolchain |
| Material for MkDocs | Zensical (next-gen) | Zensical is the MkDocs-Material team's next-generation tool; it is still early-stage as of March 2026; revisit in 6-12 months |
| OpenTofu | HashiCorp Terraform | Use Terraform if learner will work in an enterprise that has standardized on Terraform; for a course, OpenTofu avoids license confusion and is CLI-compatible |
| bats-core | pytest + pexpect | Python-based test approach is viable but adds a language context switch; bats keeps everything in Bash which is coherent with the shell scripting curriculum |
| just | GNU Make | Make is fine and ubiquitous, but tab-sensitivity causes student confusion; just is cleaner for a learning context and explicitly not a build system |

---

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Killercoda / Katacoda / browser-based labs | These external platforms go down, change pricing, and remove course control; Katacoda was shut down in 2023; course portability is lost | Local Docker + Multipass labs that run entirely offline |
| Vagrant + VirtualBox | VirtualBox has poor Apple Silicon (M-series) support as of 2026; Vagrant itself hasn't seen significant active development; startup times are slow compared to Multipass | Multipass for VM needs |
| Docker Compose v1 (`docker-compose`) | Deprecated; `docker-compose` (Python, v1) EOL'd in 2023; `docker compose` (Go, v2) is the maintained tool | `docker compose` (v2, bundled with Docker Desktop) |
| Ansible Galaxy roles as lab targets | Galaxy role quality is inconsistent and network-dependent; labs become fragile when upstream roles change | Write minimal custom playbooks directly in the lessons; keep labs self-contained |
| Jupyter Notebooks for shell content | Notebooks are the wrong abstraction for terminal-centric DevOps skills; shell muscle memory requires a real terminal | Plain Markdown lesson files + shell scripts run in a real terminal |
| HashiCorp Vault / Boundary for early modules | Adds auth complexity before foundational skills are established; learner gets frustrated before they learn anything | Introduce secrets management in later modules after Linux and Docker fundamentals are solid |

---

## Stack Patterns by Variant

**If a module requires a full Linux system (init, systemd, kernel):**
- Use Multipass to launch a named Ubuntu 24.04 LTS instance
- Provision with a `cloud-init` YAML file committed to the repo
- Tear down with `multipass delete --purge <name>` after the lab

**If a module requires networked services (HTTP, DNS, load balancing):**
- Use Docker Compose with user-defined bridge networks
- Name services to use Docker's internal DNS (service names resolve automatically)
- Use `just up` / `just down` wrappers defined in the module's `justfile`

**If a module requires verifiable exercise outcomes:**
- Write a `verify.bats` file in the lab directory
- Load bats-support and bats-assert as submodule paths
- Document the verification command in the lesson's "Check Your Work" section

**If the learner wants to publish the course as a website:**
- Build with `mkdocs build` (output to `site/`)
- Deploy to GitHub Pages via `mkdocs gh-deploy`
- No additional tooling needed

---

## Version Compatibility

| Package | Compatible With | Notes |
|---------|-----------------|-------|
| mkdocs-material 9.7.5 | Python 3.8+ (recommend 3.11+) | Requires MkDocs >= 1.6; all Insiders features included in open version |
| bats-core 1.13.0 | bash 3.2+ | Compatible with macOS default bash (/bin/bash is bash 3.2 on macOS — acceptable); also works with bash 5.x in Docker containers |
| bats-assert (latest) | bats-core 1.x, bats-support (required) | Always install bats-support when using bats-assert; they share output formatting internals |
| OpenTofu 1.11.0 | HCL configs written for Terraform <= 1.5 | Not compatible with Terraform >= 1.6 configs that use BUSL-licensed modules; no issue for course-authored HCL |
| just 1.47.1 | macOS (Homebrew), Linux, Windows | Shell recipes default to `sh`; set `set shell := ["bash", "-c"]` in justfile for Bash-specific syntax |
| Docker Compose v2 | Docker Desktop 4.x | v2 is bundled; do not install the standalone `docker-compose` binary separately — it will conflict |

---

## Sources

- Docker Desktop release notes (verified) — https://docs.docker.com/desktop/release-notes/ — Docker Desktop 4.65.0 confirmed March 16, 2026 — HIGH confidence
- bats-core GitHub releases (verified) — https://github.com/bats-core/bats-core — v1.13.0 released November 7, 2025 — HIGH confidence
- ShellCheck GitHub releases (verified) — https://github.com/koalaman/shellcheck — v0.11.0 released August 4, 2025 — HIGH confidence
- just GitHub releases (verified) — https://github.com/casey/just — v1.47.1 released March 16, 2026 — HIGH confidence
- mkdocs-material PyPI (verified) — https://pypi.org/project/mkdocs-material/ — 9.7.5 released March 10, 2026 — HIGH confidence
- Material for MkDocs Insiders announcement (verified) — https://squidfunk.github.io/mkdocs-material/blog/2025/11/11/insiders-now-free-for-everyone/ — All Insiders features free in 9.7.0+ — HIGH confidence
- OpenTofu official site (verified) — https://opentofu.org/ — v1.11.0 current stable — HIGH confidence
- Multipass GitHub releases (verified) — https://github.com/canonical/multipass — v1.16.1 latest stable — HIGH confidence
- Lima CNCF blog (verified) — https://www.cncf.io/blog/2025/12/11/lima-v2-0-new-features-for-secure-ai-workflows/ — Lima v2.0 released November 2025 — MEDIUM confidence
- HashiCorp Vagrant vs Docker comparison — https://developer.hashicorp.com/vagrant/intro/vs/docker — VirtualBox macOS ARM limitations — MEDIUM confidence (WebSearch, not directly verified against release page)
- Katacoda shutdown (training data + community knowledge) — Katacoda shut down in 2023 per Red Hat announcement — MEDIUM confidence

---

*Stack research for: Interactive DevOps & Systems Engineering Course (local, file-based)*
*Researched: 2026-03-18*
