# Challenge Content Policy

**Status:** Locked — 2026-03-20
**Phase:** 08-design-lock
**Applies to:** All Challenge-difficulty exercise authoring in Phase 11 content migration

---

## 1. Goal-Only Format

Challenge exercises communicate the overall goal the learner must achieve — nothing more. The presentation is built around `challengePrompt`, not the `steps` array.

### What is displayed

When `ExerciseCard` resolves to `'compose'` mode (the Challenge render path), exactly three things are shown:

1. The `challengePrompt` paragraph — the stated goal
2. A `ChallengeReferenceSheet` — a scoped command reference
3. Any `VerificationChecklist` children — observable outcome checks

The numbered step list (`steps` array) is NOT rendered when mode is `'compose'`. The step data still exists in the MDX (to provide a guided fallback if the learner's `preferredMode` is set to `'guided'`), but it is hidden from view in challenge mode.

### Writing the challengePrompt

The `challengePrompt` describes WHAT the learner must accomplish, not HOW to accomplish it.

**No procedural language.** The prompt must not say "First do X, then do Y, finally do Z." It must not use words like "First", "Then", "Next", "After that", "Finally", "Begin by", or "Start with."

**Correct format — goal statement:**
> "Deploy a containerized web application accessible on port 8080. The container must restart automatically if it stops, and its logs must be accessible via the Docker CLI."

**Incorrect format — procedural steps disguised as a goal:**
> "Run `docker build` to create the image, then run `docker run` with port mapping and restart policy flags."

The prompt describes a real-world scenario outcome. The learner must determine the sequence and exact commands independently.

### The steps array in Challenge exercises

The `steps` array is still authored for every Challenge exercise. It serves two purposes:

1. Guided fallback — if the learner toggles to `'guided'` mode via `DifficultyToggle`, `ExerciseCard` renders the step list normally
2. Content consistency — every exercise in the corpus has the same structural completeness regardless of display mode

Steps in Challenge exercises should be authored at the same level of detail as Foundation steps. The fallback must be usable.

---

## 2. Reference Sheet Rules

Every Challenge exercise includes a `ChallengeReferenceSheet` component at the bottom of the exercise card (before `VerificationChecklist`). The reference sheet wraps `QuickReference` with challenge-specific visual treatment.

### Item limit

**Maximum 15 items per reference sheet.** This is a hard cap, not a guideline. An author must make curatorial decisions about what to include. If a natural set of relevant commands exceeds 15, group or consolidate — do not exceed the cap.

Why 15: A reference sheet that covers everything removes the challenge. The learner must still recognize which commands apply to this goal.

### Section structure

Items are organized into `ReferenceSection` groups. Each section has a descriptive title that names the command domain, not a step number.

**Correct section title:** `"Container Management"`, `"Network Commands"`, `"Image Operations"`

**Incorrect section title:** `"Step 1 Commands"`, `"Start Here"`, `"Commands in Order"`

### No sequential ordering language

Items within a reference sheet must not imply an order of operations. The following are forbidden in any item's `command`, `description`, or `example` field:

- "First", "Then", "After", "Before", "Next", "Finally"
- "Step 1", "Step 2" (or any numbered prefix)
- "Once you have...", "Before running..."

Every item must be independently usable. The learner determines the order.

### Items do not name the solution

Reference sheet items list commands the learner *might* need — including commands they will not use (distractors). Items must not signal which commands solve the exercise.

**Good item (tool in toolbox):**
```
{
  command: "docker run",
  description: "Create and start a new container from an image",
  example: "docker run -d -p 80:80 nginx"
}
```

**Bad item (names the solution):**
```
{
  command: "Step 1: docker build",
  description: "First, build the image from the Dockerfile in the current directory"
}
```

**Bad item (gives away the solution flags):**
```
{
  command: "docker run -d -p 8080:80 --restart always",
  description: "Run the container with the required port and restart settings"
}
```

### ReferenceItem shape

Every item must conform to the existing `ReferenceItem` type from `components/content/QuickReference.tsx`:

```typescript
export interface ReferenceItem {
  command: string       // the command name or syntax skeleton (no solution-specific flags)
  description: string   // one sentence, no sequential language
  example?: string      // optional, short illustrative use — must not be the solution
}
```

---

## 3. Verification Standards

Every Challenge exercise must include a `VerificationChecklist` component as a child of `ExerciseCard`. Verification items test observable outcomes — not process steps.

### Minimum item count

**Minimum 3 verification items per challenge exercise.** There is no maximum, but 3–5 is the expected range for most exercises.

### Hint format: runnable command with expected output

Each verification item's `hint` field must contain:
1. A runnable command the learner can execute to check their work
2. The exact expected output (or a specific pattern) that indicates success

**Correct hint format:**
> "Run `docker ps --format '{{.Ports}}'` — should show `0.0.0.0:8080->80/tcp`"

> "Run `docker inspect <container-name> --format '{{.HostConfig.RestartPolicy.Name}}'` — should return `always`"

> "Run `docker logs <container-name> 2>&1 | head -5` — should show application startup messages, not an error"

**Incorrect hint format (vague, no command, no expected output):**
> "Check that the container is running"

> "Verify port 8080 is accessible"

> "Make sure the restart policy is set correctly"

Every hint must be specific enough that the learner does not need to invent their own verification method.

### Test observable outcomes, not process steps

Verification items check the end state, not how the learner got there.

**Correct (observable outcome):**
> "Run `curl -s -o /dev/null -w '%{http_code}' http://localhost:8080` — should return `200`"

**Incorrect (process verification — checks steps, not outcomes):**
> "Confirm you ran `docker build` before `docker run`"

### At least one negative or edge case

At least one verification item should test a negative case or edge condition. Examples:

- What happens when the container receives a signal (restart policy test)
- What happens at a port that should NOT be exposed
- Confirming a log entry that would only appear if configuration is correct, not just if the process started

---

## Key Links

- `components/content/QuickReference.tsx` — `ReferenceSection`, `ReferenceItem` types used by `ChallengeReferenceSheet`
- `components/content/ExerciseCard.tsx` — `ExerciseCardProps`, `steps` array rendering, mode branching (to be implemented in Phase 9)
- `types/content.ts` — `Difficulty` type (`'Foundation' | 'Intermediate' | 'Challenge'`)
- `docs/design/foundation-safety-net.md` — companion document for tier mode resolution rules
