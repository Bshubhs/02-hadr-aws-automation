# Provider configuration
provider "aws" {
  region = "ap-south-1"
}

# calling the VPC Module
module "vpc" {
  source = "../../modules/vpc"

  # Pass value to module Variables
  region        = "ap-south-1"
  vpc_cidr      = "10.0.0.0/16"
  subnet_a_cidr = "10.0.1.0/24"
  subnet_b_cidr = "10.0.2.0/24"
  az_a          = "ap-south-1a"
  az_b          = "ap-south-1b"
  project_name  = "hadr-mumbai"
}

# Exposing the module outputs at environment level
output "vpc_id" {
  description = "VPC ID from module"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs from module"
  value       = module.vpc.subnet_ids
}

output "availability_zones" {
  description = "Availability zones   from module"
  value       = module.vpc.availability_zones
}

# calling the Security Group Module
module "security-group" {
  source = "../../modules/security-group"

  project_name = "hadr-mumbai"
  vpc_id       = module.vpc.vpc_id
}

# Calling the ALB Module
module "alb" {
  source = "../../modules/alb"

  project_name       = "hadr-mumbai"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = [module.security-group.security_group_id]

  # Health check setting
  target_port           = 80
  health_check_path     = "/"
  health_check_interval = 10
  health_check_timeout  = 3
  healthy_threshold     = 2
  unhealthy_threshold   = 2
}

# ALB outputs
output "alb_dns_name" {
  description = "ALB DNS name - Use this URL to access application"
  value       = "http://${module.alb.alb_dns_name}"
}

output "target_group_name" {
  description = "Target Group Name"
  value       = module.alb.target_group_name
}

# Calling the ASG module
module "asg" {
  source = "../../modules/asg"

  project_name       = "hadr-mumbai"
  region             = "ap-south-1"
  ami_id             = "ami-01760eea5c574eb86"
  instance_type      = "t2.micro"
  security_group_ids = [module.security-group.security_group_id] # Using security-group output
  subnet_ids         = module.vpc.subnet_ids                     #using VPC output (List of two subnets)

  desired_capacity = 2
  min_size         = 1
  max_size         = 3

  # Connecting ASG to ALB
  target_group_arns = [module.alb.target_group_arn]
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.asg.asg_name
}
