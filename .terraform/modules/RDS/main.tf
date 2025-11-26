# DB Subnet Group
resource "aws_db_subnet_group" "wordpress_db_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "wordpress_db" {
  identifier             = var.db_identifier
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  storage_type           = "gp2"
  storage_encrypted      = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.wordpress_db_subnet_group.name
  vpc_security_group_ids = [var.db_security_group_id]

  multi_az               = var.multi_az
  publicly_accessible    = false

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"

  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.db_identifier}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  tags = {
    Name = var.db_identifier
  }
}
