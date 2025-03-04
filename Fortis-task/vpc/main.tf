provider "aws" {
  region = "ca-central-1"
}

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "dmz_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_subnet" "front_end_private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.front_end_private_subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_subnet" "back_end_private" {
  count          = length(var.back_end_private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.back_end_private_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
}
