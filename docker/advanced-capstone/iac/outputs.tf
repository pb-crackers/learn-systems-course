output "prometheus_container_id" {
  description = "Docker container ID for Prometheus"
  value       = docker_container.prometheus.id
}

output "network_id" {
  description = "Docker network ID for capstone"
  value       = docker_network.capstone.id
}
