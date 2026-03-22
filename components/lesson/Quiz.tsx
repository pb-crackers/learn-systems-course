'use client'
import { useReducer, useEffect, useCallback } from 'react'
import { AlertCircle, Trophy } from 'lucide-react'
import type { QuizQuestion } from '@/types/quiz'
import { useProgress } from '@/hooks/useProgress'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'

// ---------------------------------------------------------------------------
// State machine types — exported for unit testing
// ---------------------------------------------------------------------------

export type QuizMachineState =
  | { phase: 'idle' }
  | { phase: 'active'; currentIndex: number; attempts: number }
  | {
      phase: 'answering'
      currentIndex: number
      attempts: number
      selectedIndex: number
      isCorrect: boolean
      isLast: boolean
    }
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
      return {
        phase: 'active',
        currentIndex: 0,
        attempts: state.phase === 'idle' ? 1 : state.attempts + 1,
      }
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

// ---------------------------------------------------------------------------
// Props
// ---------------------------------------------------------------------------

interface QuizProps {
  questions: QuizQuestion[]
  lessonId: string
  onContinue?: () => void
}

// ---------------------------------------------------------------------------
// Internal sub-components
// ---------------------------------------------------------------------------

interface QuizOptionButtonProps {
  label: string
  index: number
  isSelected: boolean
  isAnswering: boolean
  isCorrect: boolean
  onClick: () => void
}

function QuizOptionButton({ label, index, isSelected, isAnswering, isCorrect, onClick }: QuizOptionButtonProps) {
  const letters = ['A', 'B', 'C', 'D']
  return (
    <button
      onClick={onClick}
      disabled={isAnswering}
      className={cn(
        'w-full text-left border border-border rounded-lg px-4 py-3 text-sm transition-colors',
        isAnswering && isSelected && isCorrect
          ? 'bg-green-500/10 text-green-400 border-green-500/30'
          : 'hover:bg-muted cursor-pointer disabled:cursor-default'
      )}
    >
      <span className="font-medium mr-2">{letters[index]}.</span>
      {label}
    </button>
  )
}

interface QuizQuestionViewProps {
  question: QuizQuestion
  questionNumber: number
  totalQuestions: number
  attempts: number
  isAnswering: boolean
  selectedIndex: number | null
  onSelect: (index: number) => void
}

function QuizQuestionView({
  question,
  questionNumber,
  totalQuestions,
  attempts,
  isAnswering,
  selectedIndex,
  onSelect,
}: QuizQuestionViewProps) {
  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between text-sm text-muted-foreground">
        <span>Question {questionNumber} of {totalQuestions}</span>
        <span>Attempt {attempts}</span>
      </div>
      <p className="text-base font-medium">{question.question}</p>
      <div className="space-y-2">
        {question.options.map((option, i) => (
          <QuizOptionButton
            key={i}
            label={option}
            index={i}
            isSelected={selectedIndex === i}
            isAnswering={isAnswering}
            isCorrect={selectedIndex === i}
            onClick={() => onSelect(i)}
          />
        ))}
      </div>
    </div>
  )
}

interface QuizFeedbackProps {
  isCorrect: boolean
  explanation: string
  isLast: boolean
  onNext: () => void
}

function QuizFeedback({ isCorrect, explanation, isLast, onNext }: QuizFeedbackProps) {
  if (!isCorrect) return null
  return (
    <div className="space-y-3">
      <div className={cn('rounded-lg border px-4 py-3 text-sm', 'bg-green-500/10 text-green-400 border-green-500/30')}>
        <p>{explanation}</p>
      </div>
      <div className="flex justify-end">
        <Button onClick={onNext} variant="default" size="sm">
          {isLast ? 'Finish Quiz' : 'Next Question'}
        </Button>
      </div>
    </div>
  )
}

interface QuizPassScreenProps {
  attempts: number
  onContinue?: () => void
}

function QuizPassScreen({ attempts, onContinue }: QuizPassScreenProps) {
  return (
    <div className={cn('rounded-xl border px-6 py-8 text-center space-y-4', 'bg-green-500/10 border-green-500/30')}>
      <div className="flex justify-center">
        <Trophy className="h-10 w-10 text-green-400" />
      </div>
      <h3 className="text-lg font-semibold">Quiz Complete!</h3>
      <p className="text-sm text-muted-foreground">
        Passed on attempt {attempts}
      </p>
      <Button onClick={onContinue} variant="default" size="default">
        Continue to Next Lesson
      </Button>
    </div>
  )
}

