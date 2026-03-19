'use client'
import { useState, useEffect, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { Search } from 'lucide-react'
import {
  Command,
  CommandDialog,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from '@/components/ui/command'
import { createSearchIndex, type SearchDoc } from '@/lib/search'
import type MiniSearch from 'minisearch'

interface SearchResult {
  id: string
  title: string
  module: string
  moduleSlug: string
  score: number
}

interface SearchCommandProps {
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function SearchCommand({ open, onOpenChange }: SearchCommandProps) {
  const router = useRouter()
  const [query, setQuery] = useState('')
  const [results, setResults] = useState<SearchResult[]>([])
  const [index, setIndex] = useState<MiniSearch<SearchDoc> | null>(null)
  const [loading, setLoading] = useState(false)

  // Lazy-load the search index the first time the modal opens.
  // NEVER load in SSR or on page load — index JSON can be large.
  useEffect(() => {
    if (!open || index) return  // Already loaded or modal closed
    setLoading(true)
    fetch('/api/search-index')
      .then((res) => res.json())
      .then((json) => {
        setIndex(createSearchIndex(json))
      })
      .catch(console.error)
      .finally(() => setLoading(false))
  }, [open, index])

  useEffect(() => {
    if (!index || !query.trim()) {
      setResults([])
      return
    }
    const rawResults = index.search(query)
    setResults(rawResults as unknown as SearchResult[])
  }, [query, index])

  const handleSelect = useCallback(
    (lessonId: string, moduleSlug: string) => {
      const [, lessonSlug] = lessonId.split('/')
      router.push(`/modules/${moduleSlug}/${lessonSlug}`)
      onOpenChange(false)
      setQuery('')
    },
    [router, onOpenChange]
  )

  return (
    <CommandDialog open={open} onOpenChange={onOpenChange} title="Search lessons" description="Search all course content">
      <Command>
        <CommandInput
          placeholder="Search lessons..."
          value={query}
          onValueChange={setQuery}
        />
        <CommandList>
          {loading && (
            <div className="py-6 text-center text-sm text-muted-foreground">
              Loading search index...
            </div>
          )}
          {!loading && query && (
            <CommandEmpty>No lessons found for &ldquo;{query}&rdquo;</CommandEmpty>
          )}
          {!loading && results.length > 0 && (
            <CommandGroup heading="Lessons">
              {results.slice(0, 10).map((result) => (
                <CommandItem
                  key={result.id}
                  value={result.id}
                  onSelect={() => handleSelect(result.id, result.moduleSlug)}
                  className="flex items-start gap-3 py-3"
                >
                  <Search className="h-4 w-4 mt-0.5 shrink-0 text-muted-foreground" />
                  <div className="flex flex-col gap-0.5 min-w-0">
                    <span className="font-medium truncate">{result.title}</span>
                    <span className="text-xs text-muted-foreground truncate">{result.module}</span>
                  </div>
                </CommandItem>
              ))}
            </CommandGroup>
          )}
          {!loading && !query && (
            <div className="py-6 text-center text-sm text-muted-foreground">
              Type to search all lessons...
            </div>
          )}
        </CommandList>
      </Command>
    </CommandDialog>
  )
}
