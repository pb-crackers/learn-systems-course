# Phase 6: Infrastructure as Code & Cloud - Research

**Researched:** 2026-03-19
**Domain:** OpenTofu/Terraform HCL, Docker provider exercises, Cloud Fundamentals conceptual content — both as MDX lessons with local Docker/OpenTofu labs
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**IaC Approach**
- OpenTofu (open-source Terraform fork) as the primary tool — with notes on Terraform compatibility throughout
- Local Docker provider (kreuzwerker/docker) for all exercises — zero cloud cost, instant feedback
- HCL syntax taught with mechanism explanations: state management, plan/apply cycle, drift detection
- Modules lesson covers reusability, composition, and registry patterns

**Cloud Fundamentals Approach**
- Conceptual mapping: each cloud service is explained by mapping to Docker/networking/IaC concepts the learner already knows
- No live cloud accounts required — exercises use Docker equivalents to demonstrate concepts
- Coverage: compute (VMs→containers→serverless), networking (VPCs→Docker networks), storage (object/block/file), IAM (policies→Linux permissions)
- Provider-agnostic where possible, with AWS/GCP/Azure service name mappings

**Content Organization**
- Two separate modules: 06-iac and 07-cloud
- IaC difficulty: IAC-01–02 Foundation, IAC-03–04 Intermediate
- Cloud difficulty: CLD-01–02 Foundation, CLD-03–05 Intermediate
- Module accent colors: IaC = emerald/green; Cloud = sky blue

### Claude's Discretion
- Exact OpenTofu version and Docker provider version
- Specific HCL examples and exercise configurations
- Cloud service mapping tables (which AWS/GCP/Azure services to highlight)
- Exercise design specifics
- How deep to go on Terraform state internals

### Deferred Ideas (OUT OF SCOPE)
- Multi-cloud Terraform modules (v2)
- Cost optimization patterns (v2)
- Advanced state management (remote backends in production)
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| IAC-01 | Lesson on IaC concepts — why declarative infra, state management, drift | OpenTofu state docs: state tracks infra bindings, refresh detects drift; plan/apply cycle from CLI docs; declarative vs imperative contrast using Docker-run analogy |
| IAC-02 | Lesson on Terraform/OpenTofu basics — HCL syntax, providers, resources, variables | Full variable block syntax, resource block syntax, terraform{} required_providers block verified from official opentofu.org docs March 2026 |
| IAC-03 | Lesson on Terraform state — local state, remote backends, state locking | State stored in terraform.tfstate locally by default; remote TACOS pattern documented; `tofu state` command; state locking reference confirmed in docs |
| IAC-04 | Lesson on Terraform modules — reusability, composition, registry | Module block syntax, source argument (local path vs registry), version constraint, child vs root module distinction — all verified from opentofu.org/docs/language/modules |
| IAC-05 | Hands-on exercises with local Docker provider (no cloud cost) | kreuzwerker/docker v3.9.0 stable confirmed; v4.0.0-beta2 exists but breaking changes — use v3.9.0; docker_image + docker_container resources verified from README examples |
| IAC-06 | Module cheat sheet with Terraform/OpenTofu commands and patterns | CLI commands verified: init, validate, plan, apply, destroy, fmt, state; one QuickReference per lesson (4 components) follows established pattern |
| CLD-01 | Lesson on cloud computing concepts — IaaS/PaaS/SaaS, regions, availability zones | Conceptual-only; bridged to Docker (IaaS = VM = bare metal Docker host; PaaS = managed container service; SaaS = fully managed app) |
| CLD-02 | Lesson on compute — VMs, containers, serverless (mapped to prior Docker knowledge) | Bridge: Docker container → cloud container service (ECS/Cloud Run/ACI); VM → EC2/Compute Engine/Azure VM; serverless → Lambda/Cloud Functions/Azure Functions |
| CLD-03 | Lesson on cloud networking — VPCs, subnets, load balancers (mapped to prior networking knowledge) | Bridge: Docker bridge network → VPC; Docker network subnet → cloud subnet; Docker -p port mapping → load balancer; Phase 3 networking knowledge is prerequisite |
| CLD-04 | Lesson on cloud storage — object, block, file storage types and use cases | Bridge: Docker volumes → block/file storage; HTTP-accessible bucket → object storage (S3/GCS/Azure Blob); no equivalent in Docker — explains why cloud adds value |
| CLD-05 | Lesson on IAM — policies, roles, least privilege (mapped to prior Linux permissions knowledge) | Bridge: Linux file permissions (chmod/chown) → IAM policies; Linux users/groups → IAM users/roles; sudo → IAM role assumption; Phase 2 LNX-04 is prerequisite |
| CLD-06 | Hands-on exercises with conceptual mapping to local Docker equivalents | Docker Compose file that mirrors cloud architecture (nginx lb + app + "db" volume) with VerificationChecklist mapping each Docker component to its cloud equivalent |
| CLD-07 | Module cheat sheet with cloud concepts and service mappings | QuickReference per lesson topic (5 components for CLD-01–05); three-provider service name mapping tables (AWS/GCP/Azure) |
</phase_requirements>

