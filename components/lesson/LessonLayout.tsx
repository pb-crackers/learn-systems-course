import type { LessonFrontmatter } from '@/types/content'
import type { QuizQuestion } from '@/types/quiz'
import { ScrollProgressBar } from './ScrollProgressBar'
import { TableOfContents } from './TableOfContents'
import { PrerequisiteBanner } from './PrerequisiteBanner'
import { MarkCompleteButton } from './MarkCompleteButton'
import { DifficultyToggle } from './DifficultyToggle'
import { QuizSection } from './QuizSection'

interface LessonLayoutProps {
  frontmatter: LessonFrontmatter
  children: React.ReactNode
  quiz?: QuizQuestion[] | null
  nextLessonHref?: string
}

export function LessonLayout({ frontmatter, children, quiz, nextLessonHref }: LessonLayoutProps) {
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
          <div className="mb-10 space-y-4 border-b border-border pb-6">
            <h1 className="text-4xl font-bold tracking-tight leading-tight">{frontmatter.title}</h1>
            <p className="text-muted-foreground text-lg">{frontmatter.description}</p>
            <div className="flex items-center gap-4 text-sm text-muted-foreground">
              <span className="flex items-center gap-1.5">
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-muted-foreground"><circle cx="12" cy="12" r="10" /><polyline points="12 6 12 12 16 14" /></svg>
                {frontmatter.estimatedMinutes} min read
              </span>
              <span>·</span>
              <span
                className={`px-2.5 py-0.5 rounded-full text-xs font-medium ${
                  frontmatter.difficulty === 'Foundation'
                    ? 'text-green-400 bg-green-400/10'
                    : frontmatter.difficulty === 'Intermediate'
                      ? 'text-amber-400 bg-amber-400/10'
                      : 'text-red-400 bg-red-400/10'
                }`}
              >
                {frontmatter.difficulty}
              </span>
            </div>
            {frontmatter.difficulty === 'Challenge' && (
              <div className="flex items-center gap-2">
                <span className="text-xs text-muted-foreground">Mode:</span>
                <DifficultyToggle />
              </div>
            )}
          </div>

          {/* Prerequisites banner — shows warning if prerequisites not complete */}
          <PrerequisiteBanner prerequisites={frontmatter.prerequisites} />

          {/* MDX lesson content with prose styling */}
          <div className="prose prose-invert max-w-none [&_pre]:my-0 prose-p:leading-7 prose-p:mb-5 prose-headings:scroll-mt-20">
            {children}
          </div>

          {/* Quiz section (quiz-enabled lessons) or mark complete button (non-quiz lessons) */}
          {quiz && quiz.length > 0 && (
            <QuizSection
              questions={quiz}
              lessonId={lessonId}
              nextLessonHref={nextLessonHref ?? `/modules/${frontmatter.moduleSlug}`}
            />
          )}
          {!quiz && <MarkCompleteButton lessonId={lessonId} />}
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
