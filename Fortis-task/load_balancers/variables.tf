variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "elastic_load_balancer_security_group" {
  description = "Allows ELB traffic"
  type = string
}

variable "public_subnet_id" {
  description = "DMZ subnet"
  type = list(string)
}

variable "web_app_server_id" {
  description = "Targeted instance id"
  type = string
}