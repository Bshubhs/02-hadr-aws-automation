# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.hadr_vpc.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.hadr_vpc.cidr_block
}

# Subnet Outputs
output "subnet_a_id" {
  description = "The ID of subnet A"
  value       = aws_subnet.public_a.id
}

output "subnet_b_id" {
  description = "The ID of subnet B"
  value       = aws_subnet.public_b.id
}

output "subnet_ids" {
  description = "List of all subnet IDs"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

# Network infrastructure outputs
output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.main.id
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.public.id
}

# Availability Zones
output "availability_zones" {
  description = "AZs where subnets are deployed"
  value = {
    subnet_a = aws_subnet.public_a.availability_zone
    subnet_b = aws_subnet.public_b.availability_zone
  }
}

