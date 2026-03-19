import fs from 'fs'
import path from 'path'
import matter from 'gray-matter'
import { NextResponse } from 'next/server'
import { buildSearchIndex, type SearchDoc } from '@/lib/search'

export const dynamic = 'force-static' // Pre-render as static JSON at build time

export async function GET() {
  const contentDir = path.join(process.cwd(), 'content', 'modules')
  const docs: SearchDoc[] = []

  const moduleDirs = fs
    .readdirSync(contentDir)
    .filter((entry) =>
      fs.statSync(path.join(contentDir, entry)).isDirectory()
    )

  for (const moduleDir of moduleDirs) {
    const modulePath = path.join(contentDir, moduleDir)
    const lessonFiles = fs
      .readdirSync(modulePath)
      .filter((f) => f.endsWith('.mdx') && !f.startsWith('00-'))

    for (const file of lessonFiles) {
      const raw = fs.readFileSync(path.join(modulePath, file), 'utf-8')
      const { data, content } = matter(raw)

      docs.push({
        id: `${data.moduleSlug}/${data.lessonSlug}`,
        title: data.title as string,
        module: data.module as string,
        moduleSlug: data.moduleSlug as string,
        body: content
          .replace(/<[^>]+>/g, ' ')
          .replace(/\s+/g, ' ')
          .trim(),
      })
    }
  }

  const index = buildSearchIndex(docs)

  return NextResponse.json(index, {
    headers: {
      'Cache-Control': 'public, max-age=3600, stale-while-revalidate=86400',
    },
  })
}
