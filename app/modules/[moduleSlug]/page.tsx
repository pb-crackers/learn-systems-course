import { notFound } from 'next/navigation'
import { getModuleBySlug, getAllModules } from '@/lib/modules'
import Link from 'next/link'

interface Props {
  params: Promise<{ moduleSlug: string }>
}

export default async function ModulePage({ params }: Props) {
  const { moduleSlug } = await params
  const mod = getModuleBySlug(moduleSlug)
  if (!mod) notFound()

  return (
    <div className="max-w-3xl mx-auto px-6 py-10 space-y-6">
      <div className="space-y-2">
        <div className="flex items-center gap-2">
          <span
            className="w-3 h-3 rounded-full"
            style={{ backgroundColor: `var(--color-module-${mod.accentColor})` }}
          />
          <span className="text-sm text-muted-foreground">Module {mod.order}</span>
        </div>
        <h1 className="text-3xl font-bold tracking-tight">{mod.title}</h1>
        <p className="text-muted-foreground">{mod.description}</p>
      </div>

      {mod.lessons.length === 0 ? (
        <p className="text-muted-foreground italic">Lessons coming soon...</p>
      ) : (
        <div className="space-y-2">
          {mod.lessons.map((lesson) => (
            <Link
              key={lesson.id}
              href={`/modules/${moduleSlug}/${lesson.slug}`}
              className="block rounded-lg border border-border bg-card p-4 hover:bg-muted/40 transition-colors"
            >
              <div className="font-medium">{lesson.frontmatter.title}</div>
              <div className="text-sm text-muted-foreground mt-1">{lesson.frontmatter.description}</div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}

export async function generateStaticParams() {
  const modules = getAllModules()
  return modules.map((mod) => ({ moduleSlug: mod.slug }))
}
