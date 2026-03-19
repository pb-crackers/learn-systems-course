'use client'
import { useState } from 'react'
import { Check, Copy } from 'lucide-react'
import { cn } from '@/lib/utils'

interface CodeBlockProps {
  children: React.ReactNode
  'data-language'?: string    // injected by rehype-pretty-code
  'data-filename'?: string    // from MDX meta string: ```bash filename="deploy.sh"
  className?: string
}

export function CodeBlock({ children, className, ...props }: CodeBlockProps) {
  const [copied, setCopied] = useState(false)
  const language = props['data-language']
  const filename = props['data-filename']

  const handleCopy = async () => {
    // Extract text content from the pre element
    const container = document.querySelector('[data-copy-target]')
    const text = container?.textContent ?? ''
    try {
      await navigator.clipboard.writeText(text)
      setCopied(true)
      setTimeout(() => setCopied(false), 2000)
    } catch {
      // Clipboard API not available — silently ignore
    }
  }

  return (
    <div className={cn('group relative rounded-lg border border-border bg-muted/40 overflow-hidden my-4', className)}>
      {(filename || language) && (
        <div className="flex items-center justify-between px-4 py-2 border-b border-border bg-muted/60">
          <span className="text-xs font-mono text-muted-foreground">
            {filename ?? language}
          </span>
          <button
            onClick={handleCopy}
            className="flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground transition-colors p-1 rounded"
            aria-label={copied ? 'Copied' : 'Copy code'}
          >
            {copied ? (
              <><Check className="h-3.5 w-3.5 text-green-400" /><span>Copied</span></>
            ) : (
              <><Copy className="h-3.5 w-3.5" /><span>Copy</span></>
            )}
          </button>
        </div>
      )}
      {!filename && !language && (
        <button
          onClick={handleCopy}
          className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity p-1.5 rounded bg-muted hover:bg-muted/80"
          aria-label={copied ? 'Copied' : 'Copy code'}
        >
          {copied ? <Check className="h-3.5 w-3.5 text-green-400" /> : <Copy className="h-3.5 w-3.5" />}
        </button>
      )}
      <pre className={cn('overflow-x-auto p-4 text-sm font-mono', className)} data-copy-target>
        {children}
      </pre>
    </div>
  )
}
