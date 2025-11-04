resource "aws_vpc" "vpc1" {
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "vpc_1"
    }
}

resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/24"
  tags = {
    Name = "vpc-2"
  }
}

resource "aws_internet_gateway" "ig_1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name : "IG-1"
  }
}

resource "aws_internet_gateway" "ig_2" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name : "IG-2"
  }
}

resource "aws_vpc_peering_connection" "vpc_peering" {
    vpc_id = aws_vpc.vpc1.id
    peer_vpc_id = aws_vpc.vpc2.id
    auto_accept = true
    tags = {
      Name : "peering"
    }
}

resource "aws_route_table" "rt_1" {
    vpc_id = aws_vpc.vpc1.id
    tags = {
      Name : "pub-rt-1"
    }
}
resource "aws_route_table" "rt_2" {
    vpc_id = aws_vpc.vpc2.id
    tags = {
      Name : "pub-rt-2"
    }
}
resource "aws_route" "vpc1_to_vpc2" {
    route_table_id = aws_route_table.rt_1.id
    destination_cidr_block = aws_vpc.vpc2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "vpc2_to_vpc1" {
    route_table_id = aws_route_table.rt_2.id
    destination_cidr_block = aws_vpc.vpc1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
