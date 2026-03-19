import { notFound } from 'next/navigation'
import { getLessonContent } from '@/lib/mdx'
import { getAllLessonPaths } from '@/lib/modules'
import { LessonLayout } from '@/components/lesson/LessonLayout'

interface Props {
  params: Promise<{ moduleSlug: string; lessonSlug: string }>
}

export default async function LessonPage({ params }: Props) {
  const { moduleSlug, lessonSlug } = await params
  const lesson = await getLessonContent(moduleSlug, lessonSlug)
  if (!lesson) notFound()

  const { default: MDXContent, frontmatter } = lesson

  return (
    <LessonLayout frontmatter={frontmatter}>
      <MDXContent />
    </LessonLayout>
  )
}

export async function generateStaticParams() {
  return getAllLessonPaths()
}
