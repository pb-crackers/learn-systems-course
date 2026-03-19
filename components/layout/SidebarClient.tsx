'use client'
import { useState } from 'react'
import Link from 'next/link'
import { ChevronDown, ChevronRight, Lock, CheckCircle2 } from 'lucide-react'
import { cn } from '@/lib/utils'
import { useProgress } from '@/hooks/useProgress'
import { moduleCompletionPercent, isModuleComplete } from '@/lib/progress'
import type { Module } from '@/types/content'

interface SidebarClientProps {
  modules: Module[]
}

export function SidebarClient({ modules }: SidebarClientProps) {
  const { progress, isHydrated } = useProgress()
  const [expanded, setExpanded] = useState<Record<string, boolean>>({
    // First module open by default
    [modules[0]?.slug ?? '']: true,
  })

  // A module is "unlocked" if it is the first module OR the preceding module is complete
  const isModuleUnlocked = (index: number): boolean => {
    if (index === 0) return true
    return isModuleComplete(modules[index - 1], progress)
  }

  return (
    <nav className="flex-1 overflow-y-auto py-4 px-3 space-y-1">
      {modules.map((mod, index) => {
        const isOpen = expanded[mod.slug] ?? false
        const unlocked = isModuleUnlocked(index)
        const pct = isHydrated ? moduleCompletionPercent(mod, progress) : null

        return (
          <div key={mod.slug}>
            {/* Module section header */}
            <button
              onClick={() => setExpanded((prev) => ({ ...prev, [mod.slug]: !isOpen }))}
              className={cn(
                'w-full flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium',
                'hover:bg-muted/60 transition-colors text-left',
                !unlocked && 'opacity-50 cursor-not-allowed'
              )}
              disabled={!unlocked}
              aria-expanded={isOpen}
            >
              {/* Module accent dot */}
              <span
                className="w-2 h-2 rounded-full shrink-0"
                style={{ backgroundColor: `var(--color-module-${mod.accentColor})` }}
              />
              <span className="flex-1 truncate">
                {mod.order}. {mod.title}
              </span>
              {/* Progress or lock indicator */}
              {!unlocked ? (
                <Lock className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
              ) : pct === 100 ? (
                <CheckCircle2
                  className="h-3.5 w-3.5 shrink-0"
                  style={{ color: `var(--color-module-${mod.accentColor})` }}
                />
              ) : pct !== null ? (
                <span className="text-xs text-muted-foreground shrink-0">{pct}%</span>
              ) : (
                <span className="text-xs text-muted-foreground/40 shrink-0">—</span>
              )}
              {unlocked && (
                isOpen
                  ? <ChevronDown className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
                  : <ChevronRight className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
              )}
            </button>

            {/* Lesson list (expandable) */}
            {isOpen && unlocked && (
              <div className="ml-7 mt-0.5 space-y-0.5">
                {mod.lessons.length === 0 ? (
                  <p className="text-xs text-muted-foreground px-3 py-1 italic">
                    Coming soon...
                  </p>
                ) : (
                  mod.lessons.map((lesson) => {
                    const lessonProgress = progress.lessons[lesson.id]
                    const isComplete = lessonProgress?.completed === true
                    return (
                      <Link
                        key={lesson.id}
                        href={`/modules/${lesson.moduleSlug}/${lesson.slug}`}
                        className={cn(
                          'flex items-center gap-2 px-3 py-1.5 rounded-md text-sm',
                          'hover:bg-muted/60 transition-colors text-muted-foreground hover:text-foreground',
                          isComplete && 'text-foreground'
                        )}
                      >
                        {isComplete ? (
                          <CheckCircle2 className="h-3.5 w-3.5 shrink-0 text-green-400" />
                        ) : (
                          <span className="w-3.5 h-3.5 shrink-0 rounded-full border border-muted-foreground/40" />
                        )}
                        <span className="truncate">{lesson.frontmatter.title}</span>
                      </Link>
                    )
                  })
                )}
              </div>
            )}
          </div>
        )
      })}
    </nav>
  )
}
