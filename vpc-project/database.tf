# Create a DB subnet group for the RDS instance
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.db_1.id,aws_subnet.db_2.id]

  tags = {
    Name = "db-subnet-group"
  }
  
}

# Create the RDS MySQL instance
resource "aws_db_instance" "my_db" {
  identifier              = "mydb-instance"
  allocated_storage       = var.db_allocated_storage
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  depends_on              = [aws_db_subnet_group.db_subnet_group]  
  backup_retention_period = 7
  tags = {
    Name = "mydb-instance"
  }
}

# Create a read replica of the RDS instance
resource "aws_db_instance" "db-read-replica" {
  identifier              = "mydb-read-replica"
  replicate_source_db     = aws_db_instance.my_db.arn
  instance_class          = var.instance_class
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  depends_on              = [aws_db_instance.my_db]
  
  tags = {
    Name = "mydb-read-replica"
  }
  
}