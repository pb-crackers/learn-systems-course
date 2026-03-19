'use client'
import type { Module } from '@/types/content'
import { useProgress } from '@/hooks/useProgress'
import { courseCompletionPercent, moduleCompletionPercent } from '@/lib/progress'
import { Progress } from '@/components/ui/progress'
import { cn } from '@/lib/utils'

export function CourseDashboard({ modules }: { modules: Module[] }) {
  const { progress, isHydrated } = useProgress()
  const overallPct = isHydrated ? courseCompletionPercent(modules, progress) : 0

  return (
    <div className="max-w-4xl mx-auto px-6 py-12 space-y-10">
      {/* Header */}
      <div className="space-y-2">
        <h1 className="text-3xl font-bold tracking-tight">Learn Systems</h1>
        <p className="text-muted-foreground text-lg leading-relaxed">
          Hands-on systems engineering and DevOps — from Linux fundamentals to production monitoring.
        </p>
      </div>

      {/* Overall progress */}
      {isHydrated && (
        <div className="rounded-xl border border-border bg-card p-6 space-y-3">
          <div className="flex items-center justify-between">
            <span className="text-sm font-medium">Overall Progress</span>
            <span className="text-sm font-semibold tabular-nums">{overallPct}%</span>
          </div>
          <Progress value={overallPct} className="h-2" />
          <p className="text-xs text-muted-foreground">
            {overallPct === 0
              ? 'Start with Linux Fundamentals below'
              : overallPct === 100
                ? 'Course complete — congratulations!'
                : `${modules.filter((m) => moduleCompletionPercent(m, progress) === 100).length} of ${modules.length} modules complete`}
          </p>
        </div>
      )}

      {/* Module grid — 2 columns on sm+, 1 on mobile */}
      <div className="grid gap-4 sm:grid-cols-2">
        {modules.map((mod, index) => {
          const modPct = isHydrated ? moduleCompletionPercent(mod, progress) : 0
          const isUnlocked = index === 0 || moduleCompletionPercent(modules[index - 1], progress) === 100

          return (
            <div
              key={mod.slug}
              className={cn(
                'group relative rounded-xl border bg-card p-5 space-y-3 transition-colors',
                isUnlocked
                  ? 'border-border hover:border-border/80 hover:bg-card/80 cursor-default'
                  : 'border-border/40 opacity-60'
              )}
              style={
                isUnlocked && modPct > 0
                  ? { borderColor: `color-mix(in oklch, var(--color-module-${mod.accentColor}) 30%, var(--border))` }
                  : undefined
              }
            >
              {/* Module accent bar */}
              <div
                className="absolute top-0 left-0 right-0 h-0.5 rounded-t-xl"
                style={{
                  backgroundColor: isUnlocked
                    ? `var(--color-module-${mod.accentColor})`
                    : 'transparent',
                  opacity: modPct > 0 ? 1 : 0.35,
                }}
              />

              <div className="flex items-start justify-between gap-2 pt-1">
                <div className="flex items-center gap-2">
                  <span
                    className="w-2.5 h-2.5 rounded-full shrink-0 mt-0.5"
                    style={{ backgroundColor: `var(--color-module-${mod.accentColor})` }}
                  />
                  <span className="text-xs font-medium text-muted-foreground uppercase tracking-wide">
                    Module {mod.order}
                  </span>
                </div>
                {isHydrated && modPct > 0 && (
                  <span
                    className="text-xs font-semibold tabular-nums"
                    style={{ color: `var(--color-module-${mod.accentColor})` }}
                  >
                    {modPct}%
                  </span>
                )}
              </div>

              <div className="space-y-1">
                <h2 className="font-semibold leading-tight">{mod.title}</h2>
                <p className="text-xs text-muted-foreground leading-relaxed">{mod.description}</p>
              </div>

              <div className="flex items-center justify-between text-xs text-muted-foreground">
                <span>
                  {mod.lessons.length === 0 ? 'Coming soon' : `${mod.lessons.length} lessons`}
                </span>
                {!isUnlocked && (
                  <span className="flex items-center gap-1 text-muted-foreground/60">
                    <svg className="h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}>
                      <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                      <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                    </svg>
                    Locked
                  </span>
                )}
              </div>

              {/* Per-module progress bar */}
              {isHydrated && isUnlocked && modPct > 0 && modPct < 100 && (
                <div
                  className="h-1 rounded-full bg-muted overflow-hidden"
                >
                  <div
                    className="h-full rounded-full transition-all duration-500"
                    style={{
                      width: `${modPct}%`,
                      backgroundColor: `var(--color-module-${mod.accentColor})`,
                    }}
                  />
                </div>
              )}
            </div>
          )
        })}
      </div>
    </div>
  )
}
