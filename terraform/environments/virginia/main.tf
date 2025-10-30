# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Call the same VPC module, with diff variable values
module "vpc" {
  source = "../../modules/vpc"

  # pass the values to module variables
  region        = "us-east-1"
  vpc_cidr      = "10.1.0.0/16"
  subnet_a_cidr = "10.1.1.0/24"
  subnet_b_cidr = "10.1.2.0/24"
  az_a          = "us-east-1a"
  az_b          = "us-east-1b"
  project_name  = "hadr-virginia"
}

# Expose module outputs at environmetn level
output "vpc_id" {
  description = "VPC ID from module"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs from module"
  value       = module.vpc.subnet_ids
}

output "availability_zones" {
  description = "Availability zones from module"
  value       = module.vpc.availability_zones
}
