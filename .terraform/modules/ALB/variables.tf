variable "alb_name" {
  type        = string
  description = "Name for the Application Load Balancer"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where ALB will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for ALB"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group ID for ALB"
}

# Uncomment if using HTTPS
# variable "certificate_arn" {
#   type        = string
#   description = "ARN of SSL certificate for HTTPS listener"
#   default     = ""
# }
