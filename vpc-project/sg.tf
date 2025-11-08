#Bastion Security Group
resource "aws_security_group" "bastion-sg" {
  vpc_id = aws_vpc.tier_appliction.id
  name = "bastion-sg"
    description = "allow ssh"
    ingress {
        description = "allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }
    egress {
        description = "all"
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "bastion-sg"
    }
}
#frontend ALB Security Group
resource "aws_security_group" "frontend-alb" {
  vpc_id = aws_vpc.tier_appliction.id
  name = "frontend-alb"
    description = "allow"
    ingress {
        description = "http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }
    ingress {
        description = "https"
        from_port = 443
        to_port = 443
        protocol = "tcp"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "fronted-alb-sg"
    }
}
#web Security Group
resource "aws_security_group" "web-sg" {
  vpc_id = aws_vpc.tier_appliction.id
  name = "web-sg"
    description = "allow"
    ingress {
        description = "ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.bastion-sg.id]
    }
    ingress {
        description = "http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.frontend-alb.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "web-sg"
    }
}

#backend alb Security Group
resource "aws_security_group" "backend-alb" {
  vpc_id = aws_vpc.tier_appliction.id
  name = "backend-alb"
    description = "allow"
    ingress {
        description = "http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.web-sg.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "backend-alb-sg"
    }
}
#app Security Group
resource "aws_security_group" "app-sg" {
  vpc_id = aws_vpc.tier_appliction.id
  name = "app-sg"
    description = "allow"
    ingress {
        description = "http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.backend-alb.id]
    }
    ingress {
        description = "sss"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.bastion-sg.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "app-sg"
    }
}

#db Security Group
resource "aws_security_group" "db-sg" {
  vpc_id = aws_vpc.tier_appliction.id
  name = "db-sg"
    description = "allow"
    ingress {
        description = "mysql"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.app-sg.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "db-sg"
    }
}
