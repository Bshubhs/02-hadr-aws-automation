# Variables for security-group module

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

