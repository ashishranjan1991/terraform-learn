resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = [var.subnet_1, var.subnet_2]

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
  
}

resource "aws_db_instance" "db_instance" {
  identifier         = var.db_identifier
  instance_class     = var.instance_class
  allocated_storage  = var.db_allocated_storage
  engine             = "mysql"
  engine_version     = "8.0" 
  db_name            = var.db_name
  username           = var.username
  password           = var.password
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot = true

  tags = {
    Name = var.db_identifier
  }
  
}