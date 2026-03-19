resource "docker_image" "image" {
  name         = var.image_name
  keep_locally = true
}

resource "docker_container" "container" {
  name  = var.name
  image = docker_image.image.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}
