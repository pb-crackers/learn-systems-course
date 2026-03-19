variable "prometheus_port" {
  description = "External port for Prometheus"
  type        = number
  default     = 9090
  validation {
    condition     = var.prometheus_port > 0 && var.prometheus_port < 65536
    error_message = "Port must be between 1 and 65535."
  }
}
