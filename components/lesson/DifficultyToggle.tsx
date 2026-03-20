'use client'
import { useProgress } from '@/hooks/useProgress'

export function DifficultyToggle() {
  const { preferredMode, setPreferredMode } = useProgress()

  // Guided is active only when preferredMode is explicitly 'guided'
  // null (use difficulty default) or any other value means Challenge (compose) is active
  const isGuided = preferredMode === 'guided'

  return (
    <div className="inline-flex items-center rounded-lg border border-border bg-muted/30 p-0.5 text-xs">
      <button
        type="button"
        onClick={() => setPreferredMode('guided')}
        className={`px-3 py-1 rounded-md transition-colors font-medium ${
          isGuided
            ? 'bg-background text-foreground shadow-sm'
            : 'text-muted-foreground hover:text-foreground'
        }`}
        aria-pressed={isGuided}
      >
        Guided
      </button>
      <button
        type="button"
        onClick={() => setPreferredMode(null)}
        className={`px-3 py-1 rounded-md transition-colors font-medium ${
          !isGuided
            ? 'bg-background text-foreground shadow-sm'
            : 'text-muted-foreground hover:text-foreground'
        }`}
        aria-pressed={!isGuided}
      >
        Challenge
      </button>
    </div>
  )
}
