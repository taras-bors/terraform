variable "ssh_bastion_amazon_ec2_security_group" {
  description = "A security group for db."
  type        = string
}

variable "web_app_amazon_ec2_security_group" {
  description = "A security group for db."
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet."
  type        = string
}

variable "front_end_private_subnet_id" {
  description = "The ID of the web app server subnet."
  type        = string
}