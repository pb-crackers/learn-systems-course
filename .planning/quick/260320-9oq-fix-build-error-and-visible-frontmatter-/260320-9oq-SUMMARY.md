---
phase: quick
plan: 260320-9oq
subsystem: build, mdx
tags: [remark-frontmatter, mdx, callout, next-config, build-fix]

requires:
  - phase: 01-app-foundation
    provides: "MDX pipeline with @next/mdx, rehype-pretty-code, remark-gfm"
provides:
  - "remark-frontmatter stripping YAML from rendered MDX output"
  - "All Callout components use valid types (tip, warning, deep-dive)"
  - "CodeBlock component registered as named MDX component"
affects: [content-authoring, mdx-pipeline]

tech-stack:
  added: [remark-frontmatter]
  patterns: ["CodeBlock accepts both pre-mapped API and direct language/title props"]

key-files:
  created: []
  modified:
    - next.config.ts
    - package.json
    - mdx-components.tsx
    - components/content/CodeBlock.tsx
    - components/content/QuickReference.tsx
    - components/content/ExerciseCard.tsx
    - components/content/VerificationChecklist.tsx
    - content/modules/07-cloud/06-cheat-sheet.mdx
    - content/modules/04-sysadmin/06-system-monitoring.mdx
    - content/modules/05-cicd/04-deployment-strategies.mdx
    - content/modules/05-cicd/02-github-actions.mdx

key-decisions:
  - "CodeBlock registered as named MDX component in mdx-components.tsx for direct <CodeBlock> usage in MDX files"
  - "QuickReference fallback renders children when sections prop is absent (supports markdown table usage in capstone)"

patterns-established:
  - "MDX components should have defensive defaults for array props to survive static prerendering"

requirements-completed: []

duration: 6min
completed: 2026-03-20
---

# Quick Task 260320-9oq: Fix Build Error and Visible Frontmatter Summary

**remark-frontmatter plugin strips YAML from rendered MDX; Callout type="info" replaced with type="tip" across 4 files; pre-existing build errors fixed in CodeBlock/QuickReference/ExerciseCard/VerificationChecklist**

## Performance

- **Duration:** 6 min
- **Started:** 2026-03-20T11:02:37Z
- **Completed:** 2026-03-20T11:09:00Z
- **Tasks:** 2
- **Files modified:** 12

## Accomplishments
- Replaced all 4 instances of invalid `type="info"` with `type="tip"` in MDX Callout components
- Installed remark-frontmatter and configured in next.config.ts remarkPlugins array
- Production build passes (70/70 static pages generated)

## Task Commits

Each task was committed atomically:

1. **Task 1: Fix invalid Callout type="info" in MDX files** - `c7cc042` (fix)
2. **Task 2: Install remark-frontmatter and add to Next.js MDX config** - `da73b54` (fix)

## Files Created/Modified
- `next.config.ts` - Added remark-frontmatter to remarkPlugins array
- `package.json` / `package-lock.json` - Added remark-frontmatter dependency
- `mdx-components.tsx` - Registered CodeBlock as named MDX component
- `components/content/CodeBlock.tsx` - Added language/title props for direct MDX usage
- `components/content/QuickReference.tsx` - Added children fallback for markdown table usage
- `components/content/ExerciseCard.tsx` - Defensive default for steps prop
- `components/content/VerificationChecklist.tsx` - Defensive default for items prop
- `content/modules/07-cloud/06-cheat-sheet.mdx` - type="info" to type="tip"
- `content/modules/04-sysadmin/06-system-monitoring.mdx` - type="info" to type="tip"
- `content/modules/05-cicd/04-deployment-strategies.mdx` - type="info" to type="tip"
- `content/modules/05-cicd/02-github-actions.mdx` - type="info" to type="tip"

## Decisions Made
- CodeBlock registered as named MDX component because 3 CICD files use `<CodeBlock language="yaml" title="...">` syntax directly instead of fenced code blocks
- QuickReference updated with children fallback because advanced capstone uses markdown table children instead of structured sections prop

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Fixed pre-existing QuickReference crash on advanced capstone page**
- **Found during:** Task 2 (build verification)
- **Issue:** `QuickReference` in 07-advanced-capstone.mdx passed `title` prop with markdown table children but component only accepted `sections` array prop -- `.map()` on undefined
- **Fix:** Added children/title fallback rendering path when sections is absent
- **Files modified:** components/content/QuickReference.tsx
- **Verification:** Build passes, 70/70 pages generated
- **Committed in:** da73b54 (Task 2 commit)

**2. [Rule 3 - Blocking] Registered CodeBlock as named MDX component**
- **Found during:** Task 2 (build verification)
- **Issue:** 3 CICD MDX files use `<CodeBlock>` directly but it was only mapped as `pre` in mdx-components.tsx -- "Expected component CodeBlock to be defined"
- **Fix:** Added CodeBlock to named components in mdx-components.tsx; added language/title props to CodeBlock component
- **Files modified:** mdx-components.tsx, components/content/CodeBlock.tsx
- **Verification:** Build passes without CodeBlock errors
- **Committed in:** da73b54 (Task 2 commit)

**3. [Rule 1 - Bug] Added defensive defaults for ExerciseCard and VerificationChecklist**
- **Found during:** Task 2 (build verification)
- **Issue:** Array props (steps, items) could be undefined during static prerendering, causing `.map()` crash
- **Fix:** Added `= []` default values for steps and items props
- **Files modified:** components/content/ExerciseCard.tsx, components/content/VerificationChecklist.tsx
- **Verification:** Build passes
- **Committed in:** da73b54 (Task 2 commit)

---

**Total deviations:** 3 auto-fixed (2 blocking, 1 bug)
**Impact on plan:** All auto-fixes necessary for build to pass. No scope creep.

## Issues Encountered
None beyond the auto-fixed deviations above.

## User Setup Required
None - no external service configuration required.

---
## Self-Check: PASSED

*Quick Task: 260320-9oq*
*Completed: 2026-03-20*
