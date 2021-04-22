terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_launch_configuration" "webserver" {
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true
  user_data                   = var.rendered_user_data
  security_groups             = var.vpc_security_group_ids

  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webserver" {
  launch_configuration = aws_launch_configuration.webserver.name
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = [aws_lb_target_group.autoscaling_group.arn]
  health_check_type    = "ELB"

  min_size = var.min_instance
  max_size = var.max_instance

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}

resource "aws_lb" "webserver" {
  name               = var.cluster_name
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.vpc_security_group_ids
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.webserver.arn
  port              = var.server_port
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "autoscaling_group" {
  name     = var.cluster_name
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "autoscaling_group" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.autoscaling_group.arn
  }
}
