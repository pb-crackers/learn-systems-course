import { cn } from '@/lib/utils'

interface TerminalLine {
  type: 'command' | 'output' | 'comment'
  content: string
  prompt?: string  // defaults to "$ "
}

interface TerminalBlockProps {
  lines: TerminalLine[]
  title?: string  // optional window title bar text
  className?: string
}

export function TerminalBlock({ lines, title, className }: TerminalBlockProps) {
  return (
    <div className={cn('rounded-lg border border-border overflow-hidden my-4 font-mono text-sm', className)}>
      {/* Terminal title bar */}
      <div className="flex items-center gap-2 px-4 py-2.5 bg-muted/80 border-b border-border">
        <div className="flex gap-1.5">
          <span className="w-3 h-3 rounded-full bg-destructive/60" />
          <span className="w-3 h-3 rounded-full bg-amber-500/60" />
          <span className="w-3 h-3 rounded-full bg-green-500/60" />
        </div>
        {title && (
          <span className="text-xs text-muted-foreground ml-2">{title}</span>
        )}
      </div>
      {/* Terminal content */}
      <div className="bg-[oklch(0.07_0_0)] p-4 space-y-1 overflow-x-auto">
        {lines.map((line, i) => (
          <div key={i} className="flex gap-2">
            {line.type === 'command' && (
              <>
                <span className="text-green-400 shrink-0 select-none">{line.prompt ?? '$ '}</span>
                <span className="text-foreground">{line.content}</span>
              </>
            )}
            {line.type === 'output' && (
              <span className="text-muted-foreground ml-4">{line.content}</span>
            )}
            {line.type === 'comment' && (
              <span className="text-muted-foreground/60 italic"># {line.content}</span>
            )}
          </div>
        ))}
      </div>
    </div>
  )
}
