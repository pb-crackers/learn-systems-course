terraform {
  required_providers {
    docker = {
      source  = "registry.opentofu.org/kreuzwerker/docker"
      version = "3.9.0"
    }
  }
}

provider "docker" {}

module "frontend" {
  source        = "./modules/web-container"
  name          = "learn-frontend"
  image_name    = "nginx:1.25"
  internal_port = 80
  external_port = 8081
}

module "api" {
  source        = "./modules/web-container"
  name          = "learn-api"
  image_name    = "nginx:1.25"
  internal_port = 80
  external_port = 8082
}
