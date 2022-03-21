resource "aws_s3_bucket" "source_s3" {
  bucket = "my-source-s3-bucket"

  tags = {
    Name        = "s3_source"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "s3_source" {
  bucket = aws_s3_bucket.source_s3.id
  acl    = "private"
}

resource "aws_s3_bucket_notification" "s3_source_notification" {
  bucket = aws_s3_bucket.source_s3.id

  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }

  depends_on = [
    aws_s3_bucket.source_s3,
    module.lambda_function
  ]
}


resource "aws_s3_bucket" "destination_s3" {
  bucket = "my-destination-s3-bkt"

  tags = {
    Name        = "s3_destination"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_acl" "s3_destination" {
  bucket = aws_s3_bucket.destination_s3.id
  acl    = "private"
}
