import { notFound } from 'next/navigation'
import { getLessonContent } from '@/lib/mdx'
import { getAllLessonPaths } from '@/lib/modules'

interface Props {
  params: Promise<{ moduleSlug: string; lessonSlug: string }>
}

export default async function LessonPage({ params }: Props) {
  const { moduleSlug, lessonSlug } = await params
  const lesson = await getLessonContent(moduleSlug, lessonSlug)
  if (!lesson) notFound()

  const { default: MDXContent, frontmatter } = lesson

  return (
    <article className="max-w-3xl mx-auto px-6 py-10">
      {/* Lesson header — LessonLayout component added in Plan 04 */}
      <div className="mb-8 space-y-2">
        <h1 className="text-3xl font-bold tracking-tight">{frontmatter.title}</h1>
        <p className="text-muted-foreground">{frontmatter.description}</p>
        <div className="flex items-center gap-3 text-sm text-muted-foreground">
          <span>{frontmatter.estimatedMinutes} min read</span>
          <span>·</span>
          <span>{frontmatter.difficulty}</span>
        </div>
      </div>
      {/* MDX content rendered as React Server Component */}
      <div className="prose prose-invert max-w-none">
        <MDXContent />
      </div>
    </article>
  )
}

export async function generateStaticParams() {
  // Returns empty in Phase 1; populated when MDX lesson files are added in Phase 2+
  return getAllLessonPaths()
}
