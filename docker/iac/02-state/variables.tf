variable "container_name" {
  type        = string
  description = "Name for the Docker container"
  default     = "learn-state-demo"
}

variable "external_port" {
  type        = number
  description = "Host port to map container port 80 to"
  default     = 8090
}
