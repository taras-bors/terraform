variable "db_security_group" {
  description = "A security group for db."
  type        = string
}

variable "back_end_private_subnet_ids" {
  description = "A private subnet for db."
  type        = list(string)
}