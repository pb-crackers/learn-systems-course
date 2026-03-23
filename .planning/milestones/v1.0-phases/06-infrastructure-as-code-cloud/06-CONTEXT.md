# Phase 6: Infrastructure as Code & Cloud - Context

**Gathered:** 2026-03-19
**Status:** Ready for planning

<domain>
## Phase Boundary

Write all IaC lessons (IAC-01 through IAC-04), build IaC exercises with local Docker provider (IAC-05), create IaC cheat sheet (IAC-06), write all Cloud Fundamentals lessons (CLD-01 through CLD-05), build cloud exercises mapping to Docker equivalents (CLD-06), and create cloud cheat sheet (CLD-07). Two separate content modules.

</domain>

<decisions>
## Implementation Decisions

### IaC Approach
- OpenTofu (open-source Terraform fork) as the primary tool — with notes on Terraform compatibility throughout
- Local Docker provider (kreuzwerker/docker) for all exercises — zero cloud cost, instant feedback
- HCL syntax taught with mechanism explanations: state management, plan/apply cycle, drift detection
- Modules lesson covers reusability, composition, and registry patterns

### Cloud Fundamentals Approach
- Conceptual mapping: each cloud service is explained by mapping to Docker/networking/IaC concepts the learner already knows
- No live cloud accounts required — exercises use Docker equivalents to demonstrate concepts
- Coverage: compute (VMs→containers→serverless), networking (VPCs→Docker networks), storage (object/block/file), IAM (policies→Linux permissions)
- Provider-agnostic where possible, with AWS/GCP/Azure service name mappings

### Content Organization
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

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- All content components, MDX pipeline, progress tracking, search
- Phase 2-5 patterns: lesson structure, verify.sh, Docker labs, Compose labs
- lib/modules.ts filesystem scanning — auto-discovers new modules

### Integration Points
- New MDX files in content/modules/06-iac/ and content/modules/07-cloud/
- Module index needs both entries
- IaC exercises in docker/iac/ directory (OpenTofu + Docker provider)
- Cloud exercises use existing Docker infrastructure (no new Docker setup needed)

</code_context>

<specifics>
## Specific Ideas

- IaC lessons must connect back: "Remember manually creating Docker containers? HCL declares what you want and the tool figures out how"
- Cloud lessons bridge to everything: networking→VPCs, Docker→containers/serverless, Linux permissions→IAM
- OpenTofu exercises should produce visible Docker containers so learner sees immediate results

</specifics>

<deferred>
## Deferred Ideas

- Multi-cloud Terraform modules (v2)
- Cost optimization patterns (v2)
- Advanced state management (remote backends in production)

</deferred>

---

*Phase: 06-infrastructure-as-code-cloud*
*Context gathered: 2026-03-19*
