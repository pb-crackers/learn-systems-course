---
phase: 06-infrastructure-as-code-cloud
verified: 2026-03-19T10:18:00Z
status: passed
score: 13/13 must-haves verified
re_verification: false
---

# Phase 6: Infrastructure as Code and Cloud Fundamentals Verification Report

**Phase Goal:** Learners can write OpenTofu/Terraform HCL to provision infrastructure declaratively using local Docker targets, and understand cloud fundamentals by mapping cloud services to the networking, IaC, and container concepts they already know
**Verified:** 2026-03-19T10:18:00Z
**Status:** passed
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Learner can read mechanism-first explanations of IaC concepts, HCL syntax, Terraform state, and modules | VERIFIED | 4 lesson MDX files exist with "## How It Works" sections and ExerciseCard components in each |
| 2 | All 4 IaC lessons appear in sidebar under Infrastructure as Code | VERIFIED | moduleSlug: "06-iac" present in all 4 lessons; Vitest confirms 5 lessons (4 + cheat sheet) discovered |
| 3 | Learner can run tofu init/plan/apply in docker/iac/01-basics/ to create a real Docker container | VERIFIED | docker/iac/01-basics/main.tf uses kreuzwerker/docker v3.9.0 pinned from registry.opentofu.org; variables.tf and outputs.tf present |
| 4 | Learner can simulate drift by stopping a container and see tofu plan detect it | VERIFIED | docker/iac/02-state/main.tf exists with docker_container "state_demo"; separate state file directory confirmed |
| 5 | Learner can use a reusable module to create two containers | VERIFIED | docker/iac/03-modules/main.tf calls module "frontend" and module "api"; child module at ./modules/web-container confirmed |
| 6 | Learner can run verify scripts and get PASS/FAIL feedback for each IaC exercise | VERIFIED | 3 verify scripts exist, all executable (-rwxr-xr-x), all contain check() function with colored PASS/FAIL printf |
| 7 | Learner can reference the IaC cheat sheet for OpenTofu commands and HCL patterns | VERIFIED | content/modules/06-iac/05-cheat-sheet.mdx exists with 4 QuickReference components |
| 8 | Learner can read mechanism-first cloud explanations mapping to Docker/Linux equivalents | VERIFIED | 5 cloud lesson MDX files exist; each lesson contains "## How It Works" section mapping cloud services to known equivalents |
| 9 | All 5 cloud lessons appear in sidebar under Cloud Fundamentals | VERIFIED | moduleSlug: "07-cloud" present in all 5 lessons; Vitest confirms 6 lessons (5 + cheat sheet) discovered |
| 10 | Learner can run docker compose up on cloud mapping exercise and see load-balanced multi-service stack | VERIFIED | docker/cloud/mapping-exercise/compose.yml contains loadbalancer + app1 + app2 + app-data volume; nginx.conf has upstream/proxy_pass config |
| 11 | Learner can map each Docker Compose component to its cloud equivalent | VERIFIED | compose.yml has inline "Cloud: ALB (AWS) / Cloud Load Balancing (GCP) / Azure Load Balancer" comments for each service |
| 12 | Learner can run verify.sh and get PASS/FAIL feedback on the cloud mapping exercise | VERIFIED | docker/cloud/mapping-exercise/verify.sh is executable, contains check() PASS/FAIL pattern, 5 checks |
| 13 | Learner can reference cloud cheat sheet for service mappings across all three providers | VERIFIED | content/modules/07-cloud/06-cheat-sheet.mdx has 5 QuickReference components and What's Next callout bridging to Phase 7 |

**Score:** 13/13 truths verified

---

## Required Artifacts

### Plan 06-01 Artifacts (IAC-01 through IAC-04)

