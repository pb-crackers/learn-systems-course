import { cn } from '@/lib/utils'

export interface ReferenceItem {
  command: string
  description: string
  example?: string
}

interface ReferenceSection {
  title: string
  items: ReferenceItem[]
}

interface QuickReferenceProps {
  sections?: ReferenceSection[]
  title?: string
  children?: React.ReactNode
  className?: string
}

export function QuickReference({ sections, title, children, className }: QuickReferenceProps) {
  // When used with markdown table children instead of structured sections prop
  if (!sections || sections.length === 0) {
    return (
      <div className={cn('space-y-4 my-8', className)}>
        {title && (
          <h3 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
            {title}
          </h3>
        )}
        <div className="rounded-lg border border-border overflow-hidden p-4 prose prose-invert prose-sm max-w-none">
          {children}
        </div>
      </div>
    )
  }

  return (
    <div className={cn('space-y-6 my-8', className)}>
      {sections.map((section) => (
        <div key={section.title}>
          <h3 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground mb-3">
            {section.title}
          </h3>
          <div className="rounded-lg border border-border overflow-hidden">
            <table className="w-full text-sm">
              <tbody>
                {section.items.map((item, i) => (
                  <tr
                    key={i}
                    className={cn('border-b border-border last:border-0', i % 2 === 0 && 'bg-muted/20')}
                  >
                    <td className="px-4 py-2.5 font-mono text-xs whitespace-nowrap align-top w-1/3">
                      {item.command}
                    </td>
                    <td className="px-4 py-2.5 text-muted-foreground align-top">
                      <div>{item.description}</div>
                      {item.example && (
                        <code className="mt-1 block text-xs text-muted-foreground/70 font-mono">
                          {item.example}
                        </code>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      ))}
    </div>
  )
}

export type { ReferenceSection }
