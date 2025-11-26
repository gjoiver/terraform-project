terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "joiangon.tfstates2025"
    key    = "joiangon/joiangon.tfstate"
    encrypt = true
    region  = "us-east-1"
  }
}

provider "aws" {
  region                  = var.aws_region
  shared_credentials_files = var.shared_credentials_files
  profile                 = var.aws_profile
  # Puedes agregar más configuraciones aquí si lo necesitas
}
