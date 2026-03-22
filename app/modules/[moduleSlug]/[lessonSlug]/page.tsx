import { notFound } from 'next/navigation'
import { getLessonContent } from '@/lib/mdx'
import { getAllLessonPaths, getModuleBySlug } from '@/lib/modules'
import { LessonLayout } from '@/components/lesson/LessonLayout'

interface Props {
  params: Promise<{ moduleSlug: string; lessonSlug: string }>
}

export default async function LessonPage({ params }: Props) {
  const { moduleSlug, lessonSlug } = await params
  const lesson = await getLessonContent(moduleSlug, lessonSlug)
  if (!lesson) notFound()

  const { default: MDXContent, frontmatter, quiz } = lesson

  const mod = getModuleBySlug(moduleSlug)
  const lessons = mod?.lessons ?? []
  const currentIdx = lessons.findIndex((l) => l.slug === lessonSlug)
  const nextLesson = currentIdx >= 0 && currentIdx < lessons.length - 1
    ? lessons[currentIdx + 1]
    : null
  const nextLessonHref = nextLesson
    ? `/modules/${moduleSlug}/${nextLesson.slug}`
    : `/modules/${moduleSlug}`

  return (
    <LessonLayout frontmatter={frontmatter} quiz={quiz} nextLessonHref={nextLessonHref}>
      <MDXContent />
    </LessonLayout>
  )
}

export async function generateStaticParams() {
  return getAllLessonPaths()
}
