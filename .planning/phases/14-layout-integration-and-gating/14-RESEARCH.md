# Phase 14: Layout Integration and Gating - Research

**Researched:** 2026-03-22
**Domain:** Next.js App Router prop threading, MDX named export extraction, React conditional rendering, TypeScript interface extension
**Confidence:** HIGH

## Summary

Phase 14 is a wiring phase, not a build phase. All the core pieces already exist: the Quiz component (`components/lesson/Quiz.tsx`) is complete with full state machine and `markQuizPassed` integration; the progress system (`ProgressProvider`, `markQuizPassed`, `isQuizPassed`) is wired and tested; the `QuizQuestion` type schema is locked. This phase connects those pieces through three integration seams: (1) extract the `quiz` named export from the MDX dynamic import in `getLessonContent`, (2) thread the quiz data prop from `page.tsx` through `LessonLayout`, and (3) conditionally render `Quiz` and suppress `MarkCompleteButton` based on whether quiz data exists.

The primary technical challenge is the `getLessonContent` function in `lib/mdx.ts`. Currently it returns only `{ default: MDXContent, frontmatter }` and discards all other named exports. The MDX module returned by `await import('@/content/modules/...')` already contains any `export const quiz = [...]` statements as named exports on the module object. The fix is a single line: extract `mod.quiz` and include it in the return type. No MDX pipeline changes are needed.

The "Continue to Next Lesson" `onContinue` prop on `Quiz` requires computing the next lesson URL at the server level in `page.tsx`, using `getModuleBySlug` which already provides the ordered lessons list. The last lesson in a module links to the module overview (`/modules/[moduleSlug]`).

**Primary recommendation:** The entire phase fits in one plan wave. Three file changes: `lib/mdx.ts` (extract quiz), `app/modules/[moduleSlug]/[lessonSlug]/page.tsx` (pass quiz + nextLessonHref to LessonLayout), and `components/lesson/LessonLayout.tsx` (accept quiz prop, render Quiz, gate MarkCompleteButton). One MDX test lesson adds `export const quiz = [...]`. One integration test verifies the end-to-end flow.

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Quiz renders after MDX content (exercises), before the MarkCompleteButton area — natural reading flow, quiz is the final gate
- Quiz data flows via MDX named export `quiz` → getLessonContent → page.tsx props → LessonLayout prop → Quiz component — follows existing content pipeline with no MDX build changes
- Horizontal rule + "Knowledge Check" heading separates content from quiz — clear section boundary (NOTE: Quiz component already renders its own "Knowledge Check" heading in the idle state — a `<hr>` divider above the Quiz component in LessonLayout is sufficient; no duplicate heading needed)
- Quiz component calls markQuizPassed which already calls markLessonComplete internally (wired in Phase 12)
- MarkCompleteButton conditionally hidden when quiz data exists — `{!quiz && <MarkCompleteButton />}` in LessonLayout
- "Continue to Next Lesson" button links to the next lesson in the module using existing navigation data; if last lesson, links to module overview

### Claude's Discretion
- Exact prop threading approach through page.tsx and LessonLayout
- How to extract named export `quiz` from MDX dynamic import
- Test lesson selection for end-to-end verification
- Any TypeScript adjustments for quiz prop types on LessonLayout

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| LAYOUT-01 | Quiz component rendered in LessonLayout after MDX content, consistent placement across all lessons | LessonLayout currently renders `{children}` then `<MarkCompleteButton>`. Adding `{quiz && <Quiz questions={quiz} lessonId={lessonId} onContinue={...} />}` after `{children}` and before the gated MarkCompleteButton achieves consistent placement. |
| LAYOUT-02 | Quiz data extracted from MDX named export via existing dynamic import pipeline | `getLessonContent` already does `const mod = await import('...')`. `mod.quiz` is available as a named export on the module object if the MDX file exports it. Return type needs `quiz?: QuizQuestion[] | null` added. |
| GATE-01 | Lesson is marked complete only after quiz is passed with 100% — MarkCompleteButton retired for quiz-enabled lessons | `{!quiz && <MarkCompleteButton lessonId={lessonId} />}` in LessonLayout. When quiz is present, only the Quiz component's `markQuizPassed` path can mark the lesson complete. |
</phase_requirements>

---

## Standard Stack

