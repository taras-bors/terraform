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
  count          = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "front_end_private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.front_end_private_subnet_cidr
}

resource "aws_subnet" "back_end_private" {
  count          = length(var.back_end_private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.back_end_private_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

# NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.dmz_public[0].id

  tags = {
    Name = "nat-gateway"
  }
}

# Route tables
# DMZ route table
resource "aws_route_table" "dmz_public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "dmz_public-rt"
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.dmz_public[count.index].id
  route_table_id = aws_route_table.dmz_public_rt.id
}

# Private route table - routing traffic from private subnets through NAT
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "front_end_private_subnet_assoc" {
  subnet_id      = aws_subnet.front_end_private.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "back_end_private_subnet_assoc" {
  count          = length(var.back_end_private_subnet_cidrs)
  subnet_id      = aws_subnet.back_end_private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
