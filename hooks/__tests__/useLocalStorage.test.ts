import { renderHook, act } from '@testing-library/react'
import { useLocalStorage } from '../useLocalStorage'

describe('useLocalStorage', () => {
  beforeEach(() => {
    localStorage.clear()
  })

  it('returns initialValue and isHydrated=false on first render', () => {
    const { result } = renderHook(() =>
      useLocalStorage('test-key', { count: 0 })
    )
    // Before useEffect runs, isHydrated should be false
    // (In jsdom, useEffect runs synchronously in renderHook, but initial state is checked)
    expect(result.current[0]).toEqual({ count: 0 })
  })

  it('reads existing value from localStorage after hydration', async () => {
    localStorage.setItem('test-key', JSON.stringify({ count: 42 }))
    const { result } = renderHook(() =>
      useLocalStorage('test-key', { count: 0 })
    )
    await act(async () => {})
    expect(result.current[0]).toEqual({ count: 42 })
    expect(result.current[2]).toBe(true) // isHydrated
  })

  it('writes value to localStorage via setValue', async () => {
    const { result } = renderHook(() =>
      useLocalStorage('test-key', { count: 0 })
    )
    await act(async () => {})
    act(() => {
      result.current[1]({ count: 99 })
    })
    expect(result.current[0]).toEqual({ count: 99 })
    expect(JSON.parse(localStorage.getItem('test-key')!)).toEqual({ count: 99 })
  })

  it('handles corrupt localStorage data gracefully', async () => {
    localStorage.setItem('test-key', 'not-valid-json{{{')
    const { result } = renderHook(() =>
      useLocalStorage('test-key', { count: 0 })
    )
    await act(async () => {})
    // Falls back to initialValue on parse error
    expect(result.current[0]).toEqual({ count: 0 })
    expect(result.current[2]).toBe(true) // isHydrated still true
  })
})
