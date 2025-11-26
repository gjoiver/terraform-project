# VPC Module
module "VPC" {
  source         = "./modules/VPC"
  vpc_cidr       = var.vpc_cidr[terraform.workspace]
  vpc_name       = var.vpc_name[terraform.workspace]
  subnet_1_cidr  = var.subnet_1_cidr[terraform.workspace]
  subnet_1_az    = var.subnet_1_az[terraform.workspace]
  subnet_1_name  = var.subnet_1_name[terraform.workspace]
  subnet_2_cidr  = var.subnet_2_cidr[terraform.workspace]
  subnet_2_az    = var.subnet_2_az[terraform.workspace]
  subnet_2_name  = var.subnet_2_name[terraform.workspace]
}

# Security Groups Module
module "SecurityGroups" {
  source       = "./modules/SecurityGroups"
  vpc_id       = module.VPC.vpc_id
  project_name = var.vpc_name[terraform.workspace]
}

# RDS Module
module "RDS" {
  source = "./modules/RDS"

  db_identifier         = "${replace(var.vpc_name[terraform.workspace], "_", "-")}-db"
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_instance_class     = var.db_instance_class[terraform.workspace]
  db_allocated_storage  = var.db_allocated_storage
  subnet_ids            = module.VPC.public_subnet_ids
  db_security_group_id  = module.SecurityGroups.rds_sg_id
  multi_az              = false
  skip_final_snapshot   = true
}

# Application Load Balancer Module
module "ALB" {
  source = "./modules/ALB"

  alb_name               = var.alb_name[terraform.workspace]
  vpc_id                 = module.VPC.vpc_id
  subnet_ids             = module.VPC.public_subnet_ids
  alb_security_group_id  = module.SecurityGroups.alb_sg_id
}

# EC2 Module with Auto Scaling
module "EC2" {
  source = "./modules/EC2"

  instance_name      = var.ec2_name[terraform.workspace]
  instance_type      = var.instance_type[terraform.workspace]
  key_name           = var.key_name
  subnet_ids         = module.VPC.public_subnet_ids
  security_group_id  = module.SecurityGroups.ec2_sg_id
  target_group_arns  = [module.ALB.target_group_arn]
  min_size           = 1
  max_size           = 3
  desired_capacity   = 2
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_endpoint        = module.RDS.db_instance_address
  environment        = terraform.workspace
}
