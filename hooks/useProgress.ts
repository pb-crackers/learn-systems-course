'use client'
import { useContext } from 'react'
import { ProgressContext } from '@/components/progress/ProgressProvider'

export function useProgress() {
  const ctx = useContext(ProgressContext)
  if (!ctx) {
    throw new Error('useProgress must be used within a ProgressProvider')
  }
  return ctx
}
