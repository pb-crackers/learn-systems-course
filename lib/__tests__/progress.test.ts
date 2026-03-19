import { moduleCompletionPercent, courseCompletionPercent, isModuleComplete } from '../progress'
import type { Module } from '@/types/content'
import type { ProgressState } from '@/types/progress'

const makeModule = (lessonIds: string[]): Module => ({
  slug: 'test-module',
  title: 'Test Module',
  description: 'desc',
  order: 1,
  accentColor: 'linux',
  lessons: lessonIds.map((id) => ({
    id,
    slug: id,
    moduleSlug: 'test-module',
    frontmatter: {
      title: id,
      description: '',
      module: 'Test Module',
      moduleSlug: 'test-module',
      lessonSlug: id,
      order: 1,
      difficulty: 'Foundation' as const,
      estimatedMinutes: 20,
      prerequisites: [],
      tags: [],
    },
  })),
})

const makeProgress = (completedIds: string[]): ProgressState => ({
  lessons: Object.fromEntries(
    completedIds.map((id) => [id, { completed: true, exercisesCompleted: [] }])
  ),
  version: 1,
})

describe('moduleCompletionPercent', () => {
  it('returns 0 for empty module', () => {
    expect(moduleCompletionPercent(makeModule([]), makeProgress([]))).toBe(0)
  })

  it('returns 0 when no lessons are complete', () => {
    expect(moduleCompletionPercent(makeModule(['a', 'b', 'c']), makeProgress([]))).toBe(0)
  })

  it('returns 67 when 2 of 3 lessons are complete', () => {
    expect(moduleCompletionPercent(makeModule(['a', 'b', 'c']), makeProgress(['a', 'b']))).toBe(67)
  })

  it('returns 100 when all lessons are complete', () => {
    expect(moduleCompletionPercent(makeModule(['a', 'b', 'c']), makeProgress(['a', 'b', 'c']))).toBe(100)
  })
})

describe('isModuleComplete', () => {
  it('returns false when no lessons complete', () => {
    expect(isModuleComplete(makeModule(['a', 'b']), makeProgress([]))).toBe(false)
  })

  it('returns true when all lessons complete', () => {
    expect(isModuleComplete(makeModule(['a', 'b']), makeProgress(['a', 'b']))).toBe(true)
  })

  it('returns false when only some lessons complete', () => {
    expect(isModuleComplete(makeModule(['a', 'b']), makeProgress(['a']))).toBe(false)
  })
})
