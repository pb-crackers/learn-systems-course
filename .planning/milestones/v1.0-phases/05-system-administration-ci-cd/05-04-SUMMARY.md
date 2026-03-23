---
phase: 05-system-administration-ci-cd
plan: "04"
subsystem: content
tags: [cicd, cheat-sheet, github-actions, pipeline, vitest, mdx]
dependency_graph:
  requires: [05-03]
  provides: [CICD-05, CICD-06]
  affects: [lib/__tests__/modules.test.ts]
tech_stack:
  added: []
  patterns: [QuickReference, ExerciseCard, VerificationChecklist, Callout, CodeBlock]
key_files:
  created:
    - content/modules/05-cicd/05-cheat-sheet.mdx
  modified:
    - lib/__tests__/modules.test.ts
decisions:
  - "Pipeline YAML in cheat sheet matches lesson 3 exactly (same action versions: checkout@v6, setup-buildx@v4, login-action@v4, build-push-action@v7) — single source of truth for the learner"
  - "ExerciseCard in cheat sheet uses 5 steps ending with Actions tab observation — mirrors the hands-on verification pattern used in Docker and networking modules"
  - "Callout explains GITHUB_TOKEN auto-provisioning to eliminate the most common learner confusion (thinking they need to create secrets manually)"
metrics:
  duration: 2min
  completed: "2026-03-19"
  tasks_completed: 2
  files_changed: 2
---

# Phase 5 Plan 4: CI/CD Cheat Sheet and Pipeline Reference Summary

CI/CD cheat sheet with complete pipeline YAML (lint -> test -> build-push to ghcr.io), pipeline exercise with VerificationChecklist, 4 QuickReference sections covering all four lessons, and Vitest assertion confirming 5 CI/CD lessons.

## What Was Built

### Task 1: CI/CD Cheat Sheet (content/modules/05-cicd/05-cheat-sheet.mdx)

The cheat sheet serves dual purpose as CICD-05 (hands-on pipeline exercise) and CICD-06 (quick reference). Key content:

**Pipeline Exercise Section:**
- Complete production-quality `.github/workflows/ci.yml` YAML with three jobs: lint -> test -> build-push
- Current action versions: `actions/checkout@v6`, `docker/setup-buildx-action@v4`, `docker/login-action@v4`, `docker/build-push-action@v7`
- Main-branch guard (`if: github.ref == 'refs/heads/main'`) on build-push job
- `permissions: contents: read / packages: write` block for ghcr.io authentication
- ExerciseCard with 5 steps: create GitHub repo, copy docker/app/ files, add workflow YAML, push to main, watch Actions tab
- VerificationChecklist: workflow triggers on push, lint passes, test passes, Docker image visible in Packages tab
- Callout explaining GITHUB_TOKEN is auto-provisioned (no manual secret setup required)

**4 QuickReference Sections:**
1. CI/CD Concepts — CI vs CD vs Continuous Deployment, pipeline stages, artifacts, feedback loops
2. GitHub Actions — .github/workflows/ location, triggers (push/pull_request/workflow_dispatch/schedule), steps uses vs run, secrets context, github context, GITHUB_TOKEN, needs dependency
3. Building & Testing — all four docker actions with current versions, cache-from/cache-to, matrix strategy, fail-fast, npm ci/test/lint
4. Deployment Strategies — Blue/Green (instant switch, double cost, instant rollback), Rolling (gradual, mixed versions), Canary (traffic split, safest) with comparison summary

### Task 2: Vitest Lesson Count Assertion (lib/__tests__/modules.test.ts)

Added one new test case in the `getAllLessonPaths` describe block:

```typescript
it('cicd module has 5 lessons', () => {
  const paths = getAllLessonPaths()
  const cicdPaths = paths.filter(p => p.moduleSlug === '05-cicd')
  expect(cicdPaths).toHaveLength(5)
})
```

All 9 module tests pass. Full Vitest suite: 30 tests across 5 test files, all green.

## Verification Results

- `npx vitest run` — 30 tests passed (5 test files)
- `npx vitest run lib/__tests__/mdx.test.ts` — 4 tests passed (cheat sheet MDX frontmatter valid)
- `npx vitest run lib/__tests__/modules.test.ts` — 9 tests passed (including new cicd count assertion)
- `ls content/modules/05-cicd/*.mdx | wc -l` — returns 5

## Deviations from Plan

**None** — plan executed exactly as written.

**Note (out of scope):** Plan 05-02 was not executed prior to this plan. The plan verification criterion `ls content/modules/04-sysadmin/*.mdx | wc -l returns 7` is not currently met (returns 6, missing `07-cheat-sheet.mdx`). This is a pre-existing state from 05-02 not being executed — the sysadmin cheat sheet is 05-02's artifact, not this plan's artifact. This plan's own must_haves are all satisfied.

## Commits

| Hash | Message | Files |
|------|---------|-------|
| e5a1779 | feat(05-04): CI/CD cheat sheet with pipeline exercise and 4 QuickReference sections | content/modules/05-cicd/05-cheat-sheet.mdx |
| 700d8bd | test(05-04): add cicd module lesson count assertion (expects 5) | lib/__tests__/modules.test.ts |

## Self-Check: PASSED

- [x] content/modules/05-cicd/05-cheat-sheet.mdx exists
- [x] lib/__tests__/modules.test.ts contains "05-cicd" and "toHaveLength(5)"
- [x] commit e5a1779 exists in git log
- [x] commit 700d8bd exists in git log
- [x] Full Vitest suite: 30 tests green