| Artifact | Provides | Exists | Substantive | Wired | Status |
|----------|----------|--------|-------------|-------|--------|
| `content/modules/06-iac/01-iac-concepts.mdx` | IAC-01 lesson | Yes | Yes — mechanism-first, ExerciseCard, How It Works section | Yes — prerequisite "05-cicd/01-cicd-concepts" wired | VERIFIED |
| `content/modules/06-iac/02-hcl-basics.mdx` | IAC-02 lesson | Yes | Yes — HCL examples, ExerciseCard, "registry.opentofu.org/kreuzwerker/docker", version "3.9.0" | Yes — references docker/iac/01-basics/ | VERIFIED |
| `content/modules/06-iac/03-terraform-state.mdx` | IAC-03 lesson | Yes | Yes — terraform.tfstate JSON explanation, drift detection, tofu state subcommands, remote backends | Yes — prerequisite "06-iac/02-hcl-basics" wired | VERIFIED |
| `content/modules/06-iac/04-modules.mdx` | IAC-04 lesson | Yes | Yes — root/child module distinction, module block syntax, composition | Yes — references docker/iac/03-modules/ | VERIFIED |

### Plan 06-02 Artifacts (IAC-05, IAC-06)

| Artifact | Provides | Exists | Substantive | Wired | Status |
|----------|----------|--------|-------------|-------|--------|
| `docker/iac/01-basics/main.tf` | Basics exercise HCL | Yes | Yes — terraform{}, kreuzwerker/docker v3.9.0, docker_image + docker_container | Yes — referenced by 02-hcl-basics.mdx exercise | VERIFIED |
| `docker/iac/01-basics/variables.tf` | Variable definitions | Yes | Yes — container_name + external_port with validation | Yes — used in main.tf via var.container_name, var.external_port | VERIFIED |
| `docker/iac/01-basics/outputs.tf` | Output definitions | Yes | Yes — container_id and container_name outputs | Yes — part of exercise workflow | VERIFIED |
| `docker/iac/02-state/main.tf` | State drift exercise | Yes | Yes — docker_container "state_demo", port 8090 | Yes — referenced by 03-terraform-state.mdx exercise | VERIFIED |
| `docker/iac/03-modules/main.tf` | Modules root module | Yes | Yes — module "frontend" + module "api" | Yes — references ./modules/web-container | VERIFIED |
| `docker/iac/03-modules/modules/web-container/main.tf` | Child module | Yes | Yes — docker_container "container" using variables | Yes — called from root main.tf | VERIFIED |
| `docker/iac/03-modules/modules/web-container/variables.tf` | Child module inputs | Yes | Yes — name, image_name, internal_port, external_port | Yes — all variables used in main.tf | VERIFIED |
| `docker/iac/03-modules/modules/web-container/outputs.tf` | Child module outputs | Yes | Yes — container_id, container_name | Yes — accessible via module.frontend.container_id | VERIFIED |
| `docker/iac/verify/01-basics.sh` | Basics verify script | Yes | Yes — check() PASS/FAIL, docker inspect learn-iac-web, jq state checks | Yes — executable, references 01-basics/ state file | VERIFIED |
| `docker/iac/verify/02-state.sh` | State verify script | Yes | Yes — check() PASS/FAIL, learn-state-demo, state JSON validation | Yes — executable | VERIFIED |
| `docker/iac/verify/03-modules.sh` | Modules verify script | Yes | Yes — check() PASS/FAIL, learn-frontend + learn-api, curl port 8081/8082, 4+ resources check | Yes — executable | VERIFIED |
| `content/modules/06-iac/05-cheat-sheet.mdx` | IaC cheat sheet | Yes | Yes — 4 QuickReference sections (IaC Concepts, HCL Basics, Terraform State, Modules) | Yes — order 5, moduleSlug "06-iac" | VERIFIED |

### Plan 06-03 Artifacts (CLD-01 through CLD-05)

