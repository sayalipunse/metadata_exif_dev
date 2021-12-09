resource "aws_kms_key" "s3_kms_key" {
  description             = "kms key to encrypt s3 object"
  deletion_window_in_days = 7
  tags                    = local.common_tags
}

resource "aws_kms_alias" "s3_kms_key" {
  name          = "alias/my_s3_kms_key_alias"
  target_key_id = aws_kms_key.s3_kms_key.key_id
}
