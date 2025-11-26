resource "aws_vpc" "vpc_itm_wordpress" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet_itm_wordpress_1" {
  vpc_id                  = aws_vpc.vpc_itm_wordpress.id
  cidr_block              = var.subnet_1_cidr
  availability_zone       = var.subnet_1_az
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_1_name
  }
}

resource "aws_subnet" "subnet_itm_wordpress_2" {
  vpc_id                  = aws_vpc.vpc_itm_wordpress.id
  cidr_block              = var.subnet_2_cidr
  availability_zone       = var.subnet_2_az
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_2_name
  }
}

resource "aws_internet_gateway" "igw_itm_wordpress" {
  vpc_id = aws_vpc.vpc_itm_wordpress.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_itm_wordpress.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_itm_wordpress.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "subnet_1_association" {
  subnet_id      = aws_subnet.subnet_itm_wordpress_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet_2_association" {
  subnet_id      = aws_subnet.subnet_itm_wordpress_2.id
  route_table_id = aws_route_table.public_rt.id
}