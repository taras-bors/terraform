output "vpc_id" {
  description = "The VPC id"
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = aws_subnet.dmz_public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = aws_subnet.private[*].id
}