### Core (all already installed — no new dependencies)
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| React (already installed) | 19.2.4 | Conditional rendering, prop threading | Already the app framework |
| TypeScript (already installed) | ^5 | Interface extension for LessonLayout and getLessonContent return type | Already the project language |
| Next.js App Router (already installed) | 16.2.0 | Server Component prop passing, `Link` for next lesson navigation | Already the app router |
| `@next/mdx` (already installed) | ^16.2.0 | MDX compilation — named exports become module properties on the `import()` result | Already configured in next.config.ts |

**No new packages needed.** This phase is pure integration of existing code.

---

## Architecture Patterns

### Recommended Change Flow

```
lib/mdx.ts                          — add quiz extraction from mod object
  ↓
app/modules/[moduleSlug]/[lessonSlug]/page.tsx   — pass quiz + nextLessonHref to LessonLayout
  ↓
components/lesson/LessonLayout.tsx  — accept quiz prop, render Quiz, gate MarkCompleteButton
  ↓
content/modules/.../test-lesson.mdx — add export const quiz for e2e test
```

### Pattern 1: Extracting MDX Named Export in getLessonContent

**What:** MDX files compiled by `@next/mdx` expose all `export const` statements as named exports on the dynamic import module object, alongside `default` (the React component).

**When to use:** Any time an MDX named export needs to flow into the server-side content pipeline.

**Current code (lib/mdx.ts lines 47-70):**
```typescript
// Current return type — only default + frontmatter
export async function getLessonContent(
  moduleSlug: string,
  lessonSlug: string
): Promise<{ default: React.ComponentType; frontmatter: LessonFrontmatter } | null>

// Inside the function:
const mod = await import(`@/content/modules/${moduleSlug}/${lessonSlug}.mdx`)
// mod.quiz is already available here if the MDX file exports it
return { default: mod.default as React.ComponentType, frontmatter }
```

**Required change — return type and extraction:**
```typescript
import type { QuizQuestion } from '@/types/quiz'

export async function getLessonContent(
  moduleSlug: string,
  lessonSlug: string
): Promise<{
  default: React.ComponentType
  frontmatter: LessonFrontmatter
  quiz: QuizQuestion[] | null
} | null> {
  try {
    const mod = await import(`@/content/modules/${moduleSlug}/${lessonSlug}.mdx`)
    // ... frontmatter extraction unchanged ...
    const quiz = Array.isArray(mod.quiz) ? (mod.quiz as QuizQuestion[]) : null
    return { default: mod.default as React.ComponentType, frontmatter, quiz }
  } catch {
    return null
  }
}
```

**Confidence:** HIGH — `@next/mdx` compiles named exports as standard ES module named exports. The comment in the current `getLessonContent` ("@next/mdx compiles MDX files at build time") already confirms this understanding. The `mod` object from the dynamic import has all named exports available.

### Pattern 2: Next Lesson URL Computation in page.tsx

**What:** Server Component (`page.tsx`) uses `getModuleBySlug` to get the ordered lessons list, finds the current lesson index, and computes the `nextLessonHref`.

**When to use:** Any server component that needs navigation links between sequential items.

**Required change — page.tsx:**
```typescript
import { getModuleBySlug } from '@/lib/modules'

export default async function LessonPage({ params }: Props) {
  const { moduleSlug, lessonSlug } = await params
  const lesson = await getLessonContent(moduleSlug, lessonSlug)
  if (!lesson) notFound()

  const { default: MDXContent, frontmatter, quiz } = lesson

  // Compute next lesson link for Quiz "Continue to Next Lesson" button
  const mod = getModuleBySlug(moduleSlug)
  const lessons = mod?.lessons ?? []
  const currentIdx = lessons.findIndex((l) => l.slug === lessonSlug)
  const nextLesson = currentIdx >= 0 && currentIdx < lessons.length - 1
    ? lessons[currentIdx + 1]
    : null
  const nextLessonHref = nextLesson
    ? `/modules/${moduleSlug}/${nextLesson.slug}`
    : `/modules/${moduleSlug}`

  return (
    <LessonLayout frontmatter={frontmatter} quiz={quiz} nextLessonHref={nextLessonHref}>
      <MDXContent />
    </LessonLayout>
  )
}
```

