import type { Metadata } from 'next'
import { Inter, JetBrains_Mono } from 'next/font/google'
import { ThemeProvider } from 'next-themes'
import { ProgressProvider } from '@/components/progress/ProgressProvider'
import { AppShell } from '@/components/layout/AppShell'
import { MobileSidebar } from '@/components/layout/MobileSidebar'
import { SearchProvider } from '@/components/search/SearchProvider'
import './globals.css'

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap',
})

const jetbrainsMono = JetBrains_Mono({
  subsets: ['latin'],
  variable: '--font-jetbrains-mono',
  display: 'swap',
})

export const metadata: Metadata = {
  title: 'Learn Systems',
  description: 'Hands-on systems engineering and DevOps course',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={`${inter.variable} ${jetbrainsMono.variable} font-sans antialiased`}>
        <ThemeProvider attribute="class" defaultTheme="dark" enableSystem>
          <ProgressProvider>
            <SearchProvider />
            <AppShell>
              {/* Mobile header bar */}
              <div className="md:hidden flex items-center h-14 px-4 border-b border-border sticky top-0 z-40 bg-background">
                <MobileSidebar />
                <span className="ml-3 text-sm font-semibold">Learn Systems</span>
              </div>
              {children}
            </AppShell>
          </ProgressProvider>
        </ThemeProvider>
      </body>
    </html>
  )
}
