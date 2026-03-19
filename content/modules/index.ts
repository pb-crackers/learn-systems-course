import type { Module } from '@/types/content'

// Module manifest. Lessons[] starts empty — populated by Phases 2-7.
// accentColor value must match CSS variable suffix in globals.css:
//   "linux" → --color-module-linux, "networking" → --color-module-networking, etc.
export const MODULES: Omit<Module, 'lessons'>[] = [
  {
    slug: '01-linux-fundamentals',
    title: 'Linux Fundamentals',
    description: 'CPU, OS, filesystem, processes, shell, scripting, text tools, packages',
    order: 1,
    accentColor: 'linux',
  },
  {
    slug: '02-networking',
    title: 'Networking Foundations',
    description: 'TCP/IP, DNS, HTTP/HTTPS, SSH, firewalls, troubleshooting',
    order: 2,
    accentColor: 'networking',
  },
  {
    slug: '03-docker',
    title: 'Docker & Containerization',
    description: 'Containers, images, volumes, networking, Compose, best practices',
    order: 3,
    accentColor: 'docker',
  },
  {
    slug: '04-sysadmin',
    title: 'System Administration',
    description: 'Users, systemd, logging, disk management, scheduling, monitoring',
    order: 4,
    accentColor: 'sysadmin',
  },
  {
    slug: '05-cicd',
    title: 'CI/CD Pipelines',
    description: 'CI/CD concepts, GitHub Actions, build/test/deploy pipelines',
    order: 5,
    accentColor: 'cicd',
  },
  {
    slug: '06-iac',
    title: 'Infrastructure as Code',
    description: 'OpenTofu/Terraform HCL, state management, modules',
    order: 6,
    accentColor: 'iac',
  },
  {
    slug: '07-cloud',
    title: 'Cloud Fundamentals',
    description: 'Compute, networking, storage, IAM mapped to prior Docker/networking knowledge',
    order: 7,
    accentColor: 'cloud',
  },
  {
    slug: '08-monitoring',
    title: 'Monitoring & Observability',
    description: 'Prometheus, Grafana, log aggregation, alerting, incident response',
    order: 8,
    accentColor: 'monitoring',
  },
]
