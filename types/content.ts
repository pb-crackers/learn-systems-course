export type ModuleSlug = string  // e.g., "01-linux-fundamentals"
export type LessonSlug = string  // e.g., "01-how-computers-work"
export type LessonId = string    // e.g., "01-linux-fundamentals/01-how-computers-work"
export type Difficulty = 'Foundation' | 'Intermediate' | 'Challenge'

export interface LessonFrontmatter {
  title: string
  description: string
  module: string
  moduleSlug: ModuleSlug
  lessonSlug: LessonSlug
  order: number
  difficulty: Difficulty
  estimatedMinutes: number
  prerequisites: LessonId[]
  tags: string[]
}

export interface Lesson {
  id: LessonId
  frontmatter: LessonFrontmatter
  slug: LessonSlug
  moduleSlug: ModuleSlug
}

export interface Module {
  slug: ModuleSlug
  title: string
  description: string
  order: number
  accentColor: string  // CSS variable suffix, e.g., "linux" for var(--color-module-linux)
  lessons: Lesson[]
}
