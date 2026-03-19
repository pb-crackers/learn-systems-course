import { cn } from '@/lib/utils'
import { AlertCircle, Lightbulb, Microscope } from 'lucide-react'

type CalloutType = 'tip' | 'warning' | 'deep-dive'

interface CalloutProps {
  type: CalloutType
  title?: string
  children: React.ReactNode
}

const CONFIG: Record<CalloutType, { icon: typeof Lightbulb; classes: string; defaultTitle: string }> = {
  tip: {
    icon: Lightbulb,
    classes: 'border-l-green-500 bg-green-500/5',
    defaultTitle: 'Tip',
  },
  warning: {
    icon: AlertCircle,
    classes: 'border-l-amber-500 bg-amber-500/5',
    defaultTitle: 'Warning',
  },
  'deep-dive': {
    icon: Microscope,
    classes: 'border-l-blue-500 bg-blue-500/5',
    defaultTitle: 'Under the Hood',
  },
}

export function Callout({ type, title, children }: CalloutProps) {
  const { icon: Icon, classes, defaultTitle } = CONFIG[type]
  return (
    <div className={cn('my-6 border-l-4 px-4 py-3 rounded-r-lg', classes)}>
      <div className="flex items-center gap-2 mb-2">
        <Icon className="h-4 w-4 shrink-0" />
        <span className="text-sm font-semibold">{title ?? defaultTitle}</span>
      </div>
      <div className="text-sm [&>p]:mb-2 [&>p:last-child]:mb-0">{children}</div>
    </div>
  )
}
