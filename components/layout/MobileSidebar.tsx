'use client'
import { useState } from 'react'
import { Menu } from 'lucide-react'
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet'
import { cn } from '@/lib/utils'

interface MobileSidebarProps {
  children: React.ReactNode
}

export function MobileSidebar({ children }: MobileSidebarProps) {
  const [open, setOpen] = useState(false)

  return (
    <Sheet open={open} onOpenChange={(isOpen) => setOpen(isOpen)}>
      <SheetTrigger
        className={cn(
          'md:hidden inline-flex items-center justify-center rounded-lg border border-transparent',
          'h-8 w-8 hover:bg-muted hover:text-foreground transition-colors',
          'focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50 outline-none'
        )}
        aria-label="Open navigation"
      >
        <Menu className="h-5 w-5" />
      </SheetTrigger>
      <SheetContent side="left" className="w-72 p-0">
        {children}
      </SheetContent>
    </Sheet>
  )
}
