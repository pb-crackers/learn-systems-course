import { QuickReference } from '@/components/content/QuickReference'
import type { ReferenceSection } from '@/components/content/QuickReference'

interface ChallengeReferenceSheetProps {
  sections: ReferenceSection[]
}

export function ChallengeReferenceSheet({ sections }: ChallengeReferenceSheetProps) {
  if (!sections || sections.length === 0) return null

  return (
    <div className="my-4 rounded-lg border border-red-500/20 bg-red-500/5 p-4">
      <p className="text-sm font-semibold uppercase tracking-wide text-red-400 mb-3">
        Command Reference
      </p>
      <QuickReference sections={sections} className="my-0" />
    </div>
  )
}
