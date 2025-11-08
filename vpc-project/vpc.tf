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
resource "aws_subnet" "public-1" {
    vpc_id = aws_vpc.tier_appliction.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "public_subnet-1"
    }
  
}

resource "aws_subnet" "public-2" {
    vpc_id = aws_vpc.tier_appliction.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "public_subnet-2"
    }
}

#web Subnets
resource "aws_subnet" "web-1" {
    vpc_id = aws_vpc.tier_appliction.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "web_subnet-1"
    }
}
resource "aws_subnet" "web-2" {
    vpc_id = aws_vpc.tier_appliction.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "web_subnet-2"
    }
}

#app Subnets
resource "aws_subnet" "app-1" {
  vpc_id = aws_vpc.tier_appliction.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.5.0/24"
    tags = {
        Name = "app_subnet-1"
    }
}
resource "aws_subnet" "app-2" {
  vpc_id = aws_vpc.tier_appliction.id
  cidr_block = "10.0.6.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "app_subnet-2"
    }
}

#db Subnets
resource "aws_subnet" "db-1" {
    cidr_block = "10.0.7.0/24"
    vpc_id = aws_vpc.tier_appliction.id
    tags = {
      Name = "db_subnet-1"
    }
}

resource "aws_subnet" "db-2" {
    cidr_block = "10.0.8.0/24"
    vpc_id = aws_vpc.tier_appliction.id
    tags = {
      Name = "db_subnet-2"
    }
}

#Public RT
resource "aws_route_table" "rt-public" {
    vpc_id = aws_vpc.tier_appliction.id
    tags = {
      Name = "rt-public"
    }
}

#private RT
resource "aws_route_table" "rt-private" {
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
    subnet_id = aws_subnet.subnet-1.id
    tags = {
      Name = "nat"
    }
    depends_on = [ aws_internet_gateway.IG ]
}
#Public Route
resource "aws_route" "ig-route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
}

#Public Subnet Assosiation
resource "aws_route_table_association" "public_subnet-1" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt-public.id
}
resource "aws_route_table_association" "public_subnet-2" {
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt-public.id
}

#Private Subnet Assosiation
resource "aws_route_table_association" "private_subnet-1" {
  subnet_id = aws_subnet.web-1.id
  route_table_id = aws_route_table.rt-private.id
}
resource "aws_route_table_association" "private_subnet-2" {
  subnet_id = aws_subnet.web-2.id
  route_table_id = aws_route_table.rt-private.id
}
resource "aws_route_table_association" "private_subnet-3" {
  subnet_id = aws_subnet.app-1.id
  route_table_id = aws_route_table.rt-private.id
}
resource "aws_route_table_association" "private_subnet-4" {
  subnet_id = aws_subnet.app-2.id
  route_table_id = aws_route_table.rt-private.id
}
resource "aws_route_table_association" "private_subnet-5" {
  subnet_id = aws_subnet.db-1.id
  route_table_id = aws_route_table.rt-private.id
}
resource "aws_route_table_association" "private_subnet-6" {
  subnet_id = aws_subnet.db-2.id
  route_table_id = aws_route_table.rt-private.id
}
# Private Route
resource "aws_route" "pvrt-route" {
    route_table_id = aws_route_table.rt-private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}
