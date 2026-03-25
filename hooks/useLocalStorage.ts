'use client'
import { useState, useEffect, useCallback } from 'react'

/**
 * SSR-safe localStorage hook.
 * Returns [value, setValue, isHydrated].
 * isHydrated is false on first server render and becomes true after client hydration.
 * NEVER call window.localStorage at module scope or during render — only inside useEffect.
 */
export function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(initialValue)
  const [isHydrated, setIsHydrated] = useState(false)

  useEffect(() => {
    try {
      const item = window.localStorage.getItem(key)
      if (item !== null) {
        setStoredValue(JSON.parse(item) as T)
      }
    } catch (err) {
      console.warn(`useLocalStorage: failed to read "${key}"`, err)
    }
    setIsHydrated(true)
  }, [key])

  const setValue = useCallback(
    (value: T | ((prev: T) => T)) => {
      try {
        setStoredValue((current) => {
          const valueToStore =
            value instanceof Function ? value(current) : value
          window.localStorage.setItem(key, JSON.stringify(valueToStore))
          return valueToStore
        })
      } catch (err) {
        console.warn(`useLocalStorage: failed to write "${key}"`, err)
      }
    },
    [key]
  )

  return [storedValue, setValue, isHydrated] as const
}
