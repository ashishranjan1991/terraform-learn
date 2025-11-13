resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block       = var.subnet_1_cidr
  availability_zone = var.az_1

  tags = {
    Name = "${var.vpc_name}-subnet-1"
  }
}
resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block       = var.subnet_2_cidr
  availability_zone = var.az_2
  
  tags = {
    Name = "${var.vpc_name}-subnet-2"
  }
}