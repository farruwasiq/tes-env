/*
data "aws_ami" "centos" {
  most_recent = true
  owners      = ["013306225745"]

  filter {
    name   = "name"
    values = ["Centos Linux 7 x86_64 HVM EBS *"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]

  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
data "aws_ami" "windows" {
  owners      = ["013306225745"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Microsoft Windows Server 2019 Base"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "latest-ubuntu" {
    most_recent = true
    owners = ["013306225745"] # Canonical

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}
*/