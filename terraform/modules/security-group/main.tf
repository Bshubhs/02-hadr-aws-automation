# security group for web server
resource "aws_security_group" "web" {
  name   = "${var.project_name}-web-sg"
  vpc_id = var.vpc_id

  # ingress = Incoming traffic rule
  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Egress = Outgoing traffic rule
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1 # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }

}
