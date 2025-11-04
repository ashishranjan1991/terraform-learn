resource "aws_db_instance" "db1" {
    identifier = "rds-test"
    engine = "mysql"
    engine_version = "8.0"
    db_name = "database1"
    instance_class = var.instance_class
    allocated_storage = 10
    username = "admin"
    password = "ashish111111"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true
    publicly_accessible = false
    db_subnet_group_name = aws_db_subnet_group.dbsubnet.name
    backup_retention_period = 7
    apply_immediately = true
    depends_on = [ aws_db_subnet_group.dbsubnet ]
    
}

resource "aws_db_instance" "readreplica" {
    identifier = "read-replica"
    replicate_source_db = aws_db_instance.db1.identifier
    instance_class = var.instance_class
    publicly_accessible = false
    depends_on = [ aws_db_instance.db1 ]
}

data "aws_subnet" "pub-1" {
    filter {
      name = "tag:Name"
      values = [ "public-1" ]

    }
}

data "aws_subnet" "pub-2" {
  filter {
    name = "tag:Name"
    values = [ "public-2" ]
  }
}

resource "aws_db_subnet_group" "dbsubnet" {
    name = "subnet-group-1"
    subnet_ids = [ data.aws_subnet.pub-1.id,data.aws_subnet.pub-2.id ]
    tags = {
      Name = "subnet Group-1"
    }
  
}