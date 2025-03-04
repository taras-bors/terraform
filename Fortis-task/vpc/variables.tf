variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "front_end_private_subnet_cidr" {
  description = "A CIDR blocks for the front-end private subnet."
  type        = string
}

variable "back_end_private_subnet_cidr" {
  description = "A CIDR blocks for the back-end private subnet."
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones to distribute the subnets across."
  type        = list(string)
}