**Note on `getModuleBySlug` vs `getAllModules`:** `getModuleBySlug` is already exported from `lib/modules.ts` (line 45). It calls `getLessonsForModule` which reads from the filesystem. This is safe in a Server Component and already used in the module overview page.

**Note on `mod` being called again:** `getLessonContent` does the MDX import but does not return the ordered lessons list (that comes from `getModuleBySlug`). The extra `getModuleBySlug` call is a small file-scan overhead that only happens at build time (static generation via `generateStaticParams`). This is acceptable.

### Pattern 3: LessonLayout Props Extension

**What:** Add optional `quiz` and `nextLessonHref` props to `LessonLayout`, render Quiz component after MDX content, gate MarkCompleteButton on absence of quiz.

**Current LessonLayout interface (lines 8-11):**
```typescript
interface LessonLayoutProps {
  frontmatter: LessonFrontmatter
  children: React.ReactNode
}
```

**Required extension:**
```typescript
import type { QuizQuestion } from '@/types/quiz'
import { Quiz } from './Quiz'

interface LessonLayoutProps {
  frontmatter: LessonFrontmatter
  children: React.ReactNode
  quiz?: QuizQuestion[] | null
  nextLessonHref?: string
}
```

**Required render change (after the MDX content div, before closing `</article>`):**
```tsx
{/* MDX lesson content */}
<div className="prose prose-invert max-w-none ...">
  {children}
</div>

{/* Quiz section — rendered when lesson has quiz data */}
{quiz && quiz.length > 0 && (
  <Quiz
    questions={quiz}
    lessonId={lessonId}
    onContinue={nextLessonHref ? () => router.push(nextLessonHref) : undefined}
  />
)}

{/* MarkCompleteButton — only for lessons without quiz */}
{!quiz && <MarkCompleteButton lessonId={lessonId} />}
```

**CRITICAL — Server vs Client boundary:** `LessonLayout` is currently a Server Component (no `'use client'` directive). The `Quiz` component already has `'use client'`. However, `useRouter` is a client-side hook — it cannot be called in `LessonLayout` if it remains a server component.

**Two valid approaches for the `onContinue` handler:**

**Option A (recommended — keep LessonLayout as server component):** Pass `nextLessonHref` as a string prop to `LessonLayout`. Add a thin `'use client'` wrapper component (e.g., `QuizWithNavigation`) that accepts `questions`, `lessonId`, `nextLessonHref` and internally uses `useRouter`. Alternatively, pass `nextLessonHref` directly to `Quiz` and let `Quiz` call `router.push()` internally — but that changes the `Quiz` interface from Phase 13.

**Option B (simplest, lowest risk):** Use a Next.js `Link`-based approach. In `Quiz`'s `QuizPassScreen`, when `onContinue` is undefined and the component needs to navigate, the `onContinue` prop can simply be a `() => window.location.href = nextLessonHref` call handled by a client wrapper. Since `LessonLayout` renders `Quiz` (a `'use client'` component), React can pass a function prop FROM `LessonLayout` TO `Quiz` only if `LessonLayout` is ALSO a client component, or if an intermediate client component is used.

**Resolved approach:** Add `'use client'` to `LessonLayout` (it already uses `lessonId` derived from frontmatter for `MarkCompleteButton` which is itself a client component — but Server Components CAN render Client Components). Actually `LessonLayout` currently does NOT have `'use client'` and renders `MarkCompleteButton` (a client component) fine — Server Components can render Client Components as children/props.

**The actual constraint:** A function prop (`onContinue: () => void`) cannot be passed from a Server Component to a Client Component in Next.js App Router — functions are not serializable across the RSC boundary. The `onContinue` prop must either be absent (Quiz handles navigation internally using `useRouter`) or the entire `LessonLayout` must become a client component.

**Final recommendation:** The cleanest approach that requires the minimum change and zero refactor of Phase 13's `Quiz`:

Create a `components/lesson/QuizSection.tsx` as a `'use client'` wrapper:
```typescript
'use client'
import { useRouter } from 'next/navigation'
import { Quiz } from './Quiz'
import type { QuizQuestion } from '@/types/quiz'

interface QuizSectionProps {
  questions: QuizQuestion[]
  lessonId: string
  nextLessonHref: string
}

export function QuizSection({ questions, lessonId, nextLessonHref }: QuizSectionProps) {
  const router = useRouter()
  return (
    <Quiz
      questions={questions}
      lessonId={lessonId}
      onContinue={() => router.push(nextLessonHref)}
    />
  )
}
```