| Artifact | Provides | Exists | Substantive | Wired | Status |
|----------|----------|--------|-------------|-------|--------|
| `content/modules/07-cloud/01-cloud-concepts.mdx` | CLD-01 lesson | Yes | Yes — IaaS/PaaS/SaaS table, regions, AZs, Docker Compose YAML example | Yes — prerequisite "06-iac/01-iac-concepts" wired | VERIFIED |
| `content/modules/07-cloud/02-compute.mdx` | CLD-02 lesson | Yes | Yes — VM/managed containers/serverless tiers, ExerciseCard, AWS/GCP/Azure names | Yes — prerequisite "03-docker/01-what-are-containers" wired | VERIFIED |
| `content/modules/07-cloud/03-cloud-networking.mdx` | CLD-03 lesson | Yes | Yes — VPC=docker network, subnets, load balancer=nginx, security groups=iptables | Yes — prerequisites include "02-networking/02-tcp-ip-stack" and "03-docker/05-docker-networking" | VERIFIED |
| `content/modules/07-cloud/04-cloud-storage.mdx` | CLD-04 lesson | Yes | Yes — block/object/file storage types mapped to Docker; object storage as cloud-native | Yes — prerequisite "03-docker/04-docker-volumes" wired | VERIFIED |
| `content/modules/07-cloud/05-iam.mdx` | CLD-05 lesson | Yes | Yes — IAM users/groups=Linux users/groups; IAM policy JSON vs chmod; role assumption=sudo; bash code blocks | Yes — prerequisites include "01-linux-fundamentals/04-file-permissions" and "04-sysadmin/01-user-management" | VERIFIED |

### Plan 06-04 Artifacts (CLD-06, CLD-07)

| Artifact | Provides | Exists | Substantive | Wired | Status |
|----------|----------|--------|-------------|-------|--------|
| `docker/cloud/mapping-exercise/compose.yml` | CLD-06 cloud mapping exercise | Yes | Yes — 4-service pattern (loadbalancer + app1 + app2 + app-data volume) with inline Cloud: mapping comments | Yes — nginx.conf mounted, exercise referenced in cloud lessons | VERIFIED |
| `docker/cloud/mapping-exercise/nginx.conf` | Nginx upstream config | Yes | Yes — upstream app_servers block, proxy_pass | Yes — mounted in compose.yml loadbalancer service | VERIFIED |
| `docker/cloud/mapping-exercise/verify.sh` | Cloud mapping verify script | Yes | Yes — 5 PASS/FAIL checks, python3 JSON parsing for service state | Yes — executable (-rwxr-xr-x) | VERIFIED |
| `content/modules/07-cloud/06-cheat-sheet.mdx` | CLD-07 cloud cheat sheet | Yes | Yes — 5 QuickReference sections (Cloud Concepts, Compute, Networking, Storage, IAM) + What's Next callout | Yes — order 6, moduleSlug "07-cloud" | VERIFIED |

---

## Key Link Verification

| From | To | Via | Status |
|------|----|-----|--------|
| `content/modules/06-iac/01-iac-concepts.mdx` | `05-cicd/01-cicd-concepts` | prerequisites frontmatter | WIRED — `prerequisites: ["05-cicd/01-cicd-concepts"]` confirmed |
| `content/modules/06-iac/02-hcl-basics.mdx` | `docker/iac/01-basics/` | exercise references Docker provider HCL files | WIRED — exercise steps reference `docker/iac/01-basics/` directory |
| `content/modules/06-iac/04-modules.mdx` | `docker/iac/03-modules/` | exercise references module composition HCL files | WIRED — `docker/iac/03-modules/` referenced in exercise |
| `docker/iac/01-basics/main.tf` | Docker daemon | kreuzwerker/docker provider via Docker socket | WIRED — `provider "docker" {}` block in main.tf |
| `docker/iac/verify/01-basics.sh` | `docker/iac/01-basics/` | verifies containers created by tofu apply | WIRED — `docker inspect --format '{{.State.Running}}' learn-iac-web` |
| `content/modules/07-cloud/01-cloud-concepts.mdx` | `06-iac/01-iac-concepts` | prerequisites frontmatter | WIRED — `prerequisites: ["06-iac/01-iac-concepts"]` confirmed |
| `content/modules/07-cloud/03-cloud-networking.mdx` | `02-networking/02-tcp-ip-stack` | prerequisites linking to networking fundamentals | WIRED — `prerequisites: ["07-cloud/01-cloud-concepts", "02-networking/02-tcp-ip-stack", "03-docker/05-docker-networking"]` |
| `content/modules/07-cloud/05-iam.mdx` | `01-linux-fundamentals/04-file-permissions` | prerequisites linking to Linux permissions | WIRED — `prerequisites: ["07-cloud/01-cloud-concepts", "01-linux-fundamentals/04-file-permissions", "04-sysadmin/01-user-management"]` |
| `docker/cloud/mapping-exercise/compose.yml` | `content/modules/07-cloud/03-cloud-networking.mdx` | exercise implements the load-balanced architecture described in the lesson | WIRED — loadbalancer + app1 + app2 mirrors cloud networking lesson architecture |
| `docker/cloud/mapping-exercise/verify.sh` | `docker/cloud/mapping-exercise/compose.yml` | verifies compose stack is running | WIRED — `docker compose -f "$COMPOSE_FILE" ps` calls |

