'use client'
import { useState, useEffect } from 'react'
import { SearchCommand } from './SearchCommand'

/**
 * Mounts the Cmd+K search modal globally.
 * Add <SearchProvider /> once in app/layout.tsx.
 * Listens for Cmd+K (Mac) or Ctrl+K (Windows/Linux) to open the modal.
 */
export function SearchProvider() {
  const [open, setOpen] = useState(false)

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault()
        setOpen((prev) => !prev)
      }
    }
    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [])

  return <SearchCommand open={open} onOpenChange={setOpen} />
}
