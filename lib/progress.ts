import type { Module } from '@/types/content'
import type { ProgressState } from '@/types/progress'

/**
 * Returns completion percentage (0-100) for a module based on lesson completion.
 * A lesson is "complete" if progress.lessons[lessonId].completed === true.
 */
export function moduleCompletionPercent(
  module: Module,
  progress: ProgressState
): number {
  if (module.lessons.length === 0) return 0
  const completedCount = module.lessons.filter(
    (lesson) => progress.lessons[lesson.id]?.completed === true
  ).length
  return Math.round((completedCount / module.lessons.length) * 100)
}

/**
 * Returns overall course completion percentage (0-100) across all modules.
 */
export function courseCompletionPercent(
  modules: Module[],
  progress: ProgressState
): number {
  const allLessons = modules.flatMap((m) => m.lessons)
  if (allLessons.length === 0) return 0
  const completedCount = allLessons.filter(
    (lesson) => progress.lessons[lesson.id]?.completed === true
  ).length
  return Math.round((completedCount / allLessons.length) * 100)
}

/**
 * Returns true if all lessons in a module are complete.
 * Used for locked/unlocked prerequisite state.
 */
export function isModuleComplete(
  module: Module,
  progress: ProgressState
): boolean {
  return module.lessons.every(
    (lesson) => progress.lessons[lesson.id]?.completed === true
  )
}
