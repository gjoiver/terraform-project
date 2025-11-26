variable "db_identifier" {
  type        = string
  description = "Database instance identifier"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_username" {
  type        = string
  description = "Database master username"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Database master password"
  sensitive   = true
}

variable "db_instance_class" {
  type        = string
  description = "Database instance class"
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage in GB"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for DB subnet group"
}

variable "db_security_group_id" {
  type        = string
  description = "Security group ID for the database"
}

variable "multi_az" {
  type        = bool
  description = "Enable multi-AZ deployment"
  default     = false
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot when destroying"
  default     = true
}
