# Deferred Items — Phase 13 Quiz Component Build

## Pre-existing Issues (Out of Scope)

### tsconfig vitest globals missing

**Found during:** Task 2 TypeScript check
**Scope:** Pre-existing — affects all test files (`lib/__tests__/progress.test.ts`, `lib/__tests__/search.test.ts`, and new `components/lesson/__tests__/Quiz.test.tsx`)
**Issue:** `tsconfig.json` does not include `"types": ["vitest/globals"]`, causing `describe`, `it`, `expect`, `vi` to be unresolved by `tsc --noEmit`. Tests run fine via Vitest (which injects globals separately). No errors in `components/lesson/Quiz.tsx` itself.
**Recommendation:** Add `"types": ["vitest/globals"]` to `compilerOptions.types` in `tsconfig.json`, or add a separate `tsconfig.test.json` that extends root config and adds vitest types.
