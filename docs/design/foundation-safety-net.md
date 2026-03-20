# Foundation Safety-Net Rule

**Status:** Locked — 2026-03-20
**Phase:** 08-design-lock
**Applies to:** ExerciseCard mode resolution in Phase 9 component implementation

---

## 1. Rule

Foundation exercises ALWAYS render in `'guided'` mode.

This is a hard override at the `ExerciseCard` level — not a preference default, not a soft fallback, not a configurable option. No UI toggle, no `mode` prop, no learner `preferredMode` preference can change a Foundation exercise away from guided mode.

When `difficulty === 'Foundation'`, the resolved mode is ALWAYS `'guided'`.

---

## 2. Rationale

Foundation learners are encountering CLI commands for the first time. They have no prior context to fill a knowledge gap.

A Foundation exercise must always provide:

- **Full command text visible and copyable** — the learner cannot be expected to recall syntax they have never seen
- **Per-flag annotations explaining every token** — each flag's purpose, effect, and when to use it must be visible without external lookup
- **Numbered step-by-step instructions** — the sequence is explicit; learners cannot infer correct ordering from a goal statement alone

Removing any of these elements creates a knowledge gap at the precise level where the learner has no prior experience to fill it. The scaffolding-fading principle (PMC 2022 scaffolding research, Sweller/Kalyuga worked-examples model) supports full support at novice level — fading scaffolding comes at the Intermediate tier, not Foundation.

Challenge mode (goal-only, no steps) is pedagogically appropriate for learners who have already encountered the commands and practiced their application. It is not appropriate for first exposure.

---

## 3. Implementation Contract

In `ExerciseCard` mode resolution (Phase 9 implementation), the resolution logic is:

```
function resolveMode(difficulty, modeProp, preferredMode):
  if difficulty === 'Foundation':
    return 'guided'          // hard override — skip all other checks

  if modeProp is set:
    return modeProp          // explicit prop wins for non-Foundation

  if preferredMode is set:
    return preferredMode     // learner preference for non-Foundation

  // difficulty defaults for non-Foundation
  if difficulty === 'Intermediate':
    return 'recall'

  if difficulty === 'Challenge':
    return 'compose'
```

When `difficulty === 'Foundation'`: skip the `modeProp` check, skip the `preferredMode` check, return `'guided'` immediately. The override happens at the first line of mode resolution — nothing downstream can change it.

---

## 4. Toggle Behavior

The `DifficultyToggle` component is NOT rendered on Foundation lessons.

`LessonLayout` gates toggle rendering on `frontmatter.difficulty === 'Challenge'`. Foundation lessons never have a `DifficultyToggle` in the UI. This is a secondary enforcement layer: even if a learner navigates to a Foundation lesson after having set a `preferredMode` on a Challenge lesson, the Foundation lesson ignores that preference entirely (per the implementation contract above) AND does not show a toggle that might suggest mode switching is possible.

The `preferredMode` stored in `localStorage` under `'learn-systems-preferences'` is not cleared when the learner moves to a Foundation lesson. It is simply not consulted.

---

## 5. Intermediate Behavior

Intermediate exercises use `'recall'` mode by default.

Unlike Foundation, Intermediate exercises DO respect the learner's `preferredMode` if set. A learner who set `preferredMode` to `'guided'` on a Challenge lesson will see Intermediate lessons in `'guided'` mode too. The preference persists across navigation.

However, the `DifficultyToggle` is NOT rendered on Intermediate lessons. The toggle only appears on Challenge lessons. If a learner wants to change their `preferredMode` while on an Intermediate lesson, they must navigate to a Challenge lesson to do so.

This means the mode toggle is a Challenge-lesson feature, not a site-wide control. The preference it sets affects Intermediate rendering as a side effect — but the control surface lives only on Challenge lessons.

### Intermediate mode resolution summary

| Condition | Resolved mode |
|-----------|--------------|
| `difficulty === 'Intermediate'`, no `preferredMode` set | `'recall'` |
| `difficulty === 'Intermediate'`, `preferredMode === 'guided'` | `'guided'` |
| `difficulty === 'Intermediate'`, `preferredMode === 'compose'` | `'recall'` (compose is Challenge-only; Intermediate falls back to default) |
| `difficulty === 'Intermediate'`, explicit `mode` prop set | `mode` prop value |

Note: `'compose'` is not a valid Intermediate render mode. If `preferredMode` is `'compose'` (set from a Challenge lesson) and the learner navigates to an Intermediate lesson, the resolved mode falls back to `'recall'`. The compose branch is only valid when `difficulty === 'Challenge'`.

---

## Key Links

- `components/content/ExerciseCard.tsx` — mode resolution logic (to be implemented in Phase 9)
- `components/progress/ProgressProvider.tsx` — `preferredMode` / `setPreferredMode` in context (to be extended in Phase 9)
- `components/lesson/DifficultyToggle.tsx` — toggle component (to be built in Phase 9); rendered only for `difficulty === 'Challenge'`
- `docs/design/challenge-content-policy.md` — companion document for Challenge-mode content rules
