variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones to distribute the subnets across."
  type        = list(string)
}

variable "public_subnet_cidr" {
  description = "A CIDR block for the public subnet."
  type        = string
}

variable "front_end_private_subnet_cidr" {
  description = "A CIDR blocks for the front-end private subnet."
  type        = string
}

variable "back_end_private_subnet_cidrs" {
  description = "A CIDR blocks for the back-end private subnet."
  type        = list(string)
}

