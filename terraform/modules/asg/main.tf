# Launch Template - Blueprint for EC2 instances
resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-web-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  # Network configuration
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group_ids
  }

  # User Data 
  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Update system
    yum update -y
    
    # Install Apache web server
    yum install -y httpd

    # Start Apache and enable on boot
    systemctl start httpd
    systemctl enable httpd

    # Create a simple web page showing region and IP
    cat > /var/www/html/index.html <<HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>HADR Demo - ${var.region}</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
          margin: 0;
        }
        .container {
          text-align: center;
          background: rgba(255,255,255,0.1);
          padding: 50px;
          border-radius: 20px;
          backdrop-filter: blur(10px);
        }
        h1 { font-size: 48px; margin-bottom: 20px; }
        p { font-size: 24px; margin: 10px 0; }
        .region { color: #ffd700; font-weight: bold; }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>🌍 HADR Architecture Demo</h1>
        <p>You are connected to:</p>
        <p class="region">${var.region}</p>
        <p><strong>Instance IP:</strong> $(hostname -I | cut -d' ' -f1)</p>
        <p><strong>Availability Zone:</strong> $(ec2-metadata --availability-zone | cut -d' ' -f2)</p>
      </div>
    </body>
    </html>
    HTML
          
    # Restart Apache to ensure everything loads
    systemctl restart httpd
    EOF
  )

  # Tag specification for instances launched from this template
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-web-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name                      = "${var.project_name}-asg"
  vpc_zone_identifier       = var.subnet_ids
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_type         = "EC2"
  health_check_grace_period = 300 # 5 minutes for instance to become healthy

  target_group_arns = var.target_group_arns # Added in phase 6 (After creation of ALB module)

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  # Tag propagation for instances
  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}
