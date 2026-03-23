---
phase: 06-infrastructure-as-code-cloud
plan: "01"
subsystem: content
tags: [opentofu, terraform, hcl, iac, docker-provider, state, modules, mdx]

requires:
  - phase: 05-system-administration-ci-cd
    provides: CI/CD concepts lesson that IAC-01 prerequisites via 05-cicd/01-cicd-concepts

provides:
  - 4 IaC MDX lesson files in content/modules/06-iac/ (IAC-01 through IAC-04)
  - IAC-01: declarative vs imperative, state management, drift detection, plan/apply cycle, Terraform vs OpenTofu history
  - IAC-02: HCL terraform/provider/resource/variable/output blocks, kreuzwerker/docker v3.9.0, complete main.tf/variables.tf/outputs.tf example
  - IAC-03: terraform.tfstate structure, drift detection refresh cycle, tofu state subcommands, remote backends (S3/GCS/Azure), state locking
  - IAC-04: root vs child module distinction, module block syntax, variable/output interface, module composition, registry vs local modules

affects: [06-infrastructure-as-code-cloud-02, 06-infrastructure-as-code-cloud-03, 06-infrastructure-as-code-cloud-04]

tech-stack:
  added: []
  patterns:
    - "IaC lessons use mechanism-first: explain state/drift/plan before showing commands"
    - "Each lesson bridges to prior phase: IAC-01 bridges to CI/CD pipeline deploy step"
    - "Pinned provider versions in all HCL examples: version = '3.9.0' not loose constraints"
    - "registry.opentofu.org source for kreuzwerker/docker to avoid GPG key issues"

key-files:
  created:
    - content/modules/06-iac/01-iac-concepts.mdx
    - content/modules/06-iac/02-hcl-basics.mdx
    - content/modules/06-iac/03-terraform-state.mdx
    - content/modules/06-iac/04-modules.mdx
  modified: []

key-decisions:
  - "IAC-01-02 Foundation, IAC-03-04 Intermediate difficulty labels — matches locked decision from CONTEXT.md"
  - "IAC-01 bridges to CI/CD via callout: 'IaC is the deploy piece of CI/CD done correctly'"
  - "terraform{} block taught (not opentofu{}) — works in both tools, what job postings show"
  - "HCL variable validation block included in IAC-02 — port range check shows safety-net pattern"
  - "State file structure shown as actual JSON excerpt in IAC-03 — learner sees real attributes, not abstractions"
  - "Remote backends covered conceptually (S3/GCS/Azure) without requiring cloud accounts"
  - "Module-as-function analogy: variables.tf = function signature, main.tf = implementation, outputs.tf = return value"

patterns-established:
  - "IaC lesson pattern: mechanism explanation with JSON/HCL excerpt -> how it works -> callouts -> ExerciseCard -> QuickReference"
  - "Exercise cleanup step: every exercise ends with tofu destroy to avoid stale state between lessons"

requirements-completed: [IAC-01, IAC-02, IAC-03, IAC-04]

duration: 5min
completed: 2026-03-19
---

# Phase 6 Plan 01: Infrastructure as Code Lessons Summary

**4 IaC MDX lessons — declarative IaC concepts, HCL syntax with kreuzwerker/docker v3.9.0, terraform.tfstate internals, and module composition — using mechanism-first explanations with local Docker provider exercises**

## Performance

- **Duration:** 5 min
- **Started:** 2026-03-19T13:51:50Z
- **Completed:** 2026-03-19T13:57:00Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments

- Wrote all 4 IaC lessons covering the full module curriculum (IAC-01 through IAC-04)
- Every lesson uses mechanism-first pedagogy: explains why state/drift/plan works before showing commands
- IAC-01 explicitly bridges from CI/CD (prior phase) to IaC as "the deploy step done correctly"
- IAC-02 includes complete working HCL (main.tf, variables.tf, outputs.tf) with pinned kreuzwerker/docker v3.9.0 and correct registry source
- IAC-03 shows actual terraform.tfstate JSON structure as a simplified excerpt — learner sees real Docker container ID in state
- IAC-04 uses module-as-function analogy and covers local → registry → git source progression

## Task Commits

1. **Task 1: IaC concepts and HCL basics (IAC-01, IAC-02)** - `145a4ac` (feat)
2. **Task 2: Terraform state and modules (IAC-03, IAC-04)** - `39939bc` (feat)

## Files Created/Modified

- `content/modules/06-iac/01-iac-concepts.mdx` — Declarative vs imperative, state, drift detection, plan/apply cycle, OpenTofu vs Terraform history; prerequisites: 05-cicd/01-cicd-concepts; difficulty: Foundation
- `content/modules/06-iac/02-hcl-basics.mdx` — HCL block types, kreuzwerker/docker provider, complete three-file example, CLI workflow; difficulty: Foundation
- `content/modules/06-iac/03-terraform-state.mdx` — State file JSON structure, drift refresh cycle, tofu state subcommands, remote backends, state locking; difficulty: Intermediate
- `content/modules/06-iac/04-modules.mdx` — Root vs child modules, module block syntax, variable/output interface, composition, registry modules; difficulty: Intermediate

## Decisions Made

- `terraform {}` block taught throughout (not `opentofu {}`): both work in OpenTofu, but `terraform {}` is what every codebase and job posting uses — establishes the right habit
- Variable validation block included in IAC-02: the port range example shows HCL's built-in input validation before any apply runs
- State file shown as actual JSON excerpt with real field names (serial, lineage, instances, attributes): more effective than prose description
- Remote backends explained conceptually with real HCL examples for all three clouds (S3+DynamoDB, GCS, Azure Blob): learner understands WHY without needing a cloud account
- Module-as-function analogy: variables.tf = function signature, main.tf = implementation, outputs.tf = return value — concrete mental model for a concept that can feel abstract

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required. Exercises reference Docker/OpenTofu tools the learner is expected to install locally (documented in IAC-02 exercise).

## Next Phase Readiness

- All 4 IaC lessons complete with consistent frontmatter, difficulty labels, prerequisite chains, and exercise references to docker/iac/ directories
- docker/iac/ exercise directories (01-basics, 02-state, 03-modules) and their HCL files are referenced by lessons but not yet created — will be created in subsequent plans
- Vitest mdx.test.ts passes for all 4 files

---
*Phase: 06-infrastructure-as-code-cloud*
*Completed: 2026-03-19*
