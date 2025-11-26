variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "subnet_1_cidr" {
  type        = string
  description = "CIDR block for subnet 1"
}

variable "subnet_1_az" {
  type        = string
  description = "Availability zone for subnet 1"
}

variable "subnet_1_name" {
  type        = string
  description = "Name tag for subnet 1"
}

variable "subnet_2_cidr" {
  type        = string
  description = "CIDR block for subnet 2"
}

variable "subnet_2_az" {
  type        = string
  description = "Availability zone for subnet 2"
}

variable "subnet_2_name" {
  type        = string
  description = "Name tag for subnet 2"
}