Then in `LessonLayout` (keeping it as Server Component):
```tsx
{quiz && quiz.length > 0 && (
  <QuizSection
    questions={quiz}
    lessonId={lessonId}
    nextLessonHref={nextLessonHref ?? `/modules/${frontmatter.moduleSlug}`}
  />
)}
```

`questions: QuizQuestion[]` IS serializable (plain objects/arrays/strings/numbers) across the RSC boundary — this approach is fully valid.

### Pattern 4: Test Lesson MDX Named Export

**What:** Add `export const quiz = [...]` to a chosen test lesson MDX file to enable end-to-end validation.

**Which lesson to use:** `content/modules/01-linux-fundamentals/01-how-computers-work.mdx` — it is lesson 1 of the first module, making it easy to navigate to, and it has a clear concept set (CPU, memory, fetch-decode-execute cycle) that supports 3-5 test questions.

**Export format (locked schema from Phase 12):**
```typescript
// In the MDX file, after frontmatter block:
import type { QuizQuestion } from '@/types/quiz'

export const quiz: QuizQuestion[] = [
  {
    id: 'hw-q1',
    question: 'What does the CPU fetch-decode-execute cycle do first?',
    options: ['Decode the instruction', 'Fetch the next instruction from memory', 'Execute the ALU operation', 'Write results to cache'],
    correctIndex: 1,
    explanation: 'The CPU first fetches the next instruction from memory into its instruction register before decoding or executing it.',
  },
  // ... additional questions
]
```

**Note:** MDX files do not need TypeScript type imports to function — `export const quiz = [...]` without the type annotation works at runtime. The type import is optional documentation.

### Anti-Patterns to Avoid
- **Adding `'use client'` to LessonLayout directly:** This would convert the entire layout (including server-only data loading logic) to a client component, breaking static generation patterns. Use the `QuizSection` client wrapper instead.
- **Passing a function prop from LessonLayout (Server Component) directly to Quiz (Client Component):** Functions are not serializable across the RSC boundary in Next.js App Router. This throws a runtime error.
- **Modifying the Quiz component's interface from Phase 13:** The `onContinue?: () => void` prop is already correct. Do not change it. Use the `QuizSection` wrapper to provide the router call.
- **Checking `mod.quiz` without the `Array.isArray` guard:** If a lesson's MDX does not export `quiz`, `mod.quiz` will be `undefined`. The guard `Array.isArray(mod.quiz) ? mod.quiz : null` correctly normalizes both cases.
- **Using `useRouter` in a Server Component:** `useRouter` from `next/navigation` is client-only. Any component calling it must have `'use client'`.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Next lesson URL | Custom routing logic | `getModuleBySlug` + array index math in `page.tsx` | `getModuleBySlug` already returns ordered lessons; one `findIndex` call is all that is needed |
| Quiz state / completion | Any new state management | `Quiz` component from Phase 13 + `markQuizPassed` from `ProgressProvider` | Both are already wired and tested |
| Client navigation after quiz pass | `window.location.href` redirect | `useRouter().push()` in `QuizSection` wrapper | App Router navigation preserves client state and scroll position |
| Named export extraction | Gray-matter or file parsing | `mod.quiz` from the `@next/mdx` dynamic import | Named exports are already compiled into the module object by `@next/mdx` |

---

## Common Pitfalls

### Pitfall 1: RSC Boundary — Passing Functions as Props
**What goes wrong:** Developer adds `onContinue={() => router.push(...)}` directly in `LessonLayout.tsx` (which has no `'use client'`). Next.js throws: "Functions cannot be passed directly to Client Components unless you explicitly expose it by marking it with 'use server' or using it inside a Server Action."
**Why it happens:** `LessonLayout` renders `Quiz` which is a Client Component. Passing a function prop from a Server Component to a Client Component crosses the RSC serialization boundary.
**How to avoid:** Use the `QuizSection` client wrapper to own the `useRouter` call. `LessonLayout` passes only serializable props (`questions`, `lessonId`, `nextLessonHref` as strings/arrays/plain objects).
**Warning signs:** Next.js build/runtime error mentioning "Functions cannot be passed directly to Client Components."

