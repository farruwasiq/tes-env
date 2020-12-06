// This KMS key is shared across all environments for this core workspace (EFS+RDS)
resource "aws_kms_key" "shared" {
  description         = "Temporary AWS Managed Key"
  enable_key_rotation = true
  tags                = local.required_tags
}

resource "aws_kms_alias" "shared" {
  name          = "alias/${var.env}-${var.app}-key"
  target_key_id = aws_kms_key.shared.key_id
}
