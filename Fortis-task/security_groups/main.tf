# For Bastion
resource "aws_security_group" "ssh_bastion_amazon_ec2_security_group" {
  name        = "ssh_bastion_amazon_ec2_security_group"
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound SSH from admins"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound SSH traffic to front-end subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  tags = {
    Name = "amazon_ec2_security_group"
    Usage = "ssh_bastion"
  }
}

# For ELB
resource "aws_security_group" "elastic_load_balancer_security_group" {
  name        = "elastic_load_balancer_security_group"
  description = "Allow ELB traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound ELB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound ELB traffic to front-end subnet"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  tags = {
    Name = "elastic_load_balancer_security_group"
    Usage = "ELB"
  }
}

# For Web App
resource "aws_security_group" "web_app_amazon_ec2_security_group" {
  name        = "web_app_amazon_ec2_security_group"
  description = "Allow traffic from ELB to web app, and tcp outbound"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound traffic from ELB to web app"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_app_amazon_ec2_security_group"
    Usage = "web_app"
  }
}

# For NAT gateway
resource "aws_security_group" "nat_security_group" {
  name        = "nat_security_group"
  description = "Allow egress traffic from web app, and db."
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound traffic from web app"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  ingress {
    description = "Allow inbound traffic from db"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nat_security_group"
    Usage = "nat_ gateway"
  }
}