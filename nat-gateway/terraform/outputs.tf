output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat.id
}

output "nat_eip" {
  description = "NAT Gateway public IP"
  value       = aws_eip.nat.public_ip
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = aws_subnet.private.id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = aws_route_table.private.id
}

output "private_ec2_instance_id" {
  description = "Private EC2 instance ID (use with SSM Session Manager)"
  value       = aws_instance.private.id
}

output "private_ec2_private_ip" {
  description = "Private EC2 private IP"
  value       = aws_instance.private.private_ip
}
