variable "region" {
  description = " AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_a_cidr" {
  description = "Subner A CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr" {
  description = "Subner B CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az_a" {
  description = "Availability Zone A"
  type        = string
  default     = "ap-south-1a"
}

variable "az_b" {
  description = "Availability Zone B"
  type        = string
  default     = "ap-south-1b"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "hadr-mumbai"
}

