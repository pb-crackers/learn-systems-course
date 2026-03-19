import { Sidebar } from './Sidebar'

export function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-screen">
      {/* Desktop sidebar — hidden on mobile */}
      <aside className="hidden md:flex md:w-72 md:flex-col md:fixed md:inset-y-0 md:z-50">
        <Sidebar />
      </aside>
      {/* Main content — offset by sidebar width on desktop */}
      <main className="flex-1 md:ml-72 min-h-screen">
        {children}
      </main>
    </div>
  )
}
