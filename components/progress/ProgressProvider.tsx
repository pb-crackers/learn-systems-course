'use client'
import { createContext, useCallback, type ReactNode } from 'react'
import { useLocalStorage } from '@/hooks/useLocalStorage'
import {
  type ProgressState,
  type LessonId,
  INITIAL_PROGRESS,
  PROGRESS_STORAGE_KEY,
} from '@/types/progress'
import {
  type ExerciseMode,
  type PreferencesState,
  PREFERENCES_STORAGE_KEY,
  INITIAL_PREFERENCES,
} from '@/types/exercises'

interface ProgressContextValue {
  progress: ProgressState
  isHydrated: boolean
  markLessonComplete: (lessonId: LessonId) => void
  markExerciseComplete: (lessonId: LessonId, exerciseId: string) => void
  resetProgress: () => void
  preferredMode: ExerciseMode | null
  setPreferredMode: (mode: ExerciseMode | null) => void
}

export const ProgressContext = createContext<ProgressContextValue | null>(null)

export function ProgressProvider({ children }: { children: ReactNode }) {
  const [progress, setProgress, progressHydrated] = useLocalStorage<ProgressState>(
    PROGRESS_STORAGE_KEY,
    INITIAL_PROGRESS
  )
  const [preferences, setPreferences, prefsHydrated] = useLocalStorage<PreferencesState>(
    PREFERENCES_STORAGE_KEY,
    INITIAL_PREFERENCES
  )

  const isHydrated = progressHydrated && prefsHydrated

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

  const setPreferredMode = useCallback(
    (mode: ExerciseMode | null) => {
      setPreferences((prev) => ({ ...prev, preferredMode: mode }))
    },
    [setPreferences]
  )

  return (
    <ProgressContext.Provider
      value={{
        progress,
        isHydrated,
        markLessonComplete,
        markExerciseComplete,
        resetProgress,
        preferredMode: preferences.preferredMode,
        setPreferredMode,
      }}
    >
      {children}
    </ProgressContext.Provider>
  )
}