### Pitfall 2: Forgetting the `Array.isArray` Guard in getLessonContent
**What goes wrong:** `mod.quiz` is accessed without checking if it's an array. Lessons without a `quiz` named export return `undefined`. TypeScript may not catch this if the type is declared as `QuizQuestion[] | undefined` and the caller forgets to handle `undefined`.
**Why it happens:** Dynamic import module objects have type `any` for their named exports (beyond `default`).
**How to avoid:** Use `const quiz = Array.isArray(mod.quiz) ? (mod.quiz as QuizQuestion[]) : null` and return type `quiz: QuizQuestion[] | null`.
**Warning signs:** Runtime TypeError when rendering a lesson that does not have a quiz export.

### Pitfall 3: Double "Knowledge Check" Heading
**What goes wrong:** `LessonLayout` renders an `<hr>` and `<h2>Knowledge Check</h2>` before the `Quiz` component. But `Quiz` already renders "Knowledge Check" as its idle state heading. Result: two "Knowledge Check" headings visible.
**Why it happens:** CONTEXT.md mentions "Horizontal rule + 'Knowledge Check' heading separates content from quiz." But `Quiz`'s `QuizStateMachine` idle phase already renders `<h2 className="text-lg font-semibold">Knowledge Check</h2>`.
**How to avoid:** `Quiz` already contains its own "Knowledge Check" heading — do NOT add another in `LessonLayout`. The `Quiz` component wraps itself in `<div className="mt-12 pt-8 border-t border-border">` providing the visual separator. No additional wrapper needed. The `QuizSection` wrapper or LessonLayout needs no extra separator markup.
**Warning signs:** Two "Knowledge Check" text nodes visible in the rendered lesson.

### Pitfall 4: Quiz Renders for cheat-sheet Lessons
**What goes wrong:** Cheat sheet lessons (e.g., `10-cheat-sheet.mdx`) should not have quizzes — they are reference pages. If a future developer accidentally adds a `quiz` export to a cheat sheet MDX file, the quiz renders on that page.
**Why it happens:** The `quiz` prop check in LessonLayout is purely data-driven — if the MDX exports `quiz`, it renders.
**How to avoid:** This is not a Phase 14 concern (Phase 15 handles which lessons get quiz data). Phase 14 just wires the mechanism correctly. The `Array.isArray(quiz) && quiz.length > 0` guard ensures an empty array export also suppresses the Quiz.

### Pitfall 5: Static Params — Build-time vs Runtime
**What goes wrong:** `getModuleBySlug` is called in `page.tsx` which runs at build time (via `generateStaticParams`). If the module's lesson list is empty or the findIndex fails, `nextLessonHref` defaults to `/modules/[moduleSlug]` which is correct.
**Why it happens:** Not actually a problem given the existing data — all modules have lessons. But `currentIdx === -1` edge case should be handled.
**How to avoid:** Use `currentIdx >= 0 && currentIdx < lessons.length - 1` guard when computing `nextLesson`.

---

## Code Examples

### getLessonContent — Updated Signature and Extraction
```typescript
// lib/mdx.ts — verified against current file (lines 47-70)
import type { QuizQuestion } from '@/types/quiz'

export async function getLessonContent(
  moduleSlug: string,
  lessonSlug: string
): Promise<{
  default: React.ComponentType
  frontmatter: LessonFrontmatter
  quiz: QuizQuestion[] | null
} | null> {
  try {
    const mod = await import(`@/content/modules/${moduleSlug}/${lessonSlug}.mdx`)
    const filePath = path.join(process.cwd(), 'content', 'modules', moduleSlug, `${lessonSlug}.mdx`)
    const raw = fs.readFileSync(filePath, 'utf-8')
    const frontmatter = extractFrontmatter(raw)
    const quiz = Array.isArray(mod.quiz) ? (mod.quiz as QuizQuestion[]) : null
    return { default: mod.default as React.ComponentType, frontmatter, quiz }
  } catch {
    return null
  }
}
```

