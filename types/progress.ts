export type LessonId = string  // e.g., "01-linux-fundamentals/01-how-computers-work"

export interface LessonProgress {
  completed: boolean
  completedAt?: string  // ISO date string
  exercisesCompleted: string[]  // exercise IDs completed within this lesson
}

export interface ProgressState {
  lessons: Record<LessonId, LessonProgress>
  version: number
}

export const INITIAL_PROGRESS: ProgressState = {
  lessons: {},
  version: 1,
}

export const PROGRESS_STORAGE_KEY = 'learn-systems-progress'
