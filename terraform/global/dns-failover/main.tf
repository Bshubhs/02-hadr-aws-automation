# Hosted zone - container for DNS records
resource "aws_route53_zone" "main" {
  name    = var.domain_name
  comment = "Hosted zone for HADR multi-region application"

  tags = {
    Name        = "${var.domain_name}-zone"
    Environment = "production"
    Project     = "HADR"
  }
}

# Health check for primary Mumbai ALB
resource "aws_route53_health_check" "primary" {
  fqdn              = var.primary_alb_dns
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = var.failure_threshold
  request_interval  = var.health_check_interval

  tags = {
    Name = "primary-alb-health-check"
  }
}

# Primary failover record (Mumbai)
resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.subdomain_name}.${var.domain_name}"
  type    = "A"

  set_identifier = "primary"

  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = var.primary_alb_dns
    zone_id                = var.primary_alb_zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.primary.id

}
# Secondary failover record (Virginia)
resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.subdomain_name}.${var.domain_name}"
  type    = "A"

  set_identifier = "secondary"

  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name                   = var.secondary_alb_dns
    zone_id                = var.secondary_alb_zone_id
    evaluate_target_health = false
  }

  # No health check as this secondary as it is a Backup.

}
