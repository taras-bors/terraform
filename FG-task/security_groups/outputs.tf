output "ssh_bastion_amazon_ec2_security_group_id" {
  value = aws_security_group.ssh_bastion_amazon_ec2_security_group.id
}

output "elastic_load_balancer_security_group" {
  value = aws_security_group.elastic_load_balancer_security_group.id
}

output "nat_security_group" {
  value = aws_security_group.nat_security_group.id
}

output "web_app_amazon_ec2_security_group" {
  value = aws_security_group.web_app_amazon_ec2_security_group.id
}

output "db_security_group" {
  value = aws_security_group.db_security_group.id
}

