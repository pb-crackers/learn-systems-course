variable "name" {
  type        = string
  description = "Name for the Docker container"
}

variable "image_name" {
  type        = string
  description = "Docker image name and tag to pull"
}

variable "internal_port" {
  type        = number
  description = "Container port to expose"
}

variable "external_port" {
  type        = number
  description = "Host port to map the container port to"
}
