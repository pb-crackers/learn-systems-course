'use client'
import { useState } from 'react'
import { HelpCircle, ChevronDown } from 'lucide-react'
import { cn } from '@/lib/utils'

interface ScenarioQuestionProps {
  question: string
  answer: string
}

export function ScenarioQuestion({ question, answer }: ScenarioQuestionProps) {
  const [expanded, setExpanded] = useState(false)

  if (!question) return null

  return (
    <div className="my-4 rounded-lg border border-border/50 bg-muted/10 px-4 py-3 border-l-4 border-l-violet-500/60">
      <div className="flex items-center gap-2 mb-2">
        <HelpCircle className="h-4 w-4 text-violet-400 shrink-0" />
        <span className="text-sm font-semibold text-violet-400">Think About It</span>
      </div>
      <p className="text-sm leading-relaxed">{question}</p>
      <button
        onClick={() => setExpanded((prev) => !prev)}
        className="flex items-center gap-1 text-xs text-muted-foreground hover:text-foreground mt-2"
        aria-expanded={expanded}
      >
        <ChevronDown
          className={cn('h-3 w-3 transition-transform', expanded && 'rotate-180')}
        />
        {expanded ? 'Hide Answer' : 'Show Answer'}
      </button>
      {expanded && (
        <p className="mt-2 pl-3 border-l-2 border-border text-sm text-muted-foreground">
          {answer}
        </p>
      )}
    </div>
  )
}
