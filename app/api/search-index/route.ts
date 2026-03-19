import { NextResponse } from 'next/server'
import { buildSearchIndex, type SearchDoc } from '@/lib/search'
// NOTE: When Phase 2+ adds MDX content, this route will dynamically scan
// content/modules/**/*.mdx with gray-matter and build the real index.
// For Phase 1, return an empty but valid index.

export const dynamic = 'force-static'  // Pre-render as static JSON at build time

export async function GET() {
  // Phase 1: empty corpus — no lesson files exist yet.
  // Phase 2+: scan content/modules/**/*.mdx, extract frontmatter + body text.
  const docs: SearchDoc[] = []
  const index = buildSearchIndex(docs)

  return NextResponse.json(index, {
    headers: {
      'Cache-Control': 'public, max-age=3600, stale-while-revalidate=86400',
    },
  })
}
