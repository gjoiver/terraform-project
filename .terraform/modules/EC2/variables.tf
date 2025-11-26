variable "instance_name" {
  type        = string
  description = "Name for EC2 instances"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Auto Scaling Group"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for EC2 instances"
}

variable "target_group_arns" {
  type        = list(string)
  description = "List of target group ARNs for Auto Scaling Group"
}

variable "min_size" {
  type        = number
  description = "Minimum number of instances in Auto Scaling Group"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in Auto Scaling Group"
  default     = 3
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instances in Auto Scaling Group"
  default     = 2
}

variable "db_name" {
  type        = string
  description = "Database name for WordPress"
}

variable "db_username" {
  type        = string
  description = "Database username"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "db_endpoint" {
  type        = string
  description = "Database endpoint"
}

variable "environment" {
  type        = string
  description = "Environment name"
}
