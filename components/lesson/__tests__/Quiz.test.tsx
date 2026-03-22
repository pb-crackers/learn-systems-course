import { quizReducer, type QuizMachineState, type QuizAction } from '../Quiz'
import type { QuizQuestion } from '@/types/quiz'

const FIXTURE_QUESTIONS: QuizQuestion[] = [
  {
    id: 'q1',
    question: 'What does ls do?',
    options: ['List files', 'Remove files', 'Copy files', 'Move files'],
    correctIndex: 0,
    explanation: 'ls lists directory contents.',
  },
  {
    id: 'q2',
    question: 'What does cd do?',
    options: ['Copy dir', 'Change dir', 'Create dir', 'Delete dir'],
    correctIndex: 1,
    explanation: 'cd changes the working directory.',
  },
  {
    id: 'q3',
    question: 'What does pwd do?',
    options: ['Print users', 'Print date', 'Print working directory', 'Print disk'],
    correctIndex: 2,
    explanation: 'pwd prints the current working directory.',
  },
]

describe('quizReducer', () => {
  const idle: QuizMachineState = { phase: 'idle' }

  it('START from idle transitions to active with attempts=1', () => {
    const result = quizReducer(idle, { type: 'START' })
    expect(result).toEqual({ phase: 'active', currentIndex: 0, attempts: 1 })
  })

  it('START from failed increments attempts', () => {
    const failed: QuizMachineState = { phase: 'failed', attempts: 2 }
    const result = quizReducer(failed, { type: 'START' })
    expect(result).toEqual({ phase: 'active', currentIndex: 0, attempts: 3 })
  })

  it('SELECT_ANSWER correct on non-last question transitions to answering', () => {
    const active: QuizMachineState = { phase: 'active', currentIndex: 0, attempts: 1 }
    const result = quizReducer(active, {
      type: 'SELECT_ANSWER',
      selectedIndex: 0,
      correctIndex: 0,
      isLast: false,
    })
    expect(result).toEqual({
      phase: 'answering',
      currentIndex: 0,
      attempts: 1,
      selectedIndex: 0,
      isCorrect: true,
      isLast: false,
    })
  })

  it('SELECT_ANSWER correct on last question sets isLast=true', () => {
    const active: QuizMachineState = { phase: 'active', currentIndex: 2, attempts: 1 }
    const result = quizReducer(active, {
      type: 'SELECT_ANSWER',
      selectedIndex: 1,
      correctIndex: 1,
      isLast: true,
    })
    expect(result).toEqual({
      phase: 'answering',
      currentIndex: 2,
      attempts: 1,
      selectedIndex: 1,
      isCorrect: true,
      isLast: true,
    })
  })

  it('SELECT_ANSWER incorrect transitions to failed', () => {
    const active: QuizMachineState = { phase: 'active', currentIndex: 0, attempts: 1 }
    const result = quizReducer(active, {
      type: 'SELECT_ANSWER',
      selectedIndex: 2,
      correctIndex: 0,
      isLast: false,
    })
    expect(result).toEqual({ phase: 'failed', attempts: 1 })
  })

  it('NEXT_QUESTION advances currentIndex', () => {
    const answering: QuizMachineState = {
      phase: 'answering',
      currentIndex: 0,
      attempts: 1,
      selectedIndex: 0,
      isCorrect: true,
      isLast: false,
    }
    const result = quizReducer(answering, { type: 'NEXT_QUESTION' })
    expect(result).toEqual({ phase: 'active', currentIndex: 1, attempts: 1 })
  })

  it('NEXT_QUESTION on isLast transitions to passed', () => {
    const answering: QuizMachineState = {
      phase: 'answering',
      currentIndex: 2,
      attempts: 2,
      selectedIndex: 2,
      isCorrect: true,
      isLast: true,
    }
    const result = quizReducer(answering, { type: 'NEXT_QUESTION' })
    expect(result).toEqual({ phase: 'passed', attempts: 2 })
  })

  it('ignores SELECT_ANSWER when not in active phase', () => {
    const result = quizReducer(idle, {
      type: 'SELECT_ANSWER',
      selectedIndex: 0,
      correctIndex: 0,
      isLast: false,
    })
    expect(result).toEqual(idle)
  })
})

export { FIXTURE_QUESTIONS }
