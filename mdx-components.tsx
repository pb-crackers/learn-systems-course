import type { MDXComponents } from 'mdx/types'

// Custom components registered here will be available in all .mdx files.
// Actual components are implemented in Plan 04. Import placeholders for now.
export function useMDXComponents(components: MDXComponents): MDXComponents {
  return {
    ...components,
  }
}
