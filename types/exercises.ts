import type { Difficulty } from './content'

/** Rendering mode for an exercise — determines what content is shown */
export type ExerciseMode = 'guided' | 'recall' | 'compose'

/** A single flag/argument annotation for a CLI command */
export interface CommandAnnotation {
  /** The flag or argument being annotated, e.g., "-l", "--recursive", "." */
  token: string
  /** Plain-prose explanation of what this token does. Max 120 characters. No special characters (no backticks, curly braces, angle brackets, or unescaped quotes). */
  description: string
  /** Optional concrete example value, e.g., "Lists files in long format" */
  example?: string
}

/**
 * Extended exercise step with optional annotation support.
 * All new fields are OPTIONAL — existing MDX files with {step, description, command?} continue to work.
 */
export interface ExerciseStep {
  step: number
  description: string
  command?: string
  /** Per-flag annotations co-located with the step. Only used when annotations are authored for this step. */
  annotations?: CommandAnnotation[]
}

/** Props for the v1.1 ExerciseCard component */
export interface ExerciseCardProps {
  title: string
  scenario: string
  difficulty: Difficulty
  objective: string
  steps: ExerciseStep[]
  children?: React.ReactNode
  /** Explicit mode override — takes precedence over learner preference and difficulty default.
   *  Use for pedagogy-critical cases: first encounter with a command (always guided),
   *  or capstone exercises (always compose). */
  mode?: ExerciseMode
  /** Per-exercise opt-in gate for annotations. When false/undefined, annotation UI is hidden
   *  even if annotations data exists. Prevents partially-annotated modules from showing empty UI.
   *  Remove this prop after full annotation coverage is achieved. */
  annotated?: boolean
  /** Challenge-mode prompt — the overall goal shown instead of step list when mode is 'compose'. */
  challengePrompt?: string
}

/** Mode resolution: explicit mode prop > learner preferredMode > difficulty default */
export const DIFFICULTY_MODE_DEFAULT: Record<Difficulty, ExerciseMode> = {
  Foundation: 'guided',
  Intermediate: 'recall',
  Challenge: 'compose',
}

/**
 * Foundation safety net: Foundation exercises ALWAYS resolve to 'guided'
 * regardless of learner preference. This is enforced in ExerciseCard, not here.
 * This constant documents the rule for implementers.
 */
export const FOUNDATION_SAFETY_NET = true

// --- Preference types ---

export const PREFERENCES_STORAGE_KEY = 'learn-systems-preferences'

export interface PreferencesState {
  /** Learner's preferred exercise mode. null = use difficulty default. */
  preferredMode: ExerciseMode | null
  version: number
}

export const INITIAL_PREFERENCES: PreferencesState = {
  preferredMode: null,
  version: 1,
}
