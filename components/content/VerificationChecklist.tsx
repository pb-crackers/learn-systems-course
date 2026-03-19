'use client'
import { useState } from 'react'
import { CheckCircle2, XCircle, ChevronDown } from 'lucide-react'
import { cn } from '@/lib/utils'

interface ChecklistItem {
  id: string
  label: string
  hint?: string  // expandable hint shown on click
}

interface VerificationChecklistProps {
  items: ChecklistItem[]
  title?: string
}

export function VerificationChecklist({ items, title = 'Verification' }: VerificationChecklistProps) {
  const [checked, setChecked] = useState<Record<string, boolean>>({})
  const [expandedHints, setExpandedHints] = useState<Record<string, boolean>>({})

  const toggle = (id: string) =>
    setChecked((prev) => ({ ...prev, [id]: !prev[id] }))
  const toggleHint = (id: string) =>
    setExpandedHints((prev) => ({ ...prev, [id]: !prev[id] }))

  const allChecked = items.length > 0 && items.every((item) => checked[item.id])

  return (
    <div className="rounded-lg border border-border bg-card p-4 my-4 space-y-3">
      <div className="flex items-center justify-between">
        <p className="text-sm font-semibold">{title}</p>
        {allChecked && (
          <span className="text-xs text-green-400 font-medium">All complete</span>
        )}
      </div>
      <ul className="space-y-2">
        {items.map((item) => (
          <li key={item.id}>
            <div className="flex items-start gap-2">
              <button
                onClick={() => toggle(item.id)}
                className="mt-0.5 shrink-0"
                aria-label={checked[item.id] ? 'Mark incomplete' : 'Mark complete'}
              >
                {checked[item.id] ? (
                  <CheckCircle2 className="h-4 w-4 text-green-400" />
                ) : (
                  <XCircle className="h-4 w-4 text-muted-foreground" />
                )}
              </button>
              <div className="flex-1 min-w-0">
                <p
                  className={cn(
                    'text-sm cursor-pointer select-none',
                    checked[item.id] && 'line-through text-muted-foreground'
                  )}
                  onClick={() => toggle(item.id)}
                >
                  {item.label}
                </p>
                {item.hint && (
                  <button
                    onClick={() => toggleHint(item.id)}
                    className="flex items-center gap-1 text-xs text-muted-foreground hover:text-foreground mt-0.5"
                  >
                    <ChevronDown
                      className={cn('h-3 w-3 transition-transform', expandedHints[item.id] && 'rotate-180')}
                    />
                    Hint
                  </button>
                )}
                {item.hint && expandedHints[item.id] && (
                  <p className="text-xs text-muted-foreground mt-1 pl-2 border-l-2 border-border">
                    {item.hint}
                  </p>
                )}
              </div>
            </div>
          </li>
        ))}
      </ul>
    </div>
  )
}
