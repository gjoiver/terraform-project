output "alb_id" {
  description = "Application Load Balancer ID"
  value       = aws_lb.wordpress_alb.id
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.wordpress_alb.arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.wordpress_alb.dns_name
}

output "alb_zone_id" {
  description = "Application Load Balancer Zone ID"
  value       = aws_lb.wordpress_alb.zone_id
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.wordpress_tg.arn
}

output "target_group_name" {
  description = "Target Group name"
  value       = aws_lb_target_group.wordpress_tg.name
}
