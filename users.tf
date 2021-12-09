module "a_user" {
  source    = "cloudposse/iam-system-user/aws"
  version   = "0.20.2"
  namespace = "metadata_exif_dev"
  stage     = "dev"
  name      = "write_user"

  inline_policies_map = {
    s3 = data.aws_iam_policy_document.s3_policy_a_user.json
  }

  tags = local.common_tags
}

data "aws_iam_policy_document" "s3_policy_a_user" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      "${module.s3_bucket_a.s3_bucket_arn}/*",
      "${module.s3_bucket_a.s3_bucket_arn}"
    ]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      "${aws_kms_key.s3_kms_key.arn}"
    ]
  }
}

module "b_user" {
  source    = "cloudposse/iam-system-user/aws"
  version   = "0.20.2"
  namespace = "metadata_exif_dev"
  stage     = "dev"
  name      = "read_user"

  inline_policies_map = {
    s3 = data.aws_iam_policy_document.s3_policy_b_user.json
  }

  tags = local.common_tags
}

data "aws_iam_policy_document" "s3_policy_b_user" {

  statement {
    actions = [
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      "${module.s3_bucket_b.s3_bucket_arn}/*",
      "${module.s3_bucket_b.s3_bucket_arn}"
    ]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      "${aws_kms_key.s3_kms_key.arn}"
    ]
  }
}
