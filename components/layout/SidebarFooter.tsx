'use client'
import { useState } from 'react'
import { RotateCcw, AlertTriangle } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { useProgress } from '@/hooks/useProgress'
import { cn } from '@/lib/utils'

export function SidebarFooter() {
  const { resetProgress } = useProgress()
  const [confirming, setConfirming] = useState(false)

  const handleReset = () => {
    if (!confirming) {
      // First click — enter confirmation state, auto-cancel after 3s
      setConfirming(true)
      setTimeout(() => setConfirming(false), 3000)
      return
    }
    // Second click — confirmed, execute reset
    resetProgress()
    setConfirming(false)
  }

  return (
    <div className="shrink-0">
      <Separator />
      <div className="px-3 py-3">
        <Button
          variant="ghost"
          size="sm"
          onClick={handleReset}
          className={cn(
            'w-full justify-start gap-2 text-xs font-normal h-8',
            confirming
              ? 'text-destructive hover:text-destructive hover:bg-destructive/10'
              : 'text-muted-foreground hover:text-foreground'
          )}
          aria-label={confirming ? 'Click again to confirm progress reset' : 'Reset all progress'}
        >
          {confirming ? (
            <>
              <AlertTriangle className="h-3.5 w-3.5 shrink-0" />
              Click again to confirm
            </>
          ) : (
            <>
              <RotateCcw className="h-3.5 w-3.5 shrink-0" />
              Reset Progress
            </>
          )}
        </Button>
      </div>
    </div>
  )
}
