---
status: awaiting_human_verify
trigger: "After adding quiz exports to all 57 MDX lesson files in Phase 15 (v1.2), the Next.js dev server crashes with MDX parse errors when loading lesson pages."
created: 2026-03-23T00:00:00Z
updated: 2026-03-23T00:00:00Z
---

## Current Focus

hypothesis: CONFIRMED - Missing closing `}` for "Key Files" section object in QuickReference JSX prop in 09-package-management.mdx
test: JSX bracket balance scan across all MDX files
expecting: Fix confirmed: add missing `},` after items array in Key Files section
next_action: Apply fix to 09-package-management.mdx, then verify

## Symptoms

expected: Lesson pages load normally with quiz component rendered below content
actual: 500 errors on lesson pages, MDX build failures
errors: "GET /modules/01-linux-fundamentals/04-file-permissions 500 in 346ms" and "Uncaught ModuleBuildError: Module build failed (from ./node_modules/@next/mdx/mdx-js-loader.js): 09-package-management.mdx:380:3: Could not parse expression with acorn"
reproduction: Run `npm run dev` and navigate to any lesson page
started: After Phase 15 content authoring — quiz exports added to all 57 MDX files

## Eliminated

- hypothesis: Unescaped apostrophes (\'  in single-quoted strings) in quiz exports cause acorn failure
  evidence: `\'` IS valid JavaScript syntax in single-quoted string literals; acorn handles it fine; no quiz export line triggers the error
  timestamp: 2026-03-23

- hypothesis: Angle brackets in double-quoted JSX attribute strings (e.g., description="Set <file>") cause acorn failure
  evidence: In JSX, attribute string values (prop="...") are string literals — acorn does NOT parse JSX tags inside them; no other files besides 09-package-management fail the JSX bracket balance check
  timestamp: 2026-03-23

- hypothesis: Multiple files are affected systematically
  evidence: Bracket imbalance scan across all 59 MDX files shows only ONE file (09-package-management.mdx) has an imbalanced JSX self-closing component block
  timestamp: 2026-03-23

## Evidence

- timestamp: 2026-03-23
  checked: 09-package-management.mdx line 380 — the acorn error location
  found: `<QuickReference sections={[...]}/>` spans lines 337-381; bracket balance tracking shows depth=1 at EOF of the component instead of 0; the "Key Files" section object opened at line 372 with `{` is never closed with `}` before `]}` on line 380
  implication: The `]}` at line 380 tries to close the sections array `]` and the prop expression `}`, but the Key Files object `{}` adds one unclosed `{`, making depth=1 instead of 0 at the `/>` — this is an invalid JSX expression that acorn cannot parse

- timestamp: 2026-03-23
  checked: All 59 MDX files via Python bracket balance scanner
  found: Only 09-package-management.mdx has a self-closing JSX component with unbalanced brackets (depth=1)
  implication: This is a single-file issue, not a systematic multi-file problem; the other 500 error mentioned in symptoms (04-file-permissions) may be a cascade effect from the dev server failing to compile any page

- timestamp: 2026-03-23
  checked: Quiz exports across all files for problematic JavaScript patterns
  found: No bare `<identifier>` patterns in expression position in any quiz export; all angle brackets are properly inside string literals
  implication: Quiz exports are syntactically valid JavaScript

## Resolution

root_cause: In `content/modules/01-linux-fundamentals/09-package-management.mdx`, the `<QuickReference>` component's `sections` JSX prop (lines 337-381) is missing a closing `},` for the "Key Files" section object. Line 372 opens `{` for the Key Files object, line 379 closes `items: [...]`, but the object itself is never closed before `]}` on line 380. This creates an unbalanced JSX expression (one extra unclosed `{`), which acorn cannot parse — hence the "Could not parse expression with acorn" error at line 380:3.
fix: Added missing closing `},` for the "Key Files" section object in the `sections` prop of `<QuickReference>` in 09-package-management.mdx. Line 379 (`]`) closes the `items` array, and the new line 380 (`    }`) closes the section object. The original `]}` is now on line 381, properly closing the sections array `]` and the prop expression `}`.
verification: Python bracket balance scanner confirms depth=0 at end of QuickReference block post-fix. Full scan of all 59 MDX files shows zero remaining bracket-imbalanced JSX components.
files_changed: [content/modules/01-linux-fundamentals/09-package-management.mdx]
