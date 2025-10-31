# Outputs from module security-group

output "security_group_id" {
  description = "ID of The security group"
  value       = aws_security_group.web.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.web.name
}
