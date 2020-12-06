terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region  = var.region
  version = ">= 2.0.0, < 3.0.0"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

// Certificate needs to be imported by Cloud Team

# data "aws_acm_certificate" "wildcard_aws_lllint_com" {
#   domain      = "*.aws.lllint.com"
#   most_recent = true
# }

# Changing the value of `trigger_refresh` variable will force the TFE to
# Update the outputs even if there is no changes
resource "null_resource" "refresher" {
  triggers = {
    trigger = var.trigger_refresh
  }
}
