output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  description = "Security Group ID for EC2 instances"
  value       = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS database"
  value       = aws_security_group.rds_sg.id
}
