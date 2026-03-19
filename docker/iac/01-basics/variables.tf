variable "container_name" {
  type        = string
  description = "Name for the Docker container"
  default     = "learn-iac-web"
}

variable "external_port" {
  type        = number
  description = "Host port to map container port 80 to"
  default     = 8080

  validation {
    condition     = var.external_port >= 1024 && var.external_port <= 65535
    error_message = "Port must be in the range 1024-65535 (non-privileged ports)."
  }
}