---

## Summary

Phase 6 is a content-authoring phase with one new toolchain component: OpenTofu must be installed locally for the IaC exercises. No new npm dependencies are required — the Next.js platform, MDX pipeline, and all content components are fully operational from Phases 1–5. The work is writing MDX lessons for two new content modules (`06-iac` and `07-cloud`) plus Docker/HCL exercise infrastructure.

The IaC module requires OpenTofu 1.11.5 (current stable as of February 2026) and the kreuzwerker/docker provider v3.9.0. This is a stable, well-documented stack: learners run `tofu init`, `tofu plan`, `tofu apply` against a local Docker daemon to create real containers — giving immediate, observable feedback without any cloud account. The Docker provider is configured as a required_providers block in `main.tf`; the `tofu apply` creates Docker containers the learner can verify with `docker ps`. OpenTofu state writes to `terraform.tfstate` in the exercise directory — state management lessons are thus observable artifacts, not abstractions.

The Cloud Fundamentals module is entirely conceptual — no new tooling required. Every cloud concept is taught as a mapping from something the learner already knows from Phases 2–5: Docker containers → cloud compute, Docker networks → VPCs, Docker volumes → block storage, Linux permissions → IAM. The exercises use existing Docker Compose infrastructure to build mental models without live cloud accounts. Cloud service name tables cover AWS/GCP/Azure in a provider-agnostic structure.

Both module slugs (`06-iac`, `07-cloud`), CSS variables (`--color-module-iac`, `--color-module-cloud`), and module registry entries in `content/modules/index.ts` are already present in the codebase — no plumbing changes needed. The Vitest modules test already validates both `'iac'` and `'cloud'` in `validColors`.

**Primary recommendation:** Structure as two parallel content streams. Wave 1: IaC MDX lessons (IAC-01–04) + HCL exercise files. Wave 2: IaC Docker provider exercise with tofu plan/apply. Wave 3: Cloud MDX lessons (CLD-01–05) + Docker Compose mapping exercise. Wave 4: Both cheat sheets + Vitest count assertion updates.

---

## Standard Stack

### Core (no new npm dependencies)
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| OpenTofu | 1.11.5 | IaC CLI for HCL plan/apply/state exercises | Open-source Terraform fork; v1.11.5 current stable (released Feb 12, 2026); supports all Terraform HCL syntax; `tofu` CLI replaces `terraform` CLI 1:1 |
| kreuzwerker/docker provider | 3.9.0 | OpenTofu provider that manages Docker resources via HCL | Stable release (Nov 2025); the standard provider for Docker+Terraform/OpenTofu; works with opentofu init; `registry.opentofu.org/kreuzwerker/docker` |

### OpenTofu Installation
```bash
# macOS (Homebrew)
brew update && brew install opentofu
tofu -version   # expect: OpenTofu v1.11.5

# Linux (standalone binary — for Docker-based labs if needed)
# See: https://opentofu.org/docs/intro/install/standalone/
```

**Version note (CRITICAL):** kreuzwerker/docker v4.0.0-beta2 was released February 21, 2026 with breaking changes. Use `version = "3.9.0"` (pinned) in all exercise `required_providers` blocks — do NOT use `~> 3.0` which might resolve to beta.

### Required Providers HCL Block
```hcl
terraform {
  required_providers {
    docker = {
      source  = "registry.opentofu.org/kreuzwerker/docker"
      version = "3.9.0"
    }
  }
}
```

**Note on source:** Use `registry.opentofu.org/kreuzwerker/docker` (not `registry.terraform.io/...`) to avoid GPG key issues present on some kreuzwerker provider versions when using the Terraform registry with OpenTofu.

