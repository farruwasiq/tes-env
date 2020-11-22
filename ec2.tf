provider "aws" {
  region = "us-east-1"
  availblitiy_zone="us-west-2a"

}
resource "aws_instance" "test-dev" {
  instance_type = "t2.nano"
  ami           = " ami-04bf6dcdc9ab498ca"
  tags="tes-dev"
  name ="tes-dev"

}
resource "aws_instance" "test-stg" {
  instance_type = "t2.nano"
  ami           = " ami-04bf6dcdc9ab498ca"
  name="test-stg"
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-19b27a64"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.168.0.1/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_tls"
  }
}
