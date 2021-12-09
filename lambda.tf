module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "metadata-exif-lambda"
  description   = "lambda function to clean up exif metadata from jpg images"
  handler       = "metadata_exif_lambda.lambda_handler"
  runtime       = "python3.8"

  source_path = "${path.module}/lambda_code/metadata_exif_lambda.py"

  environment_variables = {
    destination_s3_bucket = module.s3_bucket_b.s3_bucket_id
  }

  kms_key_arn = aws_kms_key.s3_kms_key.arn

  policy        = aws_iam_policy.lambda_metadata_exif_dev.arn
  attach_policy = true

  layers = [
    module.metadata_exif_lambda_layer_s3.lambda_layer_arn,
  ]

  create_current_version_allowed_triggers = false
  allowed_triggers = {
    S3_trigger = {
      service    = "s3"
      source_arn = module.s3_bucket_a.s3_bucket_arn
    }
  }

  tags = local.common_tags
  depends_on = [
    module.s3_bucket_a
  ]
}

module "metadata_exif_lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "metadata-exif-lambda-layer"
  description         = "Python Lambda Layer with exif and plum"
  compatible_runtimes = ["python3.8"]

  source_path = "${path.module}/lambda_code/layer/"
}

resource "aws_iam_policy" "lambda_metadata_exif_dev" {
  name        = "lambda_metadata_exif_dev_policy"
  description = "A policy for lambda to access s3 bucket and KMS"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${module.s3_bucket_a.s3_bucket_arn}/*",
                "${module.s3_bucket_a.s3_bucket_arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "${module.s3_bucket_b.s3_bucket_arn}/*",
                "${module.s3_bucket_b.s3_bucket_arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": [
                "${aws_kms_key.s3_kms_key.arn}"
            ]
        }    
    ]
}
EOF
}

resource "aws_lambda_permission" "allow_bucket_trigger" {
  statement_id  = "AllowExecutionFromS3Bucket1"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3_bucket_a.s3_bucket_arn

  depends_on = [
    module.s3_bucket_a,
    module.lambda_function
  ]
}
