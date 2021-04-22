output "alb_dns_name" {
  value       = aws_lb.webserver.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.webserver.name
  description = "The name of the Auto Scaling Group"
}

