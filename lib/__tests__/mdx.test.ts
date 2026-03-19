import { extractFrontmatter, getReadingTime } from '../mdx'

const validMDX = `---
title: "How Computers Work"
description: "CPU, memory, storage"
module: "Linux Fundamentals"
moduleSlug: "01-linux-fundamentals"
lessonSlug: "01-how-computers-work"
order: 1
difficulty: "Foundation"
estimatedMinutes: 25
prerequisites: []
tags: ["hardware", "cpu"]
---

# How Computers Work

This is the lesson body content.
`

describe('extractFrontmatter', () => {
  it('parses valid frontmatter', () => {
    const fm = extractFrontmatter(validMDX)
    expect(fm.title).toBe('How Computers Work')
    expect(fm.moduleSlug).toBe('01-linux-fundamentals')
    expect(fm.difficulty).toBe('Foundation')
    expect(fm.estimatedMinutes).toBe(25)
    expect(Array.isArray(fm.prerequisites)).toBe(true)
    expect(Array.isArray(fm.tags)).toBe(true)
  })

  it('throws on missing required field', () => {
    const mdxMissingTitle = validMDX.replace('title: "How Computers Work"\n', '')
    expect(() => extractFrontmatter(mdxMissingTitle)).toThrow(
      'Missing required frontmatter field: title'
    )
  })

  it('throws on missing estimatedMinutes', () => {
    const mdx = validMDX.replace('estimatedMinutes: 25\n', '')
    expect(() => extractFrontmatter(mdx)).toThrow(
      'Missing required frontmatter field: estimatedMinutes'
    )
  })
})

describe('getReadingTime', () => {
  it('returns a string containing "read"', () => {
    const result = getReadingTime(validMDX)
    expect(typeof result).toBe('string')
    expect(result).toMatch(/read/)
  })
})
