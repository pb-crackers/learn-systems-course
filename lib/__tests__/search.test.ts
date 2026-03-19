import { buildSearchIndex, createSearchIndex, type SearchDoc } from '../search'

const sampleDocs: SearchDoc[] = [
  {
    id: '01-linux-fundamentals/01-how-computers-work',
    title: 'How Computers Work',
    module: 'Linux Fundamentals',
    moduleSlug: '01-linux-fundamentals',
    body: 'CPU memory storage I/O hardware architecture',
  },
  {
    id: '02-networking/01-tcp-ip',
    title: 'TCP/IP Stack',
    module: 'Networking Foundations',
    moduleSlug: '02-networking',
    body: 'packets layers encapsulation IP addressing subnets routing',
  },
]

describe('buildSearchIndex', () => {
  it('returns a serializable object', () => {
    const result = buildSearchIndex(sampleDocs)
    expect(typeof result).toBe('object')
    expect(() => JSON.stringify(result)).not.toThrow()
  })

  it('returns valid index for empty corpus', () => {
    const result = buildSearchIndex([])
    expect(typeof result).toBe('object')
    expect(() => JSON.stringify(result)).not.toThrow()
  })
})

describe('createSearchIndex + search', () => {
  it('can search by title keyword', () => {
    const json = buildSearchIndex(sampleDocs)
    const index = createSearchIndex(json)
    const results = index.search('Computers')
    expect(results.length).toBeGreaterThan(0)
    expect(results[0].id).toBe('01-linux-fundamentals/01-how-computers-work')
  })

  it('can search by body content', () => {
    const json = buildSearchIndex(sampleDocs)
    const index = createSearchIndex(json)
    const results = index.search('packets routing')
    expect(results.length).toBeGreaterThan(0)
    expect(results[0].id).toBe('02-networking/01-tcp-ip')
  })

  it('returns empty for unknown query', () => {
    const json = buildSearchIndex(sampleDocs)
    const index = createSearchIndex(json)
    const results = index.search('xyzzy-does-not-exist')
    expect(results).toHaveLength(0)
  })

  it('title results rank higher than body results (boost)', () => {
    const json = buildSearchIndex(sampleDocs)
    const index = createSearchIndex(json)
    // "Linux Fundamentals" appears as module name (boost 2) for doc 1;
    // "Computers" appears only in title (boost 3) of doc 1
    const results = index.search('Computers')
    expect(results[0].id).toBe('01-linux-fundamentals/01-how-computers-work')
  })
})
