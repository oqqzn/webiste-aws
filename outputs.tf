output "aws_alb_dns_hostname" {
  value       = "http://${aws_lb.nginx.dns_name}"
  description = "Public DNS for the application load balancer"
}

