#VPC
resource "aws_vpc" "tier_appliction" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name : "3-tier application"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.tier_appliction.id
    tags = {
      Name = "IG"
    }
  
}
#public Subnets
resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.tier_appliction.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "public_subnet-1"
    }
  
}

resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.tier_appliction.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "public_subnet-2"
    }
}

#web Subnets
resource "aws_subnet" "web_1" {
    vpc_id = aws_vpc.tier_appliction.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "web_subnet-1"
    }
}
resource "aws_subnet" "web_2" {
    vpc_id = aws_vpc.tier_appliction.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "web_subnet-2"
    }
}

#app Subnets
resource "aws_subnet" "app_1" {
  vpc_id = aws_vpc.tier_appliction.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.5.0/24"
    tags = {
        Name = "app_subnet-1"
    }
}
resource "aws_subnet" "app_2" {
  vpc_id = aws_vpc.tier_appliction.id
  cidr_block = "10.0.6.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "app_subnet-2"
    }
}

#db Subnets
resource "aws_subnet" "db_1" {
    cidr_block = "10.0.7.0/24"
    vpc_id = aws_vpc.tier_appliction.id
    availability_zone = "us-east-1a"
    tags = {
      Name = "db_subnet-1"
    }
}

resource "aws_subnet" "db_2" {
    cidr_block = "10.0.8.0/24"
    vpc_id = aws_vpc.tier_appliction.id
    availability_zone = "us-east-1b"
    tags = {
      Name = "db_subnet-2"
    }
}

#Public RT
resource "aws_route_table" "rt_public" {
    vpc_id = aws_vpc.tier_appliction.id
    tags = {
      Name = "rt-public"
    }
}

#private RT
resource "aws_route_table" "rt_private" {
    vpc_id = aws_vpc.tier_appliction.id
    tags = {
      Name = "rt-private"
    }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_ip" {
  domain = "vpc"
  tags = {
    Name = "nat-vpc"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_ip.id
    subnet_id = aws_subnet.public_1.id
    tags = {
      Name = "nat"
    }
    depends_on = [ aws_internet_gateway.IG ]
}
#Public Route
resource "aws_route" "ig_route" {
    route_table_id = aws_route_table.rt_public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
}

#Public Subnet Assosiation
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.rt_public.id
}
resource "aws_route_table_association" "public_subnet_2" {
  subnet_id = aws_subnet.public_2.id
  route_table_id = aws_route_table.rt_public.id
}

#Private Subnet Assosiation
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id = aws_subnet.web_1.id
  route_table_id = aws_route_table.rt_private.id
}
resource "aws_route_table_association" "private_subnet_2" {
  subnet_id = aws_subnet.web_2.id
  route_table_id = aws_route_table.rt_private.id
}
resource "aws_route_table_association" "private_subnet_3" {
  subnet_id = aws_subnet.app_1.id
  route_table_id = aws_route_table.rt_private.id
}
resource "aws_route_table_association" "private_subnet_4" {
  subnet_id = aws_subnet.app_2.id
  route_table_id = aws_route_table.rt_private.id
}
resource "aws_route_table_association" "private_subnet_5" {
  subnet_id = aws_subnet.db_1.id
  route_table_id = aws_route_table.rt_private.id
}
resource "aws_route_table_association" "private_subnet_6" {
  subnet_id = aws_subnet.db_2.id
  route_table_id = aws_route_table.rt_private.id
}
# Private Route
resource "aws_route" "pvrt_route" {
    route_table_id = aws_route_table.rt_private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}
