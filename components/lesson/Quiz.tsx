'use client'
import { useReducer } from 'react'

// Exported for testing
export type QuizMachineState =
  | { phase: 'idle' }
  | { phase: 'active'; currentIndex: number; attempts: number }
  | { phase: 'answering'; currentIndex: number; attempts: number; selectedIndex: number; isCorrect: boolean; isLast: boolean }
  | { phase: 'failed'; attempts: number }
  | { phase: 'passed'; attempts: number }

export type QuizAction =
  | { type: 'START' }
  | { type: 'SELECT_ANSWER'; selectedIndex: number; correctIndex: number; isLast: boolean }
  | { type: 'NEXT_QUESTION' }

export function quizReducer(state: QuizMachineState, action: QuizAction): QuizMachineState {
  switch (action.type) {
    case 'START':
      if (state.phase !== 'idle' && state.phase !== 'failed') return state
      return { phase: 'active', currentIndex: 0, attempts: state.phase === 'idle' ? 1 : state.attempts + 1 }
    case 'SELECT_ANSWER':
      if (state.phase !== 'active') return state
      if (action.selectedIndex === action.correctIndex) {
        return {
          phase: 'answering',
          currentIndex: state.currentIndex,
          attempts: state.attempts,
          selectedIndex: action.selectedIndex,
          isCorrect: true,
          isLast: action.isLast,
        }
      }
      return { phase: 'failed', attempts: state.attempts }
    case 'NEXT_QUESTION':
      if (state.phase !== 'answering') return state
      if (state.isLast) return { phase: 'passed', attempts: state.attempts }
      return { phase: 'active', currentIndex: state.currentIndex + 1, attempts: state.attempts }
    default:
      return state
  }
}

// Placeholder — Task 2 fills this in
export function Quiz() {
  return <div />
}
