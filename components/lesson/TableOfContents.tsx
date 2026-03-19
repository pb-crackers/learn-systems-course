'use client'
import { useEffect, useState } from 'react'
import { cn } from '@/lib/utils'

interface TocEntry {
  id: string
  text: string
  level: 2 | 3
}

export function TableOfContents() {
  const [entries, setEntries] = useState<TocEntry[]>([])
  const [active, setActive] = useState<string>('')

  useEffect(() => {
    // Extract headings from the article element in the DOM after render
    const article = document.querySelector('article')
    if (!article) return

    const headings = Array.from(article.querySelectorAll('h2, h3')) as HTMLHeadingElement[]
    const toc: TocEntry[] = headings.map((h) => ({
      id: h.id,
      text: h.textContent ?? '',
      level: parseInt(h.tagName[1]) as 2 | 3,
    })).filter((e) => e.id)
    setEntries(toc)
  }, [])

  useEffect(() => {
    if (entries.length === 0) return
    const observer = new IntersectionObserver(
      (obs) => {
        for (const entry of obs) {
          if (entry.isIntersecting) {
            setActive(entry.target.id)
            break
          }
        }
      },
      { rootMargin: '-20% 0% -70% 0%' }
    )
    entries.forEach((e) => {
      const el = document.getElementById(e.id)
      if (el) observer.observe(el)
    })
    return () => observer.disconnect()
  }, [entries])

  if (entries.length < 3) return null  // Not enough headings to warrant a ToC

  return (
    <nav aria-label="Table of contents" className="space-y-1">
      <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground mb-2">
        On this page
      </p>
      {entries.map((entry) => (
        <a
          key={entry.id}
          href={`#${entry.id}`}
          className={cn(
            'block text-sm transition-colors truncate',
            entry.level === 3 && 'ml-3',
            active === entry.id
              ? 'text-foreground font-medium'
              : 'text-muted-foreground hover:text-foreground'
          )}
        >
          {entry.text}
        </a>
      ))}
    </nav>
  )
}
