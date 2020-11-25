resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    name = "main_vpc"
  }

}
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet
  availability_zone = "us-east-1a"
  tags = {
    name = "public_subnet"
  }

}
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet
  availability_zone = "us-east-1a"
  tags = {
    name = "private_subnet"
  }

}