### Supporting Tools (pre-existing in project)
| Tool | Version | Purpose |
|------|---------|---------|
| Docker Desktop | existing | Required for kreuzwerker/docker provider socket access |
| ubuntu:22.04 | existing | Base image for any Docker containers created via HCL |
| Vitest | 4.1.0 | Module filesystem scan tests — needs count assertions for new modules |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| kreuzwerker/docker v3.9.0 | v4.0.0-beta2 | Beta has breaking changes documented in migration guide — inappropriate for learners; stick with stable v3.9.0 |
| kreuzwerker/docker | null provider or random provider | null/random providers don't produce visible artifacts; docker provider gives learner observable Docker containers after `tofu apply` — critical for learning reinforcement |
| OpenTofu 1.11.5 | Terraform OSS | OpenTofu is locked decision; note Terraform compatibility in lessons for employer context |
| Local state file | Remote backend (S3, GCS) | Remote backends require cloud accounts; local state is correct for learning and enables state file inspection |

---

## Architecture Patterns

### Module Directory Structure

```
content/modules/
├── 06-iac/
│   ├── 01-iac-concepts.mdx         # IAC-01 — Foundation
│   ├── 02-hcl-basics.mdx           # IAC-02 — Foundation
│   ├── 03-terraform-state.mdx      # IAC-03 — Intermediate
│   ├── 04-modules.mdx              # IAC-04 — Intermediate
│   └── 05-cheat-sheet.mdx          # IAC-06
├── 07-cloud/
│   ├── 01-cloud-concepts.mdx       # CLD-01 — Foundation
│   ├── 02-compute.mdx              # CLD-02 — Foundation
│   ├── 03-cloud-networking.mdx     # CLD-03 — Intermediate
│   ├── 04-cloud-storage.mdx        # CLD-04 — Intermediate
│   ├── 05-iam.mdx                  # CLD-05 — Intermediate
│   └── 06-cheat-sheet.mdx          # CLD-07
docker/
├── iac/
│   ├── 01-basics/
│   │   ├── main.tf                 # docker_image + docker_container exercise (IAC-02)
│   │   ├── variables.tf            # input variable declarations
│   │   └── outputs.tf              # output value declarations
│   ├── 02-state/
│   │   ├── main.tf                 # stateful resource + drift exercise (IAC-03)
│   │   └── variables.tf
│   ├── 03-modules/
│   │   ├── main.tf                 # calls child module (IAC-04)
│   │   └── modules/
│   │       └── web-container/
│   │           ├── main.tf         # reusable container module
│   │           ├── variables.tf
│   │           └── outputs.tf
│   └── verify/
│       ├── 01-basics.sh            # verifies tofu apply created containers
│       ├── 02-state.sh             # verifies terraform.tfstate exists and drift detection
│       └── 03-modules.sh           # verifies module-created containers
├── cloud/
│   └── mapping-exercise/
│       ├── compose.yml             # Docker Compose that maps to cloud architecture (CLD-06)
│       └── verify.sh               # verifies compose stack and mapping concepts
```

### Pattern 1: MDX Frontmatter for IaC/Cloud Lessons (established, unchanged)
```mdx
---
title: "Infrastructure as Code: Why Declaring Infra is Better than Scripting It"
description: "State management, drift detection, and the plan/apply cycle — how IaC actually works"
module: "Infrastructure as Code"
moduleSlug: "06-iac"
lessonSlug: "01-iac-concepts"
order: 1
difficulty: "Foundation"
estimatedMinutes: 25
prerequisites: ["05-cicd/01-cicd-concepts"]
tags: ["iac", "terraform", "opentofu", "declarative", "state", "drift"]
---
```

### Pattern 2: Complete IaC Exercise HCL (IAC-05 basics)
```hcl
# docker/iac/01-basics/main.tf
terraform {
  required_providers {
    docker = {
      source  = "registry.opentofu.org/kreuzwerker/docker"
      version = "3.9.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:1.25"
  keep_locally = true
}

resource "docker_container" "web" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.external_port
  }

  labels {
    label = "managed-by"
    value = "opentofu"
  }
}
```

```hcl
# docker/iac/01-basics/variables.tf
variable "container_name" {
  type        = string
  description = "Name for the Docker container"
  default     = "learn-iac-web"
}

variable "external_port" {
  type        = number
  description = "Host port to map container port 80 to"
  default     = 8080
}
```

