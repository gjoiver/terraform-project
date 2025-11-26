variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be created"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging and naming resources"
}
