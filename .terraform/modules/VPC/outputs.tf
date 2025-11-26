output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc_itm_wordpress.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.vpc_itm_wordpress.cidr_block
}

output "subnet_1_id" {
  description = "Subnet 1 ID"
  value       = aws_subnet.subnet_itm_wordpress_1.id
}

output "subnet_2_id" {
  description = "Subnet 2 ID"
  value       = aws_subnet.subnet_itm_wordpress_2.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.subnet_itm_wordpress_1.id, aws_subnet.subnet_itm_wordpress_2.id]
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw_itm_wordpress.id
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public_rt.id
}