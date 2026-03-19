import MiniSearch from 'minisearch'

export interface SearchDoc {
  id: string          // LessonId: "01-linux-fundamentals/01-how-computers-work"
  title: string
  module: string      // Module display name
  moduleSlug: string  // URL slug
  body: string        // Plain text content (MDX markup stripped)
}

export interface SearchResult {
  id: string
  title: string
  module: string
  moduleSlug: string
  score: number
  match: Record<string, string[]>
}

/**
 * Build a serializable MiniSearch index from lesson documents.
 * Called at build time (server-side only) to generate the search-index JSON.
 */
export function buildSearchIndex(docs: SearchDoc[]): object {
  const index = new MiniSearch<SearchDoc>({
    fields: ['title', 'module', 'body'],
    storeFields: ['title', 'module', 'moduleSlug', 'id'],
    searchOptions: {
      boost: { title: 3, module: 2 },
      fuzzy: 0.2,
      prefix: true,
    },
  })
  index.addAll(docs)
  return index.toJSON()
}

/**
 * Hydrate a MiniSearch instance from serialized JSON (client-side, after lazy fetch).
 */
export function createSearchIndex(serialized: object): MiniSearch<SearchDoc> {
  return MiniSearch.loadJSON<SearchDoc>(JSON.stringify(serialized), {
    fields: ['title', 'module', 'body'],
    storeFields: ['title', 'module', 'moduleSlug', 'id'],
    searchOptions: {
      boost: { title: 3, module: 2 },
      fuzzy: 0.2,
      prefix: true,
    },
  })
}
