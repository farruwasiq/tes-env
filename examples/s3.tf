# An example of creating S3 bucket for backups with retention of 90 days
# and serverside encryption and versioning
# See all the options in https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
# Name of the buckets should be globally unique. we can use `random_string`
# resource to generate a random prefix for our bucket
# Change `backup` to name your bucket

## required files:
# locals.tf
resource "random_string" "bucket_prefix" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "backup" {
  bucket = join("-", [random_string.bucket_prefix.result, local.prefix, "backup"])
  region = var.region

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "retention"
    enabled = true
    expiration {
      days = 90
    }
  }

  tags = local.required_tags
}