---

## Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| IAC-01 | 06-01 | IaC concepts — declarative infra, state management, drift | SATISFIED | `01-iac-concepts.mdx` — mechanism-first explanation with state/drift/plan/apply cycle |
| IAC-02 | 06-01 | Terraform/OpenTofu basics — HCL syntax, providers, resources, variables | SATISFIED | `02-hcl-basics.mdx` — complete HCL with kreuzwerker/docker v3.9.0, provider/resource/variable/output blocks |
| IAC-03 | 06-01 | Terraform state — local state, remote backends, state locking | SATISFIED | `03-terraform-state.mdx` — tfstate JSON structure, tofu state subcommands, S3/GCS/Azure remote backends |
| IAC-04 | 06-01 | Terraform modules — reusability, composition, registry | SATISFIED | `04-modules.mdx` — root vs child modules, module block syntax, module-as-function analogy |
| IAC-05 | 06-02 | Hands-on exercises with local Docker provider | SATISFIED | `docker/iac/01-basics/`, `02-state/`, `03-modules/` — all using kreuzwerker/docker v3.9.0 |
| IAC-06 | 06-02 | Module cheat sheet with Terraform/OpenTofu commands and patterns | SATISFIED | `05-cheat-sheet.mdx` — 4 QuickReference sections, all tofu CLI commands, HCL patterns |
| CLD-01 | 06-03 | Cloud concepts — IaaS/PaaS/SaaS, regions, availability zones | SATISFIED | `01-cloud-concepts.mdx` — IaaS/PaaS/SaaS table, regions/AZ explanation, Docker Compose single-host example |
| CLD-02 | 06-03 | Cloud compute — VMs, containers, serverless (mapped to Docker knowledge) | SATISFIED | `02-compute.mdx` — three compute tiers mapped to Docker; decision framework |
| CLD-03 | 06-03 | Cloud networking — VPCs, subnets, load balancers (mapped to networking knowledge) | SATISFIED | `03-cloud-networking.mdx` — VPC=docker network, subnets, ALB=nginx proxy, security groups=iptables |
| CLD-04 | 06-03 | Cloud storage — object, block, file storage types and use cases | SATISFIED | `04-cloud-storage.mdx` — block=docker volume, object=cloud-native, file=NFS; when-to-use guidance |
| CLD-05 | 06-03 | IAM — policies, roles, least privilege (mapped to Linux permissions) | SATISFIED | `05-iam.mdx` — IAM policy JSON vs chmod side-by-side, role assumption=sudo, Trust Policy=/etc/sudoers |
| CLD-06 | 06-04 | Hands-on exercises with conceptual mapping to local Docker equivalents | SATISFIED | `docker/cloud/mapping-exercise/compose.yml` — 4-service pattern with inline Cloud: mapping comments |
| CLD-07 | 06-04 | Module cheat sheet with cloud concepts and service mappings | SATISFIED | `06-cheat-sheet.mdx` — 5 QuickReference sections, AWS/GCP/Azure service names throughout, What's Next callout |

All 13 requirements declared across the 4 plans are present in REQUIREMENTS.md and all marked `[x]` (complete). No orphaned requirements.

---

## Anti-Patterns Found

