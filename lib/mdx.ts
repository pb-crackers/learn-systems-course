import fs from 'fs'
import path from 'path'
import matter from 'gray-matter'
import readingTime from 'reading-time'
import type { LessonFrontmatter } from '@/types/content'

const REQUIRED_FRONTMATTER_FIELDS: (keyof LessonFrontmatter)[] = [
  'title', 'description', 'module', 'moduleSlug', 'lessonSlug', 'order',
  'difficulty', 'estimatedMinutes', 'prerequisites', 'tags',
]

/**
 * Parse MDX frontmatter string and return typed LessonFrontmatter.
 * Throws on missing required fields.
 * SERVER-ONLY — never import in client components (uses Node.js APIs indirectly via gray-matter).
 */
export function extractFrontmatter(mdxContent: string): LessonFrontmatter {
  const { data } = matter(mdxContent)

  for (const field of REQUIRED_FRONTMATTER_FIELDS) {
    if (data[field] === undefined || data[field] === null) {
      throw new Error(`Missing required frontmatter field: ${field}`)
    }
  }

  return data as LessonFrontmatter
}

/**
 * Returns estimated reading time string (e.g., "5 min read") for MDX content.
 */
export function getReadingTime(mdxContent: string): string {
  const { data: _, content } = matter(mdxContent)
  return readingTime(content).text
}

/**
 * Load a lesson's MDX module (compiled React component) and frontmatter.
 * Returns null if the lesson file does not exist.
 *
 * Usage: const { default: MDXContent, frontmatter } = await getLessonContent(moduleSlug, lessonSlug)
 *
 * NOTE: @next/mdx compiles MDX files at build time. The dynamic import below resolves to
 * the compiled React Server Component. Frontmatter must be exported from the MDX file
 * OR extracted via gray-matter from the raw file.
 */
export async function getLessonContent(
  moduleSlug: string,
  lessonSlug: string
): Promise<{ default: React.ComponentType; frontmatter: LessonFrontmatter } | null> {
  try {
    // Dynamic import of compiled MDX module (provides the React component)
    const mod = await import(`@/content/modules/${moduleSlug}/${lessonSlug}.mdx`)

    // @next/mdx does not export frontmatter — read it from the raw file via gray-matter
    const filePath = path.join(
      process.cwd(),
      'content',
      'modules',
      moduleSlug,
      `${lessonSlug}.mdx`
    )
    const raw = fs.readFileSync(filePath, 'utf-8')
    const frontmatter = extractFrontmatter(raw)

    return { default: mod.default as React.ComponentType, frontmatter }
  } catch {
    return null
  }
}
