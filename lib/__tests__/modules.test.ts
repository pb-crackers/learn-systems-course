import { getAllModules, getModuleBySlug, getAllLessonPaths } from '../modules'

describe('getAllModules', () => {
  it('returns exactly 8 modules', () => {
    expect(getAllModules()).toHaveLength(8)
  })

  it('returns modules in correct order', () => {
    const modules = getAllModules()
    expect(modules[0].slug).toBe('01-linux-fundamentals')
    expect(modules[7].slug).toBe('08-monitoring')
  })

  it('each module has required fields', () => {
    const modules = getAllModules()
    for (const mod of modules) {
      expect(mod.slug).toBeTruthy()
      expect(mod.title).toBeTruthy()
      expect(mod.accentColor).toBeTruthy()
      expect(typeof mod.order).toBe('number')
      expect(Array.isArray(mod.lessons)).toBe(true)
    }
  })

  it('accentColor values match CSS variable suffixes', () => {
    const modules = getAllModules()
    const validColors = ['linux', 'networking', 'docker', 'sysadmin', 'cicd', 'iac', 'cloud', 'monitoring']
    for (const mod of modules) {
      expect(validColors).toContain(mod.accentColor)
    }
  })
})

describe('getModuleBySlug', () => {
  it('returns module for valid slug', () => {
    const mod = getModuleBySlug('01-linux-fundamentals')
    expect(mod).toBeDefined()
    expect(mod?.title).toBe('Linux Fundamentals')
    expect(mod?.accentColor).toBe('linux')
  })

  it('returns undefined for unknown slug', () => {
    expect(getModuleBySlug('99-nonexistent')).toBeUndefined()
  })
})

describe('getAllLessonPaths', () => {
  it('returns an array (empty in Phase 1)', () => {
    expect(Array.isArray(getAllLessonPaths())).toBe(true)
  })
})
