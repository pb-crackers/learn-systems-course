# Preference System Specification

**Version:** 1.0
**Applies to:** `ProgressProvider`, `DifficultyToggle`, and `ExerciseCard` in Phase 9 (component implementation).

---

## 1. Storage

The learner's mode preference is stored in localStorage under the key `'learn-systems-preferences'`.

This key is **separate from** `'learn-systems-progress'`. A progress reset (clearing the learner's lesson completion state) MUST NOT wipe the mode preference. These are two independent concerns stored in two independent keys.

| Key | Contents | Reset behavior |
|-----|----------|----------------|
| `learn-systems-progress` | Lesson completion state, completedAt timestamps, exercise IDs | Cleared on explicit progress reset |
| `learn-systems-preferences` | Mode preference (guided vs. compose) | Never cleared by progress reset |

If `'learn-systems-preferences'` is missing or malformed in localStorage, `ProgressProvider` must fall back to `INITIAL_PREFERENCES` without throwing. Treat missing/malformed data as "no preference set."

---

## 2. Shape

```typescript
export const PREFERENCES_STORAGE_KEY = 'learn-systems-preferences'

export interface PreferencesState {
  preferredMode: ExerciseMode | null
  version: number
}

export const INITIAL_PREFERENCES: PreferencesState = {
  preferredMode: null,
  version: 1,
}
```

`preferredMode: null` means "no preference set — use difficulty default."

The `version` field follows the same versioning pattern as `ProgressState`. Increment it if the shape changes in a future version. During read, if the stored version does not match the expected version, discard and return `INITIAL_PREFERENCES`.

The shape is intentionally flat — no nested objects, no arrays. Preference state must remain serializable to a single JSON string.

---

## 3. Mode Resolution Chain

Each `ExerciseCard` resolves its effective render mode via a three-tier fallback chain, evaluated in priority order:

**Priority 1: Explicit `mode` prop on `ExerciseCard`**
The component's `mode` prop takes precedence over everything. Use this for pedagogy-critical cases only:
- First encounter with a command → `mode="guided"` ensures full annotation display even on Intermediate lessons.
- Capstone exercises → `mode="compose"` ensures challenge framing is never degraded by learner preference.

**Priority 2: Learner's `preferredMode` from `PreferencesState`**
If no explicit `mode` prop is set, use the learner's stored preference. This is the global toggle: if the learner switches to guided mode on a Challenge lesson, all Challenge exercises on that page render as guided. The preference persists across page loads and sessions.

**Priority 3: Difficulty default**
If no explicit `mode` prop and no stored preference, use the difficulty-based default:

| Difficulty | Default mode |
|-----------|-------------|
| Foundation | `guided` |
| Intermediate | `recall` |
| Challenge | `compose` |

This ensures that a learner who has never touched the toggle gets the pedagogically correct experience for each difficulty tier.

---

## 4. Foundation Safety Net

Foundation exercises ALWAYS resolve to `'guided'` mode. This is a **hard override**, not a default.

The Foundation safety net is enforced in `ExerciseCard`, not in `ProgressProvider`. Implementation rule:

```
if (props.difficulty === 'Foundation') {
  effectiveMode = 'guided'
} else {
  // apply three-tier resolution chain
}
```

This override applies regardless of:
- The learner's `preferredMode` value
- Any explicit `mode` prop on the `ExerciseCard`

**Rationale:** Foundation learners are encountering these commands for the first time. Showing full annotations and numbered steps is required for learning — not optional. A learner who accidentally switches to challenge mode on a Foundation lesson must still receive guided rendering. Annotations must be visible; commands must be present; step-by-step structure must be intact.

The `FOUNDATION_SAFETY_NET` constant in `types/exercises.ts` documents this rule for implementers. Its value is `true`.

---

## 5. Toggle Visibility

The `DifficultyToggle` component is rendered by `LessonLayout` only when the lesson's frontmatter difficulty is `'Challenge'`.

```
if (frontmatter.difficulty === 'Challenge') {
  render DifficultyToggle
}
```

Foundation lessons: **no toggle rendered.** The Foundation safety net makes a toggle meaningless — Foundation mode cannot change.

Intermediate lessons: **no toggle rendered.** Intermediate difficulty has a fixed pedagogical purpose (recall practice — scaffolding-fading principle). The step structure is visible but commands are suppressed. This is the intended experience and must not be overridden by a global preference toggle.

Challenge lessons: **toggle rendered.** Learners may legitimately want to review a Challenge exercise in guided mode if they are stuck, or they may want to practice in compose mode even on a Challenge lesson they have completed. The toggle supports both.

---

## 6. Toggle Options

When the `DifficultyToggle` is visible (Challenge lessons only), it offers exactly two options:

| Toggle state | Effective mode | What the learner sees |
|-------------|---------------|----------------------|
| Guided Mode | `guided` | Full annotations, numbered steps, commands visible |
| Challenge Mode | `compose` | Challenge prompt, reference sheet, no step list |

The toggle does NOT offer "Recall Mode" as a standalone choice. `'recall'` is the fixed mode for Intermediate lessons — it is not a learner-selectable preference. Exposing it as a toggle option would confuse learners about what Intermediate means and undermine the scaffolding-fading design.

When a learner selects Guided Mode or Challenge Mode, `DifficultyToggle` calls `setPreferredMode` with `'guided'` or `'compose'` respectively. Setting `preferredMode` to `null` resets to difficulty default (this may be exposed as a "Reset to default" option if needed, but is not required for v1.1).

---

## 7. Preference Context API (Contract for Phase 9)

`ProgressProvider` must expose these values in its context:

```typescript
preferredMode: ExerciseMode | null
setPreferredMode: (mode: ExerciseMode | null) => void
```

`ExerciseCard` reads `preferredMode` via `useProgress()`. `DifficultyToggle` calls `setPreferredMode` via `useProgress()`. Neither component accesses localStorage directly — all persistence is handled inside `ProgressProvider`.
