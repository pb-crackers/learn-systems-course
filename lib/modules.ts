import type { Module } from '@/types/content'
import { MODULES } from '@/content/modules/index'

// Returns MODULES with empty lessons arrays (lessons populated by Phases 2-7).
// During Phase 1, lessons arrays are always empty — the sidebar shows module placeholders.
export function getAllModules(): Module[] {
  return MODULES.map((mod) => ({ ...mod, lessons: [] }))
}

export function getModuleBySlug(slug: string): Module | undefined {
  const mod = MODULES.find((m) => m.slug === slug)
  if (!mod) return undefined
  return { ...mod, lessons: [] }
}

// Returns all lesson paths for Next.js generateStaticParams.
// Returns empty array until Phase 2+ adds lesson .mdx files.
export function getAllLessonPaths(): { moduleSlug: string; lessonSlug: string }[] {
  // Will be populated dynamically in Phase 2 when MDX files exist:
  // const lessonFiles = glob.sync('content/modules/**/*.mdx')
  // For Phase 1, return empty array.
  return []
}
