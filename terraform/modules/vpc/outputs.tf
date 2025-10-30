# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet outputs
output "subnet_a_id" {
  description = "The ID of the subnet A"
  value       = aws_subnet.public_a.id
}

output "subnet_b_id" {
  description = "The ID of the subnet B"
  value       = aws_subnet.public_b.id
}

output "subnet_ids" {
  description = "The IDs of both the subnets"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}


# Network outputs
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "route_table_id" {
  description = "The ID of the Route TableL"
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
