# Bastion EC2
# SSH key-pair to inject into ec2
# To see the value of private key that needed to ssh to the bastion run terraform output --raw ssh_key
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion_key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

# EC@ instance
resource "aws_instance" "ssh_bastion" {
  ami           = "ami-0c6f9998440436fb9" # Red Hat 9 AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.bastion_key.key_name
  subnet_id     = var.public_subnet_id
  security_groups = [
    var.ssh_bastion_amazon_ec2_security_group
  ]

  tags = {
    Name = "Bastion"
  }
}