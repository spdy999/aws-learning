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

output "bastion_public_ip" {
  description = "Bastion public IP — SSH entry point"
  value       = aws_instance.bastion.public_ip
}

output "private_ec2_instance_id" {
  description = "Private EC2 instance ID"
  value       = aws_instance.private.id
}

output "private_ec2_private_ip" {
  description = "Private EC2 private IP"
  value       = aws_instance.private.private_ip
}

output "ssh_commands" {
  description = "Commands to connect to the private EC2 via bastion"
  value       = <<-EOT
    # Step 1 — SSH to bastion
    ssh -i nat-gateway/terraform/bastion.pem ec2-user@${aws_instance.bastion.public_ip}

    # Step 2 — from bastion, SSH to private EC2
    ssh -i bastion.pem ec2-user@${aws_instance.private.private_ip}

    # Or use SSH agent forwarding (one command):
    ssh -A -i nat-gateway/terraform/bastion.pem ec2-user@${aws_instance.bastion.public_ip} -J "" ssh ec2-user@${aws_instance.private.private_ip}
  EOT
}
