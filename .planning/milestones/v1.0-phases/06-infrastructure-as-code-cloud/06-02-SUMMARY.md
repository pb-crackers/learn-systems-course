---
phase: 06-infrastructure-as-code-cloud
plan: "02"
subsystem: iac-exercises
tags: [iac, opentofu, hcl, docker-provider, terraform, exercises, verify-scripts, cheat-sheet]
dependency_graph:
  requires: ["06-01"]
  provides: ["docker/iac/01-basics", "docker/iac/02-state", "docker/iac/03-modules", "docker/iac/verify", "content/modules/06-iac/05-cheat-sheet"]
  affects: ["lib/__tests__/modules.test.ts"]
tech_stack:
  added: []
  patterns: ["kreuzwerker/docker v3.9.0 pinned from registry.opentofu.org", "HCL terraform{} required_providers block with pinned version", "check() PASS/FAIL verify.sh pattern", "QuickReference per lesson topic in cheat sheet"]
key_files:
  created:
    - docker/iac/01-basics/main.tf
    - docker/iac/01-basics/variables.tf
    - docker/iac/01-basics/outputs.tf
    - docker/iac/02-state/main.tf
    - docker/iac/02-state/variables.tf
    - docker/iac/03-modules/main.tf
    - docker/iac/03-modules/modules/web-container/main.tf
    - docker/iac/03-modules/modules/web-container/variables.tf
    - docker/iac/03-modules/modules/web-container/outputs.tf
    - docker/iac/verify/01-basics.sh
    - docker/iac/verify/02-state.sh
    - docker/iac/verify/03-modules.sh
    - content/modules/06-iac/05-cheat-sheet.mdx
  modified:
    - lib/__tests__/modules.test.ts
decisions:
  - "kreuzwerker/docker v3.9.0 pinned (not ~> 3.0) because v4.0.0-beta2 exists in registry with breaking changes"
  - "registry.opentofu.org/kreuzwerker/docker source used to avoid GPG key issues with registry.terraform.io"
  - "verify scripts use relative path from script location ($(dirname $0)) to locate state files — works from any cwd"
  - "02-state/variables.tf uses port 8090 (not 8080) to avoid conflict when both 01-basics and 02-state exist simultaneously"
  - "modules.test.ts already had cloud module assertion from Phase 06-03 plan — only iac assertion was missing"
metrics:
  duration: 6min
  completed_date: "2026-03-19"
  tasks_completed: 2
  files_created: 13
  files_modified: 1
---

# Phase 06 Plan 02: IaC Exercise Files and Cheat Sheet Summary

**One-liner:** HCL exercise directories for kreuzwerker/docker v3.9.0 (basics, state, modules) with PASS/FAIL verify scripts and a 4-section IaC cheat sheet covering all lesson topics.

## What Was Built

Three complete OpenTofu exercise directories in `docker/iac/` and the IaC module cheat sheet:

**docker/iac/01-basics/** — Learner runs `tofu init/plan/apply` to create a Docker container from HCL. Uses the kreuzwerker/docker provider v3.9.0 pinned from registry.opentofu.org. Container named `learn-iac-web` on port 8080 with `managed-by=opentofu` label. Variables for container_name and external_port with validation (1024–65535 range). Outputs for container_id and container_name.

**docker/iac/02-state/** — Separate exercise directory for the state drift lesson. Container named `learn-state-demo` on port 8090 (distinct port to avoid collision when both exercises exist simultaneously). Learner runs apply, then `docker stop learn-state-demo` to simulate drift, then `tofu plan` to observe OpenTofu detecting the drift.

**docker/iac/03-modules/** — Root module calling a reusable `./modules/web-container` child module twice — once for `learn-frontend` (port 8081) and once for `learn-api` (port 8082). Demonstrates the module-as-function analogy: variables.tf is the function signature, main.tf is the implementation, outputs.tf is the return value.

**docker/iac/verify/** — Three verify scripts following the established `check()` PASS/FAIL pattern from Phase 2 (linux/verify):
- `01-basics.sh`: 4 checks — container running, state file exists, state has resources (jq), managed-by label
- `02-state.sh`: 4 checks — container running, state file exists, valid JSON with resources, docker_container type
- `03-modules.sh`: 5 checks — frontend/api containers running, port 8081/8082 accessible (curl 200), state has 4+ resources

**content/modules/06-iac/05-cheat-sheet.mdx** — 4 QuickReference sections aligned to the 4 lesson topics:
1. IaC Concepts — declarative vs imperative, plan/apply cycle, state purpose, drift, OpenTofu/Terraform compatibility
2. HCL Basics — terraform{}/provider/resource/variable/output syntax + all tofu CLI commands (init, fmt, validate, plan, apply, destroy)
3. Terraform State — tfstate purpose, tofu state subcommands, remote backends, state locking, .gitignore guidance
4. Modules — module block syntax, root vs child module, local/registry source, inputs/outputs access pattern

**lib/__tests__/modules.test.ts** — Added `iac module has 5 lessons` assertion. All 12 module tests pass.

## Commits

| Task | Commit | Description |
|------|--------|-------------|
| Task 1 | 12604a5 | IaC exercise HCL files and verify scripts (12 files) |
| Task 2 | 23278be | IaC cheat sheet and iac module Vitest assertion (2 files) |

## Deviations from Plan

### Auto-fixed Issues

None — plan executed exactly as written.

### Observations

- `lib/__tests__/modules.test.ts` already had a `cloud module has 6 lessons` assertion added by the Phase 06-03 plan execution (plan ran before this one per the stopped_at in STATE.md). Only the `iac module has 5 lessons` assertion was missing, which was added as specified.
- Port 8090 chosen for 02-state (plan said "default 8090") — confirmed distinct from 01-basics (8080) to avoid port collision when learner has both directories applied simultaneously.

## Verification Results

- `npx vitest run lib/__tests__/modules.test.ts`: 12 tests passed
- `ls content/modules/06-iac/*.mdx | wc -l`: 5 (4 lessons + 1 cheat sheet)
- `ls docker/iac/verify/*.sh | wc -l`: 3
- All verify scripts contain check() function with PASS/FAIL pattern and are executable

## Self-Check: PASSED