```hcl
# docker/iac/01-basics/outputs.tf
output "container_id" {
  description = "ID of the created Docker container"
  value       = docker_container.web.id
}

output "container_name" {
  description = "Name of the created Docker container"
  value       = docker_container.web.name
}
```

### Pattern 3: Reusable Module Structure (IAC-04)
```hcl
# docker/iac/03-modules/modules/web-container/main.tf
resource "docker_image" "image" {
  name         = var.image_name
  keep_locally = true
}

resource "docker_container" "container" {
  name  = var.name
  image = docker_image.image.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}
```

```hcl
# docker/iac/03-modules/main.tf — calling the child module
module "frontend" {
  source        = "./modules/web-container"
  name          = "learn-frontend"
  image_name    = "nginx:1.25"
  internal_port = 80
  external_port = 8081
}

module "api" {
  source        = "./modules/web-container"
  name          = "learn-api"
  image_name    = "nginx:1.25"
  internal_port = 80
  external_port = 8082
}
```

### Pattern 4: Cloud Mapping Exercise (CLD-06)
```yaml
# docker/cloud/mapping-exercise/compose.yml
# This Compose stack intentionally mirrors a cloud architecture pattern.
# Each component maps to a cloud service — the lesson teaches the mapping.
services:
  loadbalancer:          # → Cloud: Application Load Balancer (ALB/Cloud LB/Azure LB)
    image: nginx:1.25
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - app1
      - app2

  app1:                  # → Cloud: compute instance (EC2/GCE/Azure VM or ECS task)
    image: nginx:1.25
    expose:
      - "80"

  app2:                  # → Cloud: compute instance (second AZ replica)
    image: nginx:1.25
    expose:
      - "80"

networks:
  default:               # → Cloud: VPC with private subnet
    driver: bridge
```

### Pattern 5: Verify.sh for IaC Exercises
```bash
#!/usr/bin/env bash
set -euo pipefail
PASS=0; FAIL=0
check() {
  local desc="$1" result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"; PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"; FAIL=$((FAIL + 1))
  fi
}

# Check OpenTofu created the container
CONTAINER_RUNNING=$(docker inspect --format '{{.State.Running}}' learn-iac-web 2>/dev/null || echo "false")
check "Container 'learn-iac-web' is running" \
  "$([ "$CONTAINER_RUNNING" = "true" ] && echo pass || echo fail)"

# Check state file exists
check "terraform.tfstate file exists" \
  "$([ -f terraform.tfstate ] && echo pass || echo fail)"

# Check state file is non-empty JSON
check "terraform.tfstate contains resource records" \
  "$(command -v jq >/dev/null && jq '.resources | length > 0' terraform.tfstate | grep -q true && echo pass || echo fail)"

# Check container has the managed-by label
LABEL=$(docker inspect --format '{{index .Config.Labels "managed-by"}}' learn-iac-web 2>/dev/null || echo "")
check "Container has 'managed-by=opentofu' label" \
  "$([ "$LABEL" = "opentofu" ] && echo pass || echo fail)"

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"; exit 1
fi
```

### Anti-Patterns to Avoid

