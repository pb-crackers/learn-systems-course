import type { MDXComponents } from 'mdx/types'
import { CodeBlock } from '@/components/content/CodeBlock'
import { Callout } from '@/components/content/Callout'
import { ExerciseCard } from '@/components/content/ExerciseCard'
import { TerminalBlock } from '@/components/content/TerminalBlock'
import { VerificationChecklist } from '@/components/content/VerificationChecklist'
import { QuickReference } from '@/components/content/QuickReference'

export function useMDXComponents(components: MDXComponents): MDXComponents {
  return {
    // Map MDX <pre> element to our custom CodeBlock (rehype-pretty-code wraps in <pre>)
    pre: CodeBlock as any,
    // Named components available in all .mdx files:
    Callout,
    ExerciseCard,
    TerminalBlock,
    VerificationChecklist,
    QuickReference,
    ...components,
  }
}
