output "alb_dns_name" {
  description = "DNS Name of the Load Balancer"
  value       = aws_lb.web.dns_name
}

output "alb_arn" {
  description = "ARN of the Load Balancer"
  value       = aws_lb.web.arn
}

output "alb_zone_id" {
  description = "Zone ID of the Load Balancer (for route 53)"
  value       = aws_lb.web.zone_id
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.web.arn
}

output "target_group_name" {
  description = "Name of the Target Group"
  value       = aws_lb_target_group.web.name
}
