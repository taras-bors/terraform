output "vpc_id" {
  description = "The VPC id"
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnets."
  value       = aws_subnet.dmz_public[*].id
}

output "front_end_private_subnet_id" {
  description = "The ID of the front-end private subnet."
  value       = aws_subnet.front_end_private.id
}

output "back_end_private_subnet_ids" {
  description = "The ID of the back-end private subnets."
  value       = aws_subnet.back_end_private[*].id
}
