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
  instance_type = "t3.micro"
  key_name      = aws_key_pair.bastion_key.key_name
  subnet_id     = var.public_subnet_id[0]
  security_groups = [
    var.ssh_bastion_amazon_ec2_security_group
  ]

  tags = {
    Name = "Bastion"
  }
}

# Web app EC2
resource "tls_private_key" "web_app_server_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "web_app_server_key" {
  key_name   = "web_app_server_key"
  public_key = tls_private_key.web_app_server_key.public_key_openssh
}

resource "aws_instance" "apache_server" {
  ami           = "ami-05073582a4b03d785"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.web_app_server_key.key_name
  security_groups = [
    var.web_app_amazon_ec2_security_group
  ]
  subnet_id = var.front_end_private_subnet_id

  # User Data Script to Configure Apache (the web app)
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Apache Web Server</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Apache-Web-Server"
  }
}