- **Using `registry.terraform.io/kreuzwerker/docker` as source in OpenTofu configs:** On some systems this triggers GPG key verification failures introduced with kreuzwerker provider v3.7.0+. Use `registry.opentofu.org/kreuzwerker/docker` as the source.
- **Using version = "~> 3.0"** (loose constraint): With v4.0.0-beta2 now tagged in the registry, a loose `~> 3.0` constraint should be safe (SemVer major bump won't match), but explicit `version = "3.9.0"` is clearer for learners.
- **Running `tofu apply` without `tofu plan` first:** Defeats the teachable plan/apply workflow. Every exercise must show the plan output before applying.
- **Referencing Docker socket path hardcoded:** Default is `/var/run/docker.sock`. On macOS with Rancher Desktop or Podman Desktop, the socket path differs. Document with a `<Callout type="tip">` noting Docker Desktop users use the default.
- **Teaching cloud services before learner has IaC context:** Cloud module intentionally placed after IaC. CLD prerequisites must include IAC-01/02.
- **Creating a 'cloud' Docker directory with complex infrastructure:** CLD-06 exercise is a single Compose file with inline comments that teach the mapping — not a running cloud simulation. Keep it simple.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| IaC state tracking | Custom JSON state file | OpenTofu `terraform.tfstate` | State format handles resource references, dependencies, provider metadata — hand-rolling always misses edge cases |
| Docker resource management via shell | Custom bash scripts creating containers | kreuzwerker/docker provider | Provider handles resource lifecycle, drift detection, destroy — shell scripts have no "plan" phase |
| Provider schema validation | Custom HCL parser | `tofu validate` | OpenTofu validates HCL against provider schema before any apply |
| Cloud service comparison tables | Text-only prose | MDX table with AWS/GCP/Azure columns | Learner needs scannable reference; all three providers have equivalent services to document |
| Drift detection demo | Scripted simulation | Real `tofu apply` + manual `docker stop` + `tofu plan` | Actual drift is visible in plan output: "container must be replaced" — more convincing than simulation |

**Key insight:** OpenTofu's value proposition IS the tooling. The lesson content should lean into `tofu plan` output as the demonstration medium — learners should run commands and see real output, not read descriptions.

---

## Common Pitfalls

### Pitfall 1: Docker Socket Not Accessible (macOS non-Docker-Desktop)
**What goes wrong:** `tofu plan` fails with `Cannot connect to the Docker daemon at unix:///var/run/docker.sock`
**Why it happens:** Rancher Desktop, Podman Desktop, or OrbStack may expose Docker socket at different paths (e.g., `~/.rd/docker.sock`)
**How to avoid:** Document Docker Desktop as the expected runtime. Add a `<Callout type="tip">` in IAC-02 lesson with the override:
```hcl
provider "docker" {
  host = "unix:///Users/yourusername/.rd/docker.sock"
}
```
**Warning signs:** `tofu init` succeeds but `tofu plan` errors on provider configuration.

### Pitfall 2: kreuzwerker/docker v4 Beta Breaking Changes
**What goes wrong:** Learner runs `tofu init` without a pinned version and gets v4.0.0-beta2, which has a different resource schema
**Why it happens:** OpenTofu registry may surface beta versions if version constraint is too loose
**How to avoid:** Always pin `version = "3.9.0"` in all exercise HCL files. Document this in lessons with explanation of why pinning versions matters (itself an IaC lesson).
**Warning signs:** `tofu init` log mentions `v4.0.0-beta2` installed.

### Pitfall 3: State File Left After Exercises
**What goes wrong:** If learner runs `tofu apply` and then starts a new exercise without `tofu destroy`, the state file references containers that no longer exist, and the next `tofu plan` shows spurious changes or errors
**Why it happens:** State tracks real-world resource bindings — abandoned state files become stale
**How to avoid:** Every exercise must include a cleanup step: `tofu destroy -auto-approve`. Verify scripts should be run BEFORE destroy. Make destroy the last step in every exercise checklist.
**Warning signs:** `tofu plan` output says "Error: Error pinging Docker server" or "container not found".

### Pitfall 4: Vitest Lesson Count Assertion
**What goes wrong:** `lib/__tests__/modules.test.ts` does not currently have assertions for `06-iac` or `07-cloud` module lesson counts. After writing MDX files, the tests still pass (no assertion to fail), but the module count validation is missing.
**Why it happens:** Same pattern as Phase 5 — new modules need explicit count assertions.
**How to avoid:** After writing MDX files, add to `lib/__tests__/modules.test.ts`:
- `'iac module has 5 lessons'` (01–04 lessons + 05 cheat-sheet)
- `'cloud module has 6 lessons'` (01–05 lessons + 06 cheat-sheet)
**Warning signs:** All tests pass but a miscounted MDX file would go undetected.

### Pitfall 5: HCL `terraform{}` Block vs `opentofu{}` Block
**What goes wrong:** Learner confusion about whether to use `terraform {}` or `opentofu {}` block in HCL
**Why it happens:** OpenTofu 1.x supports both for compatibility, but community tutorials mix them
**How to avoid:** Teach `terraform {}` block (the standard that both tools accept). Add a note: "OpenTofu also accepts an `opentofu {}` block, but `terraform {}` works in both tools and is what you'll see in most codebases and job postings."
**Warning signs:** N/A — both work; this is a clarity/consistency issue.

### Pitfall 6: Cloud Lessons Becoming Too Abstract
**What goes wrong:** Cloud Fundamentals lessons become vague marketing-speak ("the cloud gives you scalability and reliability") with no concrete mechanism
**Why it happens:** Without hands-on lab infrastructure, lessons drift toward definitions rather than mechanisms
**How to avoid:** Every cloud concept must include: (1) the Docker/Linux equivalent the learner knows, (2) what problem the cloud service solves that the local equivalent can't, (3) the command or config that represents it in the three major clouds.
**Warning signs:** Lesson has no `<TerminalBlock>` or `<CodeBlock>` components — if a lesson has only prose and callouts, it's too abstract.

---

## Code Examples

Verified patterns from official sources:

### Full Working IaC Exercise (IAC-05)
```hcl
# Complete main.tf — Source: kreuzwerker/docker README + opentofu.org docs
terraform {
  required_providers {
    docker = {
      source  = "registry.opentofu.org/kreuzwerker/docker"
      version = "3.9.0"
    }
  }
}

provider "docker" {}   # Uses DOCKER_HOST env var or /var/run/docker.sock default

resource "docker_image" "nginx" {
  name         = "nginx:1.25"
  keep_locally = true   # Don't delete image on tofu destroy
}

resource "docker_container" "web" {
  name  = "learn-iac-web"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8080
  }
}
```

Workflow:
```bash
cd docker/iac/01-basics
tofu init      # Downloads kreuzwerker/docker provider
tofu fmt       # Formats HCL
tofu validate  # Validates schema
tofu plan      # Shows what will be created
tofu apply     # Creates Docker container
docker ps      # Confirms container running
tofu destroy   # Removes Docker container (cleanup)
```

### State Management Demo (IAC-03)
```bash
# After tofu apply:
cat terraform.tfstate   # Show raw state JSON — "this is what OpenTofu knows about your infra"

# Simulate drift — manually stop the container outside OpenTofu:
docker stop learn-iac-web

# OpenTofu detects the drift on next plan:
tofu plan   # Output: "docker_container.web must be replaced"
```

### Module Call Syntax (IAC-04)
```hcl
# Source: opentofu.org/docs/language/modules/syntax/
module "frontend" {
  source        = "./modules/web-container"
  name          = "learn-frontend"
  image_name    = "nginx:1.25"
  internal_port = 80
  external_port = 8081
}
```

### HCL Variables with Validation (IAC-02)
```hcl
# Source: opentofu.org/docs/language/values/variables/
variable "external_port" {
  type        = number
  description = "Host port for container"
  default     = 8080

  validation {
    condition     = var.external_port >= 1024 && var.external_port <= 65535
    error_message = "Port must be in the range 1024–65535 (non-privileged ports)."
  }
}
```

### Cloud Service Mapping Table (for CLD lessons)
```
| Layer         | Docker/Linux             | AWS              | GCP                  | Azure              |
|---------------|--------------------------|------------------|----------------------|--------------------|
| Compute (VM)  | docker run (container)   | EC2              | Compute Engine       | Azure VMs          |
| Compute (PaaS)| docker compose (service) | ECS/Fargate      | Cloud Run            | Container Apps     |
| Serverless    | (no equivalent)          | Lambda           | Cloud Functions      | Azure Functions    |
| Network       | docker network (bridge)  | VPC              | VPC Network          | Virtual Network    |
| Subnet        | --subnet in network      | Subnet           | Subnet               | Subnet             |
| Load Balancer | nginx (proxy)            | ALB              | Cloud Load Balancing | Azure Load Balancer|
| Object Storage| (no direct equivalent)   | S3               | Cloud Storage        | Azure Blob Storage |
| Block Storage | docker volume            | EBS              | Persistent Disk      | Azure Disk Storage |
| Identity      | Linux user/group         | IAM User/Group   | Cloud IAM            | Azure AD           |
| Permission    | chmod/chown              | IAM Policy       | IAM Role             | RBAC Role          |
| Role Assume   | sudo                     | IAM Role Assume  | Service Account      | Managed Identity   |
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `terraform` CLI (HashiCorp BSL) | `tofu` CLI (OpenTofu, MPL-2.0) | August 2023 license change | OpenTofu is the community-maintained open-source fork; 1:1 CLI compatibility for teaching; note Terraform context for job searches |
| `registry.terraform.io/kreuzwerker/docker` | `registry.opentofu.org/kreuzwerker/docker` | OpenTofu registry launch 2024 | Use opentofu.org registry source to avoid GPG key issues with v3.7.0+ |
| Loose version constraint `~> 3.0` | Pinned `version = "3.9.0"` | v4.0.0-beta2 tag exists (Feb 2026) | Beta versions can be selected by loose constraints depending on registry behavior |
| `terraform {}` block only | `terraform {}` or `opentofu {}` block (both valid) | OpenTofu 1.x | Teach `terraform {}` for job market compatibility; both work |
| HCL2 with Terraform 0.12 type system | HCL2 with OpenTofu 1.x extensions (ephemeral values, enabled meta-argument) | OpenTofu 1.11 (Jan 2026) | Ephemeral values (1.11) useful for secrets; do NOT teach in Phase 6 (complexity cliff) |

**Deprecated/outdated:**
- `terraform.tfvars.json` with sensitive values stored in plaintext: Teach `TF_VAR_*` environment variables or `.tfvars` file that is gitignored.
- HashiCorp Configuration Language (HCL) v1 (Terraform 0.11 and earlier): All modern configs use HCL2; no compatibility concerns for learners starting fresh.
- `hashicorp/docker` provider (archived on GitHub): Community ownership transferred to kreuzwerker. The hashicorp/docker repo now redirects to kreuzwerker/docker.

---

## Open Questions

1. **OpenTofu installation inside Docker container vs host**
   - What we know: Exercise workflow requires `tofu init/plan/apply` — these are host-level commands that talk to Docker daemon
   - What's unclear: Whether to require learner to install OpenTofu on their host, or provide a Docker image that has OpenTofu pre-installed
   - Recommendation: Require host installation (`brew install opentofu` on macOS, standalone binary on Linux). Running OpenTofu inside Docker to manage Docker requires DinD (Docker-in-Docker) which is unnecessary complexity. Host install is simpler and better reflects real-world usage.

2. **kreuzwerker/docker v3.9.0 GPG key situation**
   - What we know: Versions v3.7.0+ use a new GPG key; the old key expired; `registry.terraform.io` was slow to update, causing install failures
   - What's unclear: Whether `registry.opentofu.org` has the same GPG verification flow and whether v3.9.0 installs cleanly in all environments
   - Recommendation: Use `registry.opentofu.org/kreuzwerker/docker` as source (documented workaround). Add a `<Callout type="warning">` in IAC-02 noting the registry source difference and explaining why it matters.

3. **CLD-06 exercise depth — how many Docker services**
   - What we know: The exercise must map Docker Compose concepts to cloud equivalents without being trivial
   - What's unclear: Whether a 2-service (lb + app) or 4-service (lb + 2 app replicas + volume) compose file is better
   - Recommendation: 4-service pattern (loadbalancer + app1 + app2 + persistent-data volume) — maps to: ALB + two AZ instances + EBS/Persistent Disk. Richer mapping with minimal complexity increase.

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.0 |
| Config file | vitest.config.ts |
| Quick run command | `npx vitest run` |
| Full suite command | `npx vitest run --reporter=verbose` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| IAC-01 | MDX frontmatter parses without error | unit | `npx vitest run lib/__tests__/mdx.test.ts` | ✅ |
| IAC-02 | IaC MDX renders (lesson count passes) | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ (needs count assertion) |
| IAC-05 | 06-iac module has 5 lessons in filesystem scan | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ (needs new assertion) |
| IAC-06 | accentColor 'iac' is valid in module registry | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ already validates |
| CLD-01 | Cloud MDX frontmatter parses | unit | `npx vitest run lib/__tests__/mdx.test.ts` | ✅ |
| CLD-06 | 07-cloud module has 6 lessons | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ (needs new assertion) |
| CLD-07 | accentColor 'cloud' is valid in module registry | unit | `npx vitest run lib/__tests__/modules.test.ts` | ✅ already validates |
| IaC labs (IAC-05) | verify.sh returns exit 0 after tofu apply + exercises | manual-only | `bash docker/iac/verify/01-basics.sh` | ❌ Wave 0 |
| Cloud mapping (CLD-06) | verify.sh confirms Compose stack running | manual-only | `bash docker/cloud/mapping-exercise/verify.sh` | ❌ Wave 0 |

**Manual-only justification:** IaC verify scripts require `tofu apply` to have been run on the host (creates real Docker containers); Cloud Compose verify requires running Docker Compose stack. Neither is automatable in Vitest.

### Sampling Rate
- **Per task commit:** `npx vitest run`
- **Per wave merge:** `npx vitest run --reporter=verbose`
- **Phase gate:** Full suite green before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `lib/__tests__/modules.test.ts` — add `'iac module has 5 lessons'` assertion
- [ ] `lib/__tests__/modules.test.ts` — add `'cloud module has 6 lessons'` assertion
- [ ] `docker/iac/verify/01-basics.sh` — verifies tofu apply created containers with correct config
- [ ] `docker/iac/verify/02-state.sh` — verifies terraform.tfstate exists and drift detection exercise
- [ ] `docker/iac/verify/03-modules.sh` — verifies module-created containers (frontend + api)
- [ ] `docker/cloud/mapping-exercise/verify.sh` — verifies Compose stack is running with all services

---

## Sources

### Primary (HIGH confidence)
- [opentofu.org/docs/language/resources/syntax/](https://opentofu.org/docs/language/resources/syntax/) — resource block syntax, meta-arguments
- [opentofu.org/docs/language/values/variables/](https://opentofu.org/docs/language/values/variables/) — variable block syntax, type constraints, validation, tfvars format
- [opentofu.org/docs/language/modules/syntax/](https://opentofu.org/docs/language/modules/syntax/) — module block syntax, source, version, input variables
- [opentofu.org/docs/language/state/](https://opentofu.org/docs/language/state/) — state purpose, local default, remote backends, drift via refresh
- [opentofu.org/docs/cli/commands/](https://opentofu.org/docs/cli/commands/) — init, validate, plan, apply, destroy, fmt, state commands
- [opentofu.org/docs/intro/install/homebrew/](https://opentofu.org/docs/intro/install/homebrew/) — `brew install opentofu` command verified
- [github.com/kreuzwerker/terraform-provider-docker/blob/master/README.md](https://github.com/kreuzwerker/terraform-provider-docker/blob/master/README.md) — docker_image + docker_container HCL examples, required_providers block
- [github.com/kreuzwerker/terraform-provider-docker/releases](https://github.com/kreuzwerker/terraform-provider-docker/releases) — v4.0.0-beta2 (Feb 21, 2026), v3.9.0 (Nov 2025) confirmed
- [github.com/opentofu/opentofu/releases](https://github.com/opentofu/opentofu/releases) — v1.11.5 (Feb 12, 2026) confirmed latest stable
- Project codebase: `content/modules/index.ts` — confirmed `06-iac`/`07-cloud` slugs and accentColors already registered
- Project codebase: `app/globals.css` lines 37–38 — confirmed `--color-module-iac` and `--color-module-cloud` CSS variables exist
- Project codebase: `lib/__tests__/modules.test.ts` — confirmed `validColors` already includes 'iac' and 'cloud'

### Secondary (MEDIUM confidence)
- WebSearch + OpenTofu release notes: v1.11 new features (ephemeral values, enabled meta-argument) — confirmed from opentofu.org/docs/intro/whats-new/
- WebSearch + GitHub: kreuzwerker GPG key issue with v3.7.0+ and workaround using `registry.opentofu.org` — multiple sources agree, not from a single official doc

### Tertiary (LOW confidence, flagged)
- WebSearch: Cloud service equivalency tables (AWS/GCP/Azure) — multiple authoritative sources (official cloud docs) but specific service name accuracy for 2026 should be verified against current cloud docs during MDX authoring

---

## Metadata

**Confidence breakdown:**
- Standard stack (OpenTofu 1.11.5, kreuzwerker/docker 3.9.0): HIGH — directly verified from GitHub releases March 2026
- HCL syntax patterns: HIGH — verified from opentofu.org official docs March 2026
- Architecture (MDX file naming, verify.sh pattern, module registry): HIGH — directly inspected from existing phases 2–5
- kreuzwerker v4 beta / registry source pitfall: MEDIUM — verified from GitHub releases + multiple sources, no single official "here's the fix" doc
- Cloud service name mappings: MEDIUM — conceptually stable, specific service names verified against known docs but cloud providers rename services periodically

**Research date:** 2026-03-19
**Valid until:** 2026-04-19 (kreuzwerker/docker v4 stable could land before then — re-verify `version = "3.9.0"` pinning rationale if planning is delayed)
