variable "domain_name" {
  description = "Domain name for the hosted zone"
  type        = string
  default     = "bshubham.site"
}

variable "subdomain_name" {
  description = "subdomain for the application"
  type        = string
  default     = "app"
}

variable "primary_alb_dns" {
  description = "DNS name of primary ALB (Mumbai)"
  type        = string
}

variable "primary_alb_zone_id" {
  description = "Zone ID of primary ALB (Mumbai)"
  type        = string
}

variable "secondary_alb_dns" {
  description = "DNS name of secondary ALB (Virginia)"
  type        = string
}

variable "secondary_alb_zone_id" {
  description = "Zone ID of secondary ALB (Virginia)"
  type        = string
}

variable "health_check_interval" {
  description = "Health check interval in seconds (30 or 10)"
  type        = number
  default     = 30
}

variable "failure_threshold" {
  description = "Number of consecutive health check failures before marking unhealthy"
  type        = number
  default     = 2
}
