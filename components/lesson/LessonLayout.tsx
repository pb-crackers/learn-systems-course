import type { LessonFrontmatter } from '@/types/content'
import { ScrollProgressBar } from './ScrollProgressBar'
import { TableOfContents } from './TableOfContents'
import { PrerequisiteBanner } from './PrerequisiteBanner'
import { MarkCompleteButton } from './MarkCompleteButton'

interface LessonLayoutProps {
  frontmatter: LessonFrontmatter
  children: React.ReactNode
}

export function LessonLayout({ frontmatter, children }: LessonLayoutProps) {
  const lessonId = `${frontmatter.moduleSlug}/${frontmatter.lessonSlug}`

  return (
    <>
      <ScrollProgressBar />
      <div className="flex gap-8 max-w-5xl mx-auto px-6 py-10">
        {/* Main lesson content */}
        <article className="flex-1 min-w-0">
          {/* Breadcrumb */}
          <div className="mb-6 text-sm text-muted-foreground">
            <span>{frontmatter.module}</span>
            <span className="mx-2">›</span>
            <span className="text-foreground">{frontmatter.title}</span>
          </div>

          {/* Lesson header */}
          <div className="mb-8 space-y-3">
            <h1 className="text-3xl font-bold tracking-tight">{frontmatter.title}</h1>
            <p className="text-muted-foreground text-lg">{frontmatter.description}</p>
            <div className="flex items-center gap-4 text-sm text-muted-foreground">
              <span>{frontmatter.estimatedMinutes} min read</span>
              <span>·</span>
              <span
                className={
                  frontmatter.difficulty === 'Foundation'
                    ? 'text-green-400'
                    : frontmatter.difficulty === 'Intermediate'
                      ? 'text-amber-400'
                      : 'text-red-400'
                }
              >
                {frontmatter.difficulty}
              </span>
            </div>
          </div>

          {/* Prerequisites banner — shows warning if prerequisites not complete */}
          <PrerequisiteBanner prerequisites={frontmatter.prerequisites} />

          {/* MDX lesson content with prose styling */}
          <div className="prose prose-invert max-w-none [&_pre]:my-0">
            {children}
          </div>

          {/* Mark complete button at lesson bottom */}
          <MarkCompleteButton lessonId={lessonId} />
        </article>

        {/* Sticky sidebar: ToC on desktop */}
        <aside className="hidden lg:block w-56 shrink-0">
          <div className="sticky top-10">
            <TableOfContents />
          </div>
        </aside>
      </div>
    </>
  )
}