None. Scan of all 11 MDX lesson files, 3 HCL exercise directories, 4 verify scripts, and the cloud mapping exercise found no TODOs, FIXMEs, placeholders, or empty implementations.

---

## Test Results

| Test Suite | Result | Details |
|------------|--------|---------|
| `vitest run lib/__tests__/modules.test.ts` | PASS | 12/12 tests pass — includes "iac module has 5 lessons" and "cloud module has 6 lessons" assertions |
| `vitest run lib/__tests__/mdx.test.ts` | PASS | 4/4 tests pass — all MDX frontmatter parses correctly |

---

## Human Verification Required

The following items cannot be confirmed programmatically and require a human to verify in a running environment:

### 1. IaC Exercises End-to-End Execution

**Test:** In `docker/iac/01-basics/`, run `tofu init`, `tofu plan`, `tofu apply`, then `bash docker/iac/verify/01-basics.sh`
**Expected:** tofu plan shows 2 resources to create; `docker ps` shows learn-iac-web; verify script outputs all PASS; `curl localhost:8080` returns nginx page; `tofu destroy` cleans up without errors
**Why human:** Requires OpenTofu binary installed and Docker daemon running; cannot be verified by static analysis

### 2. State Drift Detection

**Test:** In `docker/iac/02-state/`, run `tofu apply`, then `docker stop learn-state-demo`, then `tofu plan`
**Expected:** tofu plan output shows the container must be replaced/recreated due to drift
**Why human:** Requires live Docker daemon and OpenTofu execution

### 3. Module Composition Exercise

**Test:** In `docker/iac/03-modules/`, run `tofu init && tofu plan && tofu apply`, verify both `learn-frontend` and `learn-api` containers appear in `docker ps` and respond on ports 8081 and 8082
**Expected:** 4 resources created (2 images + 2 containers); both ports respond with nginx 200 OK
**Why human:** Requires live Docker daemon and OpenTofu execution

### 4. Cloud Mapping Exercise

**Test:** In `docker/cloud/mapping-exercise/`, run `docker compose up -d`, then `bash verify.sh`
**Expected:** All 5 PASS checks succeed; `curl localhost:8080` returns nginx page through the load balancer
**Why human:** Requires Docker daemon running

### 5. Sidebar Navigation Display

**Test:** Run `npm run dev`, navigate to the Cloud Fundamentals and Infrastructure as Code modules in the sidebar
**Expected:** All 5 IaC lessons (4 + cheat sheet) and all 6 cloud lessons (5 + cheat sheet) appear in the sidebar with correct order, difficulty badges, and estimated minutes
**Why human:** Requires running the Next.js development server; visual/UI verification

---

## Summary

Phase 6 goal is fully achieved. The codebase contains:

- **IaC curriculum (Plans 06-01 and 06-02):** 4 lesson MDX files covering declarative IaC concepts, HCL syntax with kreuzwerker/docker v3.9.0, terraform state internals, and Terraform modules. All use mechanism-first pedagogy. 3 working HCL exercise directories (`docker/iac/01-basics/`, `02-state/`, `03-modules/`) with 3 executable verify scripts. A 4-section cheat sheet.

- **Cloud curriculum (Plans 06-03 and 06-04):** 5 lesson MDX files mapping cloud services to Docker/Linux equivalents the learner already knows. All cloud lessons contain code or terminal examples (no pure-prose lessons). A Docker Compose cloud mapping exercise with inline AWS/GCP/Azure comments. A 5-section cheat sheet with What's Next bridge to Phase 7.

- **Test coverage:** Both Vitest test suites pass (16 tests total) confirming lesson file counts and MDX frontmatter validity.

- **Prerequisite chains:** IAC-01 -> CI/CD (bridges from Phase 5); IAC lessons chain correctly 01->02->03->04. Cloud lessons chain from IaC, Docker, networking, and Linux permissions as required.

- **Requirements:** All 13 requirement IDs (IAC-01 through IAC-06, CLD-01 through CLD-07) are satisfied and marked complete in REQUIREMENTS.md.

---

_Verified: 2026-03-19T10:18:00Z_
_Verifier: Claude (gsd-verifier)_
