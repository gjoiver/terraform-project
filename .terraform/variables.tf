variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}

variable "shared_credentials_files" {
  description = "Path to AWS credentials file"
  type        = list(string)
  default     = ["C:/Users/Usuario/.aws/credentials"]
}

variable "vpc_cidr" {
  description = "VPC CIDR block by workspace"
  type        = map(string)
  default = {
    default = "192.168.16.0/24"
    dev     = "192.168.16.0/24"
  }
}

variable "vpc_name" {
  description = "VPC Name tag by workspace"
  type        = map(string)
  default = {
    default = "vpc_itm_wordpress_default"
    dev     = "vpc_itm_wordpress_dev"
  }
}

variable "subnet_1_cidr" {
  description = "Subnet 1 CIDR block by workspace"
  type        = map(string)
  default = {
    default = "192.168.16.0/28"
    dev     = "192.168.16.16/28"
  }
}

variable "subnet_1_az" {
  description = "Subnet 1 availability zone by workspace"
  type        = map(string)
  default = {
    default = "us-east-1a"
    dev     = "us-east-1b"
  }
}

variable "subnet_1_name" {
  description = "Subnet 1 Name tag by workspace"
  type        = map(string)
  default = {
    default = "subnet_itm_wordpress_default"
    dev     = "subnet_itm_wordpress_dev"
  }
}

variable "subnet_2_cidr" {
  description = "Subnet 2 CIDR block by workspace"
  type        = map(string)
  default = {
    default = "192.168.16.32/28"
    dev     = "192.168.16.32/28"
  }
}

variable "subnet_2_az" {
  description = "Subnet 2 availability zone by workspace"
  type        = map(string)
  default = {
    default = "us-east-1b"
    dev     = "us-east-1c"
  }
}

variable "subnet_2_name" {
  description = "Subnet 2 Name tag by workspace"
  type        = map(string)
  default = {
    default = "subnet_itm_wordpress_2_default"
    dev     = "subnet_itm_wordpress_2_dev"
  }
}

# EC2 Variables
variable "instance_type" {
  description = "EC2 instance type by workspace"
  type        = map(string)
  default = {
    default = "t2.micro"
    dev     = "t2.micro"
  }
}

variable "ec2_name" {
  description = "EC2 instance name by workspace"
  type        = map(string)
  default = {
    default = "ec2_itm_wordpress_default"
    dev     = "ec2_itm_wordpress_dev"
  }
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "wordpress-key"
}

# RDS Variables
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "wordpressdb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class by workspace"
  type        = map(string)
  default = {
    default = "db.t3.micro"
    dev     = "db.t3.micro"
  }
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

# ALB Variables
variable "alb_name" {
  description = "Application Load Balancer name by workspace"
  type        = map(string)
  default = {
    default = "alb-itm-wordpress-default"
    dev     = "alb-itm-wordpress-dev"
  }
}