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
  it('returns lesson paths for all modules', () => {
    expect(Array.isArray(getAllLessonPaths())).toBe(true)
  })

  it('docker module has 9 lessons', () => {
    const paths = getAllLessonPaths()
    const dockerPaths = paths.filter(p => p.moduleSlug === '03-docker')
    expect(dockerPaths).toHaveLength(9)
  })

  it('sysadmin module has 7 lessons', () => {
    const paths = getAllLessonPaths()
    const sysadminPaths = paths.filter(p => p.moduleSlug === '04-sysadmin')
    expect(sysadminPaths).toHaveLength(7)
  })

  it('cicd module has 5 lessons', () => {
    const paths = getAllLessonPaths()
    const cicdPaths = paths.filter(p => p.moduleSlug === '05-cicd')
    expect(cicdPaths).toHaveLength(5)
  })

  it('iac module has 5 lessons', () => {
    const paths = getAllLessonPaths()
    const iacPaths = paths.filter(p => p.moduleSlug === '06-iac')
    expect(iacPaths).toHaveLength(5)
  })

  it('cloud module has 6 lessons', () => {
    const paths = getAllLessonPaths()
    const cloudPaths = paths.filter(p => p.moduleSlug === '07-cloud')
    expect(cloudPaths).toHaveLength(6)
  })

  it('monitoring module has 7 lessons', () => {
    const paths = getAllLessonPaths()
    const monitoringPaths = paths.filter(p => p.moduleSlug === '08-monitoring')
    expect(monitoringPaths).toHaveLength(7)
  })
})
