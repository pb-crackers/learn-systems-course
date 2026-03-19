'use client'
import { CheckCircle2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { useProgress } from '@/hooks/useProgress'
import { cn } from '@/lib/utils'
import type { LessonId } from '@/types/content'

interface MarkCompleteButtonProps {
  lessonId: LessonId
}

export function MarkCompleteButton({ lessonId }: MarkCompleteButtonProps) {
  const { progress, markLessonComplete, isHydrated } = useProgress()
  const isComplete = progress.lessons[lessonId]?.completed === true

  if (!isHydrated) return null  // Prevent hydration flash

  return (
    <div className="mt-12 pt-8 border-t border-border flex justify-end">
      <Button
        onClick={() => !isComplete && markLessonComplete(lessonId)}
        variant={isComplete ? 'outline' : 'default'}
        className={cn(
          'gap-2',
          isComplete && 'text-green-400 border-green-500/30 bg-green-500/5 hover:bg-green-500/5 cursor-default'
        )}
        disabled={isComplete}
      >
        <CheckCircle2 className="h-4 w-4" />
        {isComplete ? 'Lesson Complete' : 'Mark as Complete'}
      </Button>
    </div>
  )
}
