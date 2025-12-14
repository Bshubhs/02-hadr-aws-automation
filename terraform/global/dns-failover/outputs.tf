output "hosted_zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "hosted_zone_name_servers" {
  description = "Name servers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}

output "application_url" {
  description = "Primary URL for accessing the application"
  value       = "http://${var.subdomain_name}.${var.domain_name}"
}

output "health_check_id" {
  description = "ID of the primary health check"
  value       = aws_route53_health_check.primary.id
}

output "primary_record_fqdn" {
  description = "FQDN of primary record"
  value       = aws_route53_record.primary.fqdn
}

output "secondary_record_fqdn" {
  description = "FQDN of secondary record"
  value       = aws_route53_record.secondary.fqdn
}
