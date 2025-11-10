variable "project_name" {
  description = "Project name for resource  naming"
  type        = string
}

variable "region" {
  description = "AWS region name (for display in webpage)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for ec2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for ASG (multi-AZ)"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimun number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximumm number of instances"
  type        = number
  default     = 3
}

variable "target_group_arns" {
  description = "List of target group ARNs to attach to the ASG"
  type        = list(string)
  default     = [] # Empty by default (Optional attachment)
}
