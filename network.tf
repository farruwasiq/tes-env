resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    name = "dev_igw"
  }

}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id

  }
}

resource "aws_route_table_association" "public_rt_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

}
resource "aws_eip" "nat_eip" {
  vpc = true

}
resource "aws_nat_gateway" "public_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

}
output "nat_gateway_ip" {
  value = aws_eip.nat_eip.public_ip


}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_nat.id

  }

}
resource "aws_route_table_association" "privat_rt_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.private_rt.id

}
