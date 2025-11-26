# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.VPC.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.VPC.vpc_cidr
}

output "subnet_1_id" {
  description = "Subnet 1 ID"
  value       = module.VPC.subnet_1_id
}

output "subnet_2_id" {
  description = "Subnet 2 ID"
  value       = module.VPC.subnet_2_id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.VPC.internet_gateway_id
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = module.SecurityGroups.alb_sg_id
}

output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = module.SecurityGroups.ec2_sg_id
}

output "rds_security_group_id" {
  description = "RDS Security Group ID"
  value       = module.SecurityGroups.rds_sg_id
}

# RDS Outputs
output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = module.RDS.db_instance_endpoint
}

output "db_instance_address" {
  description = "RDS instance address"
  value       = module.RDS.db_instance_address
}

output "db_instance_name" {
  description = "Database name"
  value       = module.RDS.db_instance_name
}

# ALB Outputs
output "alb_dns_name" {
  description = "Application Load Balancer DNS name - Use this URL to access WordPress"
  value       = module.ALB.alb_dns_name
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = module.ALB.alb_arn
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = module.ALB.target_group_arn
}

# EC2 Outputs
output "autoscaling_group_name" {
  description = "Auto Scaling Group name"
  value       = module.EC2.autoscaling_group_name
}

output "autoscaling_group_arn" {
  description = "Auto Scaling Group ARN"
  value       = module.EC2.autoscaling_group_arn
}

# WordPress Access Information
output "wordpress_url" {
  description = "WordPress site URL"
  value       = "http://${module.ALB.alb_dns_name}"
}

output "wordpress_admin_url" {
  description = "WordPress admin URL"
  value       = "http://${module.ALB.alb_dns_name}/wp-admin"
}
