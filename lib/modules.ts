import fs from 'fs'
import path from 'path'
import matter from 'gray-matter'
import type { Module, Lesson, LessonFrontmatter } from '@/types/content'
import { MODULES } from '@/content/modules/index'

/**
 * Scans the content/modules/<moduleSlug>/ directory for .mdx lesson files,
 * parses frontmatter with gray-matter, and returns typed Lesson objects.
 * Files prefixed with "00-" (templates) are excluded.
 * SERVER-ONLY — uses Node.js fs APIs.
 */
function getLessonsForModule(moduleSlug: string): Lesson[] {
  const moduleDir = path.join(process.cwd(), 'content', 'modules', moduleSlug)

  if (!fs.existsSync(moduleDir)) {
    return []
  }

  const files = fs
    .readdirSync(moduleDir)
    .filter((f) => f.endsWith('.mdx') && !f.startsWith('00-'))
    .sort()

  return files.map((file) => {
    const raw = fs.readFileSync(path.join(moduleDir, file), 'utf-8')
    const { data } = matter(raw)
    const slug = data.lessonSlug as string
    return {
      id: `${moduleSlug}/${slug}`,
      slug,
      moduleSlug,
      frontmatter: data as LessonFrontmatter,
    }
  })
}

export function getAllModules(): Module[] {
  return MODULES.map((mod) => ({
    ...mod,
    lessons: getLessonsForModule(mod.slug),
  }))
}

export function getModuleBySlug(slug: string): Module | undefined {
  const mod = MODULES.find((m) => m.slug === slug)
  if (!mod) return undefined
  return {
    ...mod,
    lessons: getLessonsForModule(mod.slug),
  }
}

/**
 * Returns all lesson paths for Next.js generateStaticParams.
 * Scans all module directories for .mdx lesson files.
 */
export function getAllLessonPaths(): { moduleSlug: string; lessonSlug: string }[] {
  return getAllModules().flatMap((mod) =>
    mod.lessons.map((lesson) => ({
      moduleSlug: mod.slug,
      lessonSlug: lesson.slug,
    }))
  )
}
