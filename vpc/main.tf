resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "3-tier project"
    }  
}

#Subnet Creation
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
      Name = "public-subnet-1"
    } 
}
resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      Name = "public-subnet-2"
    }
}

resource "aws_subnet" "web-layer-1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "web-layer-1"
    }
}
resource "aws_subnet" "web-layer-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "web-layer-2"
    }
}
resource "aws_subnet" "app-layer-1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.5.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "app-layer-1"
    }
}
resource "aws_subnet" "web-layer-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.6.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "app-layer-2"
    }
}

resource "aws_subnet" "db-layer-1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.7.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "db-layer-1"
    }
}
resource "aws_subnet" "db-layer-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.8.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "db-layer-2"
    }
}

resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "project-ig"
    }  
}

#Public RT
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "public_RT"
  }
}

#Public Route
resource "aws_route" "name" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
}

#Public Subnet Assosiation
resource "aws_route_table_association" "public_subnet-1" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_subnet-2" {
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.public_rt.id
}

#elastic ip
resource "aws_eip" "nat_ip" {
  domain = "vpc"
  tags = {
    Name = "nat_ip"
  }
}

#Nat Creation
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_ip.id
    subnet_id = aws_route_table_association.public_subnet-1.id
    tags = {
      Name = "nat"
    }
    depends_on = [ aws_internet_gateway.IG ]
}

#Priavte Route Table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "private-RT"
  }
}

resource "aws_route" "pvrt-route" {
    route_table_id = aws_route_table.private-rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

#private subnet assosiation
resource "aws_route_table_association" "web-1" {
    subnet_id = aws_subnet.web-layer-1.id
    route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "web-2" {
    subnet_id = aws_subnet.web-layer-2.id
    route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "app-1" {
    subnet_id = aws_subnet.app-layer-1.id
    route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "app-2" {
    subnet_id = aws_subnet.app-layer-2.id
    route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "db-1" {
    subnet_id = aws_subnet.db-layer-1.id
    route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "db-2" {
    subnet_id = aws_subnet.db-layer-2.id
    route_table_id = aws_route_table.private-rt.id
}
#security Group
resource "aws_security_group" "bation" {
  name = "bastion-sg"
  description = "allow ssh"
  vpc_id = aws_vpc.name.id
  ingress {
    description = "allow ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "all"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "frontend-alb" {
  name = "frontend-alb"
  description = "allow"
  vpc_id = aws_vpc.name.id
  ingress {
    description = "http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "https"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "fronted-alb-sg"
  }
}

resource "aws_security_group" "web-sg" {
  name = "web-sg"
  description = "allow"
  vpc_id = aws_vpc.name.id
  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.bation.id ]
  }
  ingress {
    description = "http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.frontend-alb.id ]
  }
  ingress {
    description = "https"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [ aws_security_group.frontend-alb.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "web-sg"
  }
}

resource "aws_security_group" "backend-sg" {
  name = "backend-sg"
  description = "allow"
  vpc_id = aws_vpc.name.id
  ingress {
    description = "allow-shh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.bation.id ]
  }
  ingress {
    description = "http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.web-sg.id ]
  }
   ingress {
    description = "https"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [ aws_security_group.web-sg.id ]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "app-sg"
  }
}

resource "aws_security_group" "db-sb" {
  name = "db-sg"
  description = "allow"
  vpc_id = aws_vpc.name.id
  ingress {
    description = "mqysql"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [ aws_security_group.backend-sg.id ]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_instance" "bastion" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet-1.id
  security_groups = [ aws_security_group.bation.id ]
  tags = {
    Name = "bastion Host"
  }
}

resource "aws_instance" "web-server" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.web-layer-1
    security_groups = [ aws_security_group.web-sg.id ]
    tags = {
      Name = "web-server"
    }
}

resource "aws_instance" "app-server" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.app-layer-1
  security_groups = [ aws_security_group.backend-sg.id ]

}

resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "db-subnet-group"
    subnet_ids = [ aws_subnet.db-layer-1.id,aws_subnet.db-layer-2.id ]
    description = "this is subnet group for DB"
}

resource "aws_db_instance" "mydb" {
    identifier = "my-rds-db"
    engine = "mysql"
    db_name = "database"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    allocated_storage = 20
    username = "admin"
    password = "12345678"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true
    publicly_accessible = false
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [ aws_security_group.db-sb.id ]

    depends_on = [ aws_db_subnet_group.rds_subnet_group ]
}

