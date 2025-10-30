# Provider configuration
provider "aws" {
  region = "ap-south-1"
}

# call the VPC Module
module "vpc" {
  source = "../../modules/vpc"

  # Pass value to module Variables
  region        = "ap-south-1"
  vpc_cidr      = "10.0.0.0/16"
  subnet_a_cidr = "10.0.1.0/24"
  subnet_b_cidr = "10.0.2.0/24"
  az_a          = "ap-south-1a"
  az_b          = "ap-south-1b"
  project_name  = "hadr_mumbai"
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