### page.tsx — Quiz Data and Next Lesson Threading
```typescript
// app/modules/[moduleSlug]/[lessonSlug]/page.tsx
import { notFound } from 'next/navigation'
import { getLessonContent } from '@/lib/mdx'
import { getAllLessonPaths, getModuleBySlug } from '@/lib/modules'
import { LessonLayout } from '@/components/lesson/LessonLayout'

interface Props {
  params: Promise<{ moduleSlug: string; lessonSlug: string }>
}

export default async function LessonPage({ params }: Props) {
  const { moduleSlug, lessonSlug } = await params
  const lesson = await getLessonContent(moduleSlug, lessonSlug)
  if (!lesson) notFound()

  const { default: MDXContent, frontmatter, quiz } = lesson

  const mod = getModuleBySlug(moduleSlug)
  const lessons = mod?.lessons ?? []
  const currentIdx = lessons.findIndex((l) => l.slug === lessonSlug)
  const nextLesson = currentIdx >= 0 && currentIdx < lessons.length - 1
    ? lessons[currentIdx + 1]
    : null
  const nextLessonHref = nextLesson
    ? `/modules/${moduleSlug}/${nextLesson.slug}`
    : `/modules/${moduleSlug}`

  return (
    <LessonLayout frontmatter={frontmatter} quiz={quiz} nextLessonHref={nextLessonHref}>
      <MDXContent />
    </LessonLayout>
  )
}

export async function generateStaticParams() {
  return getAllLessonPaths()
}
```

### QuizSection — Client Wrapper Component (new file)
```typescript
// components/lesson/QuizSection.tsx
'use client'
import { useRouter } from 'next/navigation'
import { Quiz } from './Quiz'
import type { QuizQuestion } from '@/types/quiz'

interface QuizSectionProps {
  questions: QuizQuestion[]
  lessonId: string
  nextLessonHref: string
}

export function QuizSection({ questions, lessonId, nextLessonHref }: QuizSectionProps) {
  const router = useRouter()
  return (
    <Quiz
      questions={questions}
      lessonId={lessonId}
      onContinue={() => router.push(nextLessonHref)}
    />
  )
}
```

### LessonLayout — Updated Props and Render
```typescript
// components/lesson/LessonLayout.tsx — updated interface and render
import type { QuizQuestion } from '@/types/quiz'
import { QuizSection } from './QuizSection'

interface LessonLayoutProps {
  frontmatter: LessonFrontmatter
  children: React.ReactNode
  quiz?: QuizQuestion[] | null
  nextLessonHref?: string
}

// In JSX, after {children}, replace the current <MarkCompleteButton>:
{quiz && quiz.length > 0 && (
  <QuizSection
    questions={quiz}
    lessonId={lessonId}
    nextLessonHref={nextLessonHref ?? `/modules/${frontmatter.moduleSlug}`}
  />
)}
{!quiz && <MarkCompleteButton lessonId={lessonId} />}
```

