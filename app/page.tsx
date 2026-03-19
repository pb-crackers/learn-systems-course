import { getAllModules } from '@/lib/modules'
import { CourseDashboard } from '@/components/dashboard/CourseDashboard'

export default async function HomePage() {
  const modules = getAllModules()
  return <CourseDashboard modules={modules} />
}
