output "alb_dns_name" {
  description = "DNS of ALB"
  value = aws_lb.alb.dns_name
}

output "alb_arn" {
  description = "ARN of alb"
  value = aws_lb.alb.arn
}

output "alb_http_listener_arn" {
  description = "ARN of alb http listener"
  value = aws_alb_listener.alb_http_listener.arn
}

output "alb_https_listener_arn" {
  description = "ARN of alb https listener"
  value = aws_alb_listener.alb_https_listener.*.arn
}