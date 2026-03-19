'use client'
import { createContext, useContext, useCallback, type ReactNode } from 'react'
import { useLocalStorage } from '@/hooks/useLocalStorage'
import {
  type ProgressState,
  type LessonId,
  INITIAL_PROGRESS,
  PROGRESS_STORAGE_KEY,
} from '@/types/progress'

interface ProgressContextValue {
  progress: ProgressState
  isHydrated: boolean
  markLessonComplete: (lessonId: LessonId) => void
  markExerciseComplete: (lessonId: LessonId, exerciseId: string) => void
  resetProgress: () => void
}

export const ProgressContext = createContext<ProgressContextValue | null>(null)

export function ProgressProvider({ children }: { children: ReactNode }) {
  const [progress, setProgress, isHydrated] = useLocalStorage<ProgressState>(
    PROGRESS_STORAGE_KEY,
    INITIAL_PROGRESS
  )

  const markLessonComplete = useCallback(
    (lessonId: LessonId) => {
      setProgress((prev) => ({
        ...prev,
        lessons: {
          ...prev.lessons,
          [lessonId]: {
            ...prev.lessons[lessonId],
            completed: true,
            completedAt: new Date().toISOString(),
            exercisesCompleted: prev.lessons[lessonId]?.exercisesCompleted ?? [],
          },
        },
      }))
    },
    [setProgress]
  )

  const markExerciseComplete = useCallback(
    (lessonId: LessonId, exerciseId: string) => {
      setProgress((prev) => {
        const lesson = prev.lessons[lessonId]
        const already = lesson?.exercisesCompleted ?? []
        if (already.includes(exerciseId)) return prev
        return {
          ...prev,
          lessons: {
            ...prev.lessons,
            [lessonId]: {
              ...lesson,
              completed: lesson?.completed ?? false,
              exercisesCompleted: [...already, exerciseId],
            },
          },
        }
      })
    },
    [setProgress]
  )

  const resetProgress = useCallback(() => {
    setProgress(INITIAL_PROGRESS)
    if (typeof window !== 'undefined') {
      window.localStorage.removeItem(PROGRESS_STORAGE_KEY)
    }
  }, [setProgress])

  return (
    <ProgressContext.Provider
      value={{ progress, isHydrated, markLessonComplete, markExerciseComplete, resetProgress }}
    >
      {children}
    </ProgressContext.Provider>
  )
}
