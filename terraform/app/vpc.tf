locals {

  vpc_env    = var.env == "prd" || var.env == "stg" ? var.env : "npd"
  vpc_prefix = join("-", [local.vpc_env, var.app, "vpc"])
}
/*
resource "aws_vpc" "dev-tes-vpc" {
  cidr_block="10.212.210.0/24"

}*/

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_prefix]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_subnet" "public" {
  for_each = data.aws_subnet_ids.public.ids
  id       = each.value
}
