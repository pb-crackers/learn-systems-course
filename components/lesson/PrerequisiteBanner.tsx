'use client'
import Link from 'next/link'
import { AlertTriangle, CheckCircle2 } from 'lucide-react'
import { useProgress } from '@/hooks/useProgress'
import type { LessonId } from '@/types/content'
import { cn } from '@/lib/utils'

interface PrerequisiteBannerProps {
  prerequisites: LessonId[]
  // Map of lessonId → { title, moduleSlug, lessonSlug } for building links
  // In Phase 1, prerequisites array is always [] so this rarely renders
  prerequisiteDetails?: Record<LessonId, { title: string; moduleSlug: string; lessonSlug: string }>
}

export function PrerequisiteBanner({ prerequisites, prerequisiteDetails }: PrerequisiteBannerProps) {
  const { progress, isHydrated } = useProgress()

  if (prerequisites.length === 0) return null

  const incomplete = prerequisites.filter(
    (id) => !progress.lessons[id]?.completed
  )

  if (isHydrated && incomplete.length === 0) {
    // All prerequisites complete — show green success banner
    return (
      <div className="flex items-center gap-2 rounded-lg border border-green-500/30 bg-green-500/5 px-4 py-3 mb-6 text-sm">
        <CheckCircle2 className="h-4 w-4 text-green-400 shrink-0" />
        <span className="text-green-400">All prerequisites complete</span>
      </div>
    )
  }

  return (
    <div className={cn(
      'rounded-lg border px-4 py-3 mb-6 text-sm space-y-2',
      isHydrated && incomplete.length > 0
        ? 'border-amber-500/30 bg-amber-500/5'
        : 'border-border bg-muted/30'  // not yet hydrated
    )}>
      <div className="flex items-center gap-2">
        <AlertTriangle className="h-4 w-4 text-amber-400 shrink-0" />
        <span className="font-medium">Prerequisites</span>
      </div>
      <ul className="space-y-1 ml-6">
        {prerequisites.map((id) => {
          const detail = prerequisiteDetails?.[id]
          const isComplete = progress.lessons[id]?.completed === true
          return (
            <li key={id} className="flex items-center gap-2">
              {isComplete ? (
                <CheckCircle2 className="h-3.5 w-3.5 text-green-400 shrink-0" />
              ) : (
                <span className="w-3.5 h-3.5 rounded-full border border-muted-foreground/40 shrink-0" />
              )}
              {detail ? (
                <Link
                  href={`/modules/${detail.moduleSlug}/${detail.lessonSlug}`}
                  className="hover:underline text-muted-foreground hover:text-foreground"
                >
                  {detail.title}
                </Link>
              ) : (
                <span className="text-muted-foreground">{id}</span>
              )}
            </li>
          )
        })}
      </ul>
    </div>
  )
}
