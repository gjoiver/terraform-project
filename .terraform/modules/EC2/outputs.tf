output "launch_template_id" {
  description = "Launch template ID"
  value       = aws_launch_template.wordpress_lt.id
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = aws_launch_template.wordpress_lt.latest_version
}

output "autoscaling_group_id" {
  description = "Auto Scaling Group ID"
  value       = aws_autoscaling_group.wordpress_asg.id
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.wordpress_asg.name
}

output "autoscaling_group_arn" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.wordpress_asg.arn
}
