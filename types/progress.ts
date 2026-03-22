export type LessonId = string  // e.g., "01-linux-fundamentals/01-how-computers-work"

export interface LessonProgress {
  completed: boolean
  completedAt?: string  // ISO date string
  exercisesCompleted: string[]  // exercise IDs completed within this lesson
  // v1.2 additions — optional so pre-v1.2 localStorage records remain valid
  quizPassed?: boolean
  quizPassedAt?: string
  quizAttempts?: number
}

export interface ProgressState {
  lessons: Record<LessonId, LessonProgress>
  version: number
}

export const INITIAL_PROGRESS: ProgressState = {
  lessons: {},
  version: 2,
}

export const PROGRESS_STORAGE_KEY = 'learn-systems-progress'
