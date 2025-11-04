resource "aws_db_instance" "db" {
    identifier = "rds-test"
    engine = "mysql"
    engine_version = "8.40"
    db_name = "database-1"
    instance_class = var.instance_class
    storage_type = 

    depends_on = [ aws_db_subnet_group.name ]
    
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

resource "aws_db_subnet_group" "name" {
    name = "subnet-group"
    subnet_ids = [ data.aws_subnet.pub-1.id,data.aws_subnet.pub-2.id ]
    tags = {
      Name = "subnet Group"
    }
  
}