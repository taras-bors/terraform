resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = var.vpc_id

  # Inbound rules
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific IP range for better security
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-sg"
    Environment = "development"
  }
}

resource "aws_security_group" "amazon_ec2_security_group" {
  name        = "amazon_ec2_security_group"
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id

  # Inbound rules
  ingress {
    description = "Allow inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules
  egress {
    description = "Allow outbound SSH traffic to front-end subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  tags = {
    Name = "amazon_ec2_security_group"
    Ec2 = "bastion"
  }
}