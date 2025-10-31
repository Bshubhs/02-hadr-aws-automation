output "launch_template_id" {
  description = "ID of the Lanch template"
  value       = aws_launch_template.web.id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.arn
}
