# Audit Results: Foundation Command Fields and Difficulty Mismatches

**Audit date:** 2026-03-20
**Phase:** 08-design-lock
**Scope:** All MDX files in `content/modules/` (excluding template files)
**Method:** Automated Python grep — direct parse of ExerciseCard blocks and frontmatter

Template files excluded from counts: `01-linux-fundamentals/00-template.mdx`, `_exercise-template.mdx`

---

## 1. Foundation Command Field Count

### Summary

**Total Foundation command fields (real lesson content): 160**

The research estimate of ~200 was OVER by 40 (actual is 20% lower). The 23 files containing Foundation ExerciseCards include the `00-template.mdx` file (2 command fields) — excluding it yields **160 command fields across 22 real Foundation lessons with ExerciseCard content**.

Note: 30 lessons have frontmatter `difficulty: "Foundation"`, but 8 of those are cheat-sheet reference pages that do not contain ExerciseCard components with `command:` step fields. Only 22 Foundation lessons contain actual ExerciseCard command fields.

### Per-Module Breakdown

| Module | Foundation Lessons with Commands | Command Fields |
|--------|----------------------------------|----------------|
| 01-linux-fundamentals | 4 | 34 |
| 02-networking | 4 | 30 |
| 03-docker | 3 | 21 |
| 04-sysadmin | 3 | 29 |
| 05-cicd | 2 | 10 |
| 06-iac | 2 | 14 |
| 07-cloud | 2 | 8 |
| 08-monitoring | 2 | 14 |
| **TOTAL** | **22** | **160** |

### Per-File Detail

| File | Command Fields |
|------|---------------|
| `01-linux-fundamentals/01-how-computers-work.mdx` | 7 |
| `01-linux-fundamentals/02-operating-systems.mdx` | 7 |
| `01-linux-fundamentals/03-linux-filesystem.mdx` | 10 |
| `01-linux-fundamentals/04-file-permissions.mdx` | 10 |
| `02-networking/01-how-networks-work.mdx` | 6 |
| `02-networking/02-tcp-ip-stack.mdx` | 7 |
| `02-networking/03-dns.mdx` | 9 |
| `02-networking/04-http-https.mdx` | 8 |
| `03-docker/01-what-are-containers.mdx` | 6 |
| `03-docker/02-docker-images.mdx` | 7 |
| `03-docker/03-docker-containers.mdx` | 8 |
| `04-sysadmin/01-user-management.mdx` | 10 |
| `04-sysadmin/02-systemd.mdx` | 10 |
| `04-sysadmin/03-logging.mdx` | 9 |
| `05-cicd/01-cicd-concepts.mdx` | 5 |
| `05-cicd/02-github-actions.mdx` | 5 |
| `06-iac/01-iac-concepts.mdx` | 5 |
| `06-iac/02-hcl-basics.mdx` | 9 |
| `07-cloud/01-cloud-concepts.mdx` | 4 |
| `07-cloud/02-compute.mdx` | 4 |
| `08-monitoring/01-observability-concepts.mdx` | 4 |
| `08-monitoring/02-prometheus.mdx` | 10 |

---

## 2. Difficulty Mismatch Report

### Summary

**Total mismatches: 1**

The research estimate of 5-10 mismatches was OVER. Only one file has a frontmatter/ExerciseCard difficulty discrepancy.

### Mismatch Table

| File | Frontmatter Difficulty | ExerciseCard Difficulty | Notes |
|------|----------------------|------------------------|-------|
| `05-cicd/05-cheat-sheet.mdx` | Foundation | Intermediate | Cheat-sheet lesson; frontmatter says Foundation but the single ExerciseCard uses `difficulty="Intermediate"` |

### Impact on Phase 9 Rendering Logic

Phase 9 rendering logic reads difficulty from the `ExerciseCard` `difficulty` prop — this is the authoritative source for mode resolution, not `frontmatter.difficulty`. The `LessonLayout` DifficultyToggle gate reads `frontmatter.difficulty` to decide whether to show the toggle.

For the one mismatch (`05-cicd/05-cheat-sheet.mdx`):
- `LessonLayout` reads `frontmatter.difficulty = "Foundation"` → does NOT render `DifficultyToggle` (correct behavior for a cheat sheet)
- `ExerciseCard` reads its own `difficulty="Intermediate"` prop → renders in `'recall'` mode by default
- The exercise will behave as Intermediate (no command suppression expected since it's a reference exercise), but the page header/badge will show "Foundation"

This mismatch is a pre-existing content inconsistency. Resolution before Phase 11: set either the frontmatter or the ExerciseCard prop to match. Recommendation: change frontmatter `difficulty` to `Intermediate` to match the exercise, or change the ExerciseCard prop to `Foundation` if the exercise steps are simple enough to be genuinely introductory.

---

## 3. Phase 11 Scoping Implications

### Revised Effort Estimate

**Actual workload: 160 command fields requiring annotation** (not the ~200 estimate — 20% less work than estimated).

At the v1.0 baseline velocity of ~7 min/plan, and assuming each Foundation annotation adds approximately 5-8 annotations per command (per-flag breakdown rows), Phase 11 involves:

- 160 command fields to annotate
- Average 5.2 steps per exercise (160 commands / 22 lessons ≈ 7.3 commands/lesson)
- Heaviest modules: 01-linux-fundamentals (34 commands), 02-networking (30 commands), 04-sysadmin (29 commands)
- Lightest modules: 07-cloud (8 commands), 05-cicd (10 commands)

**Recommended Phase 11 strategy:** Migrate modules in ascending command-field order to build annotation authoring velocity before tackling the largest modules:

1. `07-cloud` — 8 commands (lightest, good first module)
2. `05-cicd` — 10 commands
3. `08-monitoring` — 14 commands
4. `06-iac` — 14 commands
5. `03-docker` — 21 commands
6. `04-sysadmin` — 29 commands
7. `02-networking` — 30 commands
8. `01-linux-fundamentals` — 34 commands (save for last — largest, but also most familiar CLI content)

### Mismatch Resolution Before Phase 11

The one mismatch (`05-cicd/05-cheat-sheet.mdx`) must be resolved before Phase 11 begins. The exercise is a cheat-sheet with an Intermediate-difficulty ExerciseCard — it does not require command annotations. Recommended fix: update frontmatter `difficulty` to `"Intermediate"` so that `LessonLayout` renders the `DifficultyToggle` correctly if a user arrives at the page in challenge context.

### Cheat-Sheet Lesson Clarification

8 lessons have frontmatter `difficulty: "Foundation"` but no ExerciseCard command fields (they are cheat-sheet/reference pages). These do not require annotation work in Phase 11 — they have no `command:` step fields to annotate.

---

## Audit Methodology

**Command field count:** Python script parsing all MDX files matching `difficulty="Foundation"` in ExerciseCard blocks, counting lines matching `\bcommand:\s*["` ` ` ` ` `]` within those blocks.

**Mismatch detection:** Python script extracting frontmatter `difficulty:` field and all ExerciseCard `difficulty=` props from each MDX file, flagging any file where at least one ExerciseCard prop differs from frontmatter.

**Corpus:** 57 MDX files in `content/modules/` (55 production lessons + 2 template files). Templates excluded from all counts.
