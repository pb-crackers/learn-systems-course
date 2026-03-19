import { getAllModules } from '@/lib/modules'
import { SidebarClient } from './SidebarClient'
import { SidebarFooter } from './SidebarFooter'

export async function Sidebar() {
  const modules = getAllModules()
  return (
    <div className="flex flex-col h-full border-r border-border bg-background">
      {/* Logo / course title */}
      <div className="flex items-center h-16 px-6 border-b border-border shrink-0">
        <span className="text-lg font-semibold tracking-tight">Learn Systems</span>
      </div>
      {/* Navigation tree — rendered by client component for interactivity */}
      <SidebarClient modules={modules} />
      {/* Settings footer with reset progress */}
      <SidebarFooter />
    </div>
  )
}
