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
        const valueToStore =
          value instanceof Function ? value(storedValue) : value
        setStoredValue(valueToStore)
        window.localStorage.setItem(key, JSON.stringify(valueToStore))
      } catch (err) {
        console.warn(`useLocalStorage: failed to write "${key}"`, err)
      }
    },
    [key, storedValue]
  )

  return [storedValue, setValue, isHydrated] as const
}