// ---------------------------------------------------------------------------
// Quiz — main exported component
// ---------------------------------------------------------------------------

export function Quiz({ questions, lessonId, onContinue }: QuizProps) {
  const { markQuizPassed, isQuizPassed, isHydrated, progress } = useProgress()

  const [state, dispatch] = useReducer(quizReducer, { phase: 'idle' })

  // Hydration guard — prevents SSR/client mismatch flash
  if (!isHydrated) return null

  // Already-passed: show pass screen immediately (pre-v1.2 bypass)
  if (isQuizPassed(lessonId) && state.phase === 'idle') {
    const savedAttempts = progress.lessons[lessonId]?.quizAttempts ?? 1
    return (
      <div className="mt-12 pt-8 border-t border-border">
        <QuizPassScreen attempts={savedAttempts} onContinue={onContinue} />
      </div>
    )
  }

  return (
    <div className="mt-12 pt-8 border-t border-border">
      <QuizStateMachine
        state={state}
        dispatch={dispatch}
        questions={questions}
        lessonId={lessonId}
        onContinue={onContinue}
        markQuizPassed={markQuizPassed}
      />
    </div>
  )
}

// ---------------------------------------------------------------------------
// QuizStateMachine — renders the correct phase view
// ---------------------------------------------------------------------------

interface QuizStateMachineProps {
  state: QuizMachineState
  dispatch: React.Dispatch<QuizAction>
  questions: QuizQuestion[]
  lessonId: string
  onContinue?: () => void
  markQuizPassed: (lessonId: string) => void
}

function QuizStateMachine({ state, dispatch, questions, lessonId, onContinue, markQuizPassed }: QuizStateMachineProps) {
  // Auto-dismiss failed state after 2 seconds and restart
  useEffect(() => {
    if (state.phase !== 'failed') return
    const id = setTimeout(() => dispatch({ type: 'START' }), 2000)
    return () => clearTimeout(id)
  }, [state.phase, dispatch])

  // Mark quiz passed once when phase transitions to passed
  useEffect(() => {
    if (state.phase !== 'passed') return
    markQuizPassed(lessonId)
  }, [state.phase, lessonId, markQuizPassed])

  if (state.phase === 'idle') {
    return (
      <div className="space-y-4">
        <div>
          <h2 className="text-lg font-semibold">Knowledge Check</h2>
          <p className="text-sm text-muted-foreground mt-1">Test your understanding of this lesson</p>
        </div>
        <Button onClick={() => dispatch({ type: 'START' })} variant="default">
          Start Quiz
        </Button>
      </div>
    )
  }

  if (state.phase === 'active') {
    const question = questions[state.currentIndex]
    return (
      <QuizQuestionView
        question={question}
        questionNumber={state.currentIndex + 1}
        totalQuestions={questions.length}
        attempts={state.attempts}
        isAnswering={false}
        selectedIndex={null}
        onSelect={(i) =>
          dispatch({
            type: 'SELECT_ANSWER',
            selectedIndex: i,
            correctIndex: question.correctIndex,
            isLast: state.currentIndex === questions.length - 1,
          })
        }
      />
    )
  }

  if (state.phase === 'answering') {
    const question = questions[state.currentIndex]
    return (
      <div className="space-y-4">
        <div className="flex items-center justify-between text-sm text-muted-foreground">
          <span>Question {state.currentIndex + 1} of {questions.length}</span>
          <span>Attempt {state.attempts}</span>
        </div>
        <p className="text-base font-medium">{question.question}</p>
        <div className="space-y-2">
          {question.options.map((option, i) => (
            <QuizOptionButton
              key={i}
              label={option}
              index={i}
              isSelected={state.selectedIndex === i}
              isAnswering={true}
              isCorrect={state.isCorrect}
              onClick={() => {}}
            />
          ))}
        </div>
        <QuizFeedback
          isCorrect={state.isCorrect}
          explanation={question.explanation}
          isLast={state.isLast}
          onNext={() => dispatch({ type: 'NEXT_QUESTION' })}
        />
      </div>
    )
  }

  if (state.phase === 'failed') {
    return (
      <div
        className={cn(
          'rounded-lg border px-4 py-3 flex items-center gap-3 text-sm',
          'bg-red-500/10 text-red-400 border-red-500/30'
        )}
      >
        <AlertCircle className="h-4 w-4 shrink-0" />
        <span>Incorrect — quiz will restart from question 1</span>
      </div>
    )
  }

  if (state.phase === 'passed') {
    return <QuizPassScreen attempts={state.attempts} onContinue={onContinue} />
  }

  return null
}
