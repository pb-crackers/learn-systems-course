'use client'
import { useRouter } from 'next/navigation'
import { Quiz } from './Quiz'
import type { QuizQuestion } from '@/types/quiz'

interface QuizSectionProps {
  questions: QuizQuestion[]
  lessonId: string
  nextLessonHref: string
}

export function QuizSection({ questions, lessonId, nextLessonHref }: QuizSectionProps) {
  const router = useRouter()
  return (
    <Quiz
      questions={questions}
      lessonId={lessonId}
      onContinue={() => router.push(nextLessonHref)}
    />
  )
}
