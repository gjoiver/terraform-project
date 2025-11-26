output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.wordpress_db.id
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.wordpress_db.endpoint
}

output "db_instance_address" {
  description = "RDS instance address"
  value       = aws_db_instance.wordpress_db.address
}

output "db_instance_name" {
  description = "Database name"
  value       = aws_db_instance.wordpress_db.db_name
}

output "db_instance_port" {
  description = "Database port"
  value       = aws_db_instance.wordpress_db.port
}
