variable "region" {
  description = "AWS region for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet_a_cidr" {
  description = "CIDR block for the subnet A"
  type        = string
}

variable "subnet_b_cidr" {
  description = "CIDR block for the subnet B"
  type        = string
}

variable "az_a" {
  description = "AWS availability zone A"
  type        = string
}

variable "az_b" {
  description = "AWS availability zone B"
  type        = string
}

variable "project_name" {
  description = "Project name for the resource tagging"
  type        = string
}
