# Target Groups - Defines how traffic will be routed to the instances
resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Heath check configuration
  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = var.target_port
    protocol            = "HTTP"
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    matcher             = "200" # HTTP 200 OK = Healthy
  }

  # Deregistration delay - wait time before removing targets
  deregistration_delay = 30

  tags = {
    Name = "${var.project_name}-tg"
  }
}

# Application Load Balancer
resource "aws_lb" "web" {
  name               = "${var.project_name}-alb"
  internal           = false # Internet facing
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  # Enable deletion protection in production
  enable_deletion_protection = false # False for learning (easy to destroy)

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# Listeners - Defines what ALB listens for 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  # Default action
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