### Test Lesson Quiz Export
```mdx
{/* At the bottom of content/modules/01-linux-fundamentals/01-how-computers-work.mdx */}
{/* After all prose content — named exports can appear anywhere in MDX */}

export const quiz = [
  {
    id: 'hw-q1',
    question: 'Which part of the CPU performs arithmetic operations?',
    options: ['Control Unit', 'Instruction Register', 'Arithmetic/Logic Unit', 'Program Counter'],
    correctIndex: 2,
    explanation: 'The ALU (Arithmetic/Logic Unit) performs arithmetic and logical operations as directed by the control unit.',
  },
  {
    id: 'hw-q2',
    question: 'What is the first step in the fetch-decode-execute cycle?',
    options: ['Decode the instruction', 'Execute the operation', 'Write results to memory', 'Fetch the next instruction from memory'],
    correctIndex: 3,
    explanation: 'The CPU first fetches the next instruction from memory (or cache) into its instruction register.',
  },
  {
    id: 'hw-q3',
    question: 'Why is L1 cache faster than RAM?',
    options: ['It uses flash storage', 'It is physically on the CPU die', 'It has larger capacity', 'It uses a different file system'],
    correctIndex: 1,
    explanation: 'L1 cache is physically located on the CPU die, eliminating the external bus latency that RAM access requires.',
  },
]
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Frontmatter-only MDX metadata | Named exports for structured data (quiz) | Phase 12 decision | Quiz data is typed, co-located with lesson content, extracted from dynamic import module object |
| Manual completion button for all lessons | Conditional completion: quiz-gated or manual | Phase 14 | Lessons with quiz data can only be marked complete by passing the quiz |
| Functions passed as props across RSC boundary | Client wrapper component owns router | Next.js App Router | `QuizSection` wrapper keeps `LessonLayout` as a server component |

**Deprecated/outdated:**
- `getLessonContent` current return type `{ default, frontmatter }` — now `{ default, frontmatter, quiz }` after this phase
- Unconditional `<MarkCompleteButton>` in LessonLayout — now conditional `{!quiz && <MarkCompleteButton>}`

---

## Open Questions

1. **`export const quiz` placement in MDX files**
   - What we know: MDX named exports can appear anywhere in the file (before or after prose content). `@next/mdx` hoists them.
   - What's unclear: Whether placing the export at the bottom (after all prose) causes any remark/rehype plugin issues with `remark-frontmatter` or `rehype-pretty-code`.
   - Recommendation: Place the `export const quiz` at the very bottom of the MDX file, after all prose content, to avoid any potential interaction with remark plugins. Test with the Phase 14 test lesson.

2. **TypeScript type for MDX module in getLessonContent**
   - What we know: `await import(...)` for MDX returns `any`-typed module. Casting `mod.quiz as QuizQuestion[]` after the `Array.isArray` guard is safe.
   - What's unclear: Whether TypeScript will surface any errors for the updated return type at call sites (page.tsx destructuring `quiz`).
   - Recommendation: Add `import type { QuizQuestion } from '@/types/quiz'` to `lib/mdx.ts`. The call site in `page.tsx` will work cleanly since the return type is now explicit.

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Vitest 4.1.0 |
| Config file | `vitest.config.ts` (exists, jsdom environment, `@` alias configured) |
| Quick run command | `npx vitest run lib/__tests__/mdx.test.ts` |
| Full suite command | `npx vitest run` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| LAYOUT-02 | `getLessonContent` returns `quiz: QuizQuestion[]` when MDX exports quiz, `null` when it does not | unit | `npx vitest run lib/__tests__/mdx.test.ts` | ❌ Wave 0 — new test cases needed in existing file |
| LAYOUT-01 | Quiz renders after MDX content in LessonLayout | manual smoke | `npx next dev --webpack -p 8080` → navigate to test lesson | N/A (visual verification) |
| GATE-01 | MarkCompleteButton absent for quiz-enabled lessons; present for non-quiz lessons | manual smoke | `npx next dev --webpack -p 8080` → navigate to two lessons | N/A (visual verification) |

### Sampling Rate
- **Per task commit:** `npx vitest run lib/__tests__/mdx.test.ts`
- **Per wave merge:** `npx vitest run` (full suite)
- **Phase gate:** Full suite green + manual smoke of test lesson end-to-end before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `lib/__tests__/mdx.test.ts` — add two test cases: one for `quiz` extraction when present, one for `null` when absent. Extend existing file (do not create a new one).

---

## Sources

### Primary (HIGH confidence)
- Direct file reads: `lib/mdx.ts`, `components/lesson/LessonLayout.tsx`, `components/lesson/Quiz.tsx`, `app/modules/[moduleSlug]/[lessonSlug]/page.tsx`, `components/progress/ProgressProvider.tsx`, `types/quiz.ts`, `types/progress.ts`, `next.config.ts`
- `/Users/phillipdougherty/learn-systems/node_modules/next/dist/docs/01-app/01-getting-started/05-server-and-client-components.md` — RSC/Client Component boundary rules and serializable props constraint

### Secondary (MEDIUM confidence)
- `@next/mdx` behavior for named exports: documented by the existing comment in `lib/mdx.ts` line 55 ("@next/mdx compiles MDX files at build time. The dynamic import below resolves to the compiled React Server Component.") and confirmed by the existing usage of `mod.default`.

### Tertiary (LOW confidence)
- None

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all existing dependencies, no new packages
- Architecture: HIGH — based on direct codebase reads, confirmed RSC boundary constraint from official Next.js docs
- Pitfalls: HIGH — RSC function serialization pitfall verified from official docs; double-heading pitfall verified by reading Quiz.tsx source
- Test gaps: HIGH — existing test structure confirmed by reading vitest.config.ts and lib/__tests__/mdx.test.ts

**Research date:** 2026-03-22
**Valid until:** 2026-04-22 (stable Next.js and React stack)
