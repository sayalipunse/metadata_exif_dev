module "s3_bucket_a" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "my-bucket-s3-a"
  acl           = "private"
  force_destroy = true


  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.s3_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = local.common_tags
}

resource "aws_s3_bucket_notification" "s3_bucket_a_notification" {
  bucket = module.s3_bucket_a.s3_bucket_id

  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }

  depends_on = [
    module.s3_bucket_a,
    module.lambda_function
  ]
}

module "s3_bucket_b" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "my-bucket-s3-b"
  acl           = "private"
  force_destroy = true


  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.s3_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = local.common_tags

}
