# AWS RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier              = "mysql-db"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "mydb"
  username                = "admin"
  password                = "$ecurepa$$w0rd" # would pull it from the vault
  vpc_security_group_ids  = [var.db_security_group]
  db_subnet_group_name    = aws_db_subnet_group.mysql_sg.name
  multi_az                = false
  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name = "Backend MySQL-Database"
  }
}

resource "aws_db_subnet_group" "mysql_sg" {
  name        = "mysql-db-subnet-group"
  description = "Subnet group for MySQL"
  subnet_ids  = var.back_end_private_subnet_ids

  tags = {
    Name = "mysql-db-subnet-group"
  }
}