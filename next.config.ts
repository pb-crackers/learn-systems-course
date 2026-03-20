import createMDX from '@next/mdx'
import remarkGfm from 'remark-gfm'
import remarkFrontmatter from 'remark-frontmatter'
import rehypePrettyCode from 'rehype-pretty-code'

const withMDX = createMDX({
  options: {
    remarkPlugins: [remarkGfm, remarkFrontmatter],
    rehypePlugins: [
      [rehypePrettyCode, {
        theme: 'one-dark-pro',
        keepBackground: false,
      }],
    ],
  },
})

const nextConfig = {
  pageExtensions: ['js', 'jsx', 'md', 'mdx', 'ts', 'tsx'],
  // Disable Turbopack for builds: rehype-pretty-code is incompatible with Turbopack
  // Use `next dev --no-turbopack` for development as well
}

export default withMDX(nextConfig)
