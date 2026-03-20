'use client'
import { useState } from 'react'
import { ChevronDown, ChevronUp, Target } from 'lucide-react'
import { cn } from '@/lib/utils'
import type { Difficulty } from '@/types/content'
import type { ExerciseCardProps, ExerciseStep, ExerciseMode } from '@/types/exercises'
import { DIFFICULTY_MODE_DEFAULT } from '@/types/exercises'
import { useProgress } from '@/hooks/useProgress'
import { AnnotatedCommand } from '@/components/content/AnnotatedCommand'

const DIFFICULTY_CONFIG: Record<Difficulty, { label: string; classes: string }> = {
  Foundation: { label: 'Foundation', classes: 'bg-green-500/10 text-green-400 border-green-500/30' },
  Intermediate: { label: 'Intermediate', classes: 'bg-amber-500/10 text-amber-400 border-amber-500/30' },
  Challenge: { label: 'Challenge', classes: 'bg-red-500/10 text-red-400 border-red-500/30' },
}

function resolveMode(
  difficulty: Difficulty,
  modeProp: ExerciseMode | undefined,
  preferredMode: ExerciseMode | null
): ExerciseMode {
  // Foundation safety net — hard override, skip ALL other checks
  if (difficulty === 'Foundation') {
    return 'guided'
  }

  // Priority 1: explicit mode prop
  if (modeProp) {
    return modeProp
  }

  // Priority 2: learner preference
  if (preferredMode) {
    // 'compose' is not valid for Intermediate — fall back to default
    if (difficulty === 'Intermediate' && preferredMode === 'compose') {
      return DIFFICULTY_MODE_DEFAULT[difficulty]
    }
    return preferredMode
  }

  // Priority 3: difficulty default
  return DIFFICULTY_MODE_DEFAULT[difficulty]
}

export function ExerciseCard({
  title,
  scenario,
  difficulty,
  objective,
  steps = [],
  children,
  mode,
  annotated,
  challengePrompt,
}: ExerciseCardProps) {
  const [open, setOpen] = useState(false)
  const config = DIFFICULTY_CONFIG[difficulty]
  const { preferredMode } = useProgress()
  const effectiveMode = resolveMode(difficulty, mode, preferredMode)

  return (
    <div className="rounded-lg border border-border bg-card my-6 overflow-hidden">
      {/* Card header — always visible */}
      <button
        onClick={() => setOpen((prev) => !prev)}
        className="w-full flex items-start gap-3 px-5 py-4 text-left hover:bg-muted/30 transition-colors"
        aria-expanded={open}
      >
        <Target className="h-5 w-5 mt-0.5 shrink-0 text-muted-foreground" />
        <div className="flex-1 space-y-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap">
            <span className="font-semibold">{title}</span>
            <span className={cn('text-xs px-2 py-0.5 rounded border font-medium', config.classes)}>
              {config.label}
            </span>
          </div>
          <p className="text-sm text-muted-foreground">{scenario}</p>
        </div>
        {open ? (
          <ChevronUp className="h-4 w-4 shrink-0 text-muted-foreground mt-0.5" />
        ) : (
          <ChevronDown className="h-4 w-4 shrink-0 text-muted-foreground mt-0.5" />
        )}
      </button>

      {/* Expanded content */}
      {open && (
        <div className="px-5 pb-5 space-y-4 border-t border-border">
          {/* Objective */}
          <div className="pt-4">
            <p className="text-sm font-medium text-muted-foreground uppercase tracking-wide mb-1">
              Objective
            </p>
            <p className="text-sm">{objective}</p>
          </div>

          {/* Mode-branched content */}
          {effectiveMode === 'guided' && (
            <div>
              <p className="text-sm font-medium text-muted-foreground uppercase tracking-wide mb-3">
                Steps
              </p>
              <ol className="space-y-3">
                {steps.map((s) => (
                  <li key={s.step} className="flex gap-3 text-sm">
                    <span className="flex-shrink-0 w-6 h-6 rounded-full bg-muted flex items-center justify-center text-xs font-medium">
                      {s.step}
                    </span>
                    <div className="flex-1 space-y-1.5 min-w-0">
                      <p>{s.description}</p>
                      {s.command && (
                        annotated && s.annotations && s.annotations.length > 0 ? (
                          <AnnotatedCommand command={s.command} annotations={s.annotations} />
                        ) : (
                          <code className="block bg-muted/60 border border-border px-3 py-1.5 rounded text-xs font-mono text-foreground">
                            {s.command}
                          </code>
                        )
                      )}
                    </div>
                  </li>
                ))}
              </ol>
            </div>
          )}

          {effectiveMode === 'recall' && (
            <div>
              <p className="text-sm font-medium text-muted-foreground uppercase tracking-wide mb-3">
                Steps
              </p>
              <ol className="space-y-3">
                {steps.map((s) => (
                  <li key={s.step} className="flex gap-3 text-sm">
                    <span className="flex-shrink-0 w-6 h-6 rounded-full bg-muted flex items-center justify-center text-xs font-medium">
                      {s.step}
                    </span>
                    <div className="flex-1 min-w-0">
                      <p>{s.description}</p>
                      {/* Commands intentionally omitted — learner must recall syntax */}
                    </div>
                  </li>
                ))}
              </ol>
            </div>
          )}

          {effectiveMode === 'compose' && (
            <div>
              {challengePrompt ? (
                <p className="text-sm leading-relaxed bg-muted/30 rounded-lg p-4 border border-border">
                  {challengePrompt}
                </p>
              ) : (
                /* Backward compat: no challengePrompt — fall back to guided step display */
                <div>
                  <p className="text-sm font-medium text-muted-foreground uppercase tracking-wide mb-3">
                    Steps
                  </p>
                  <ol className="space-y-3">
                    {steps.map((s) => (
                      <li key={s.step} className="flex gap-3 text-sm">
                        <span className="flex-shrink-0 w-6 h-6 rounded-full bg-muted flex items-center justify-center text-xs font-medium">
                          {s.step}
                        </span>
                        <div className="flex-1 space-y-1.5 min-w-0">
                          <p>{s.description}</p>
                          {s.command && (
                            <code className="block bg-muted/60 border border-border px-3 py-1.5 rounded text-xs font-mono text-foreground">
                              {s.command}
                            </code>
                          )}
                        </div>
                      </li>
                    ))}
                  </ol>
                </div>
              )}
            </div>
          )}

          {/* Additional content (verification, hints, reference sheet, etc.) */}
          {children && <div className="border-t border-border pt-4">{children}</div>}
        </div>
      )}
    </div>
  )
}
