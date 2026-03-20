import type { MDXComponents } from 'mdx/types'
import type { ReactNode } from 'react'
import { CodeBlock } from '@/components/content/CodeBlock'
import { Callout } from '@/components/content/Callout'
import { ExerciseCard } from '@/components/content/ExerciseCard'
import { TerminalBlock } from '@/components/content/TerminalBlock'
import { VerificationChecklist } from '@/components/content/VerificationChecklist'
import { QuickReference } from '@/components/content/QuickReference'
import { AnnotatedCommand } from '@/components/content/AnnotatedCommand'
import { ScenarioQuestion } from '@/components/content/ScenarioQuestion'
import { ChallengeReferenceSheet } from '@/components/content/ChallengeReferenceSheet'

function extractText(node: ReactNode): string {
  if (typeof node === 'string') return node
  if (typeof node === 'number') return String(node)
  if (Array.isArray(node)) return node.map(extractText).join('')
  if (node && typeof node === 'object' && 'props' in node)
    return extractText((node as any).props.children)
  return ''
}

function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '')
}

function Heading({
  level,
  children,
}: {
  level: 2 | 3
  children: ReactNode
}) {
  const text = extractText(children)
  const slug = slugify(text)
  const Tag = `h${level}` as 'h2' | 'h3'
  return (
    <Tag id={slug} className="group relative">
      <a
        href={`#${slug}`}
        className="absolute -left-5 top-0 opacity-0 group-hover:opacity-100 transition-opacity text-muted-foreground"
        aria-hidden="true"
      >
        #
      </a>
      {children}
    </Tag>
  )
}

export function useMDXComponents(components: MDXComponents): MDXComponents {
  return {
    // Map MDX <pre> element to our custom CodeBlock (rehype-pretty-code wraps in <pre>)
    pre: CodeBlock as any,
    // Custom heading components with anchor links
    h2: (props: any) => <Heading level={2} {...props} />,
    h3: (props: any) => <Heading level={3} {...props} />,
    // Named components available in all .mdx files:
    Callout,
    ExerciseCard,
    TerminalBlock,
    VerificationChecklist,
    QuickReference,
    CodeBlock,
    AnnotatedCommand,
    ScenarioQuestion,
    ChallengeReferenceSheet,
    ...components,
  }
}
