terraform {
  required_providers {
    docker = {
      source  = "registry.opentofu.org/kreuzwerker/docker"
      version = "3.9.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "capstone" {
  name = "capstone-network"
}

resource "docker_image" "prometheus" {
  name = "prom/prometheus:v3.10.0"
}

resource "docker_container" "prometheus" {
  name  = "capstone-prometheus"
  image = docker_image.prometheus.image_id
  ports {
    internal = 9090
    external = var.prometheus_port
  }
  networks_advanced {
    name = docker_network.capstone.name
  }
  volumes {
    host_path      = abspath("${path.module}/../prometheus/prometheus.yml")
    container_path = "/etc/prometheus/prometheus.yml"
    read_only      = true
  }
  volumes {
    host_path      = abspath("${path.module}/../prometheus/rules")
    container_path = "/etc/prometheus/rules"
    read_only      = true
  }
  command = [
    "--config.file=/etc/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus",
    "--web.enable-lifecycle"
  ]
}

output "prometheus_url" {
  value = "http://localhost:${var.prometheus_port}"
}
