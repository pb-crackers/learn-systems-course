import type { CommandAnnotation } from '@/types/exercises'

interface AnnotatedCommandProps {
  command: string
  annotations: CommandAnnotation[]
}

export function AnnotatedCommand({ command, annotations }: AnnotatedCommandProps) {
  if (!annotations || annotations.length === 0) return null

  return (
    <div className="rounded-lg border border-border overflow-hidden my-2">
      {/* Command display */}
      <code className="block bg-muted/60 border-b border-border px-3 py-1.5 text-xs font-mono text-foreground">
        {command}
      </code>

      {/* Annotation panel — always visible, never interactive */}
      <div className="bg-muted/20">
        <table className="w-full text-sm">
          <tbody>
            {annotations.map((annotation, i) => (
              <tr
                key={i}
                className="border-b border-border last:border-0"
              >
                <td className="px-3 py-2 font-mono text-xs text-muted-foreground/80 whitespace-nowrap align-top w-1/4">
                  {annotation.token}
                </td>
                <td className="px-3 py-2 align-top">
                  <span className="text-sm text-muted-foreground">{annotation.description}</span>
                  {annotation.example && (
                    <span className="block mt-0.5 text-xs italic text-muted-foreground/70">
                      {annotation.example}
                    </span>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
