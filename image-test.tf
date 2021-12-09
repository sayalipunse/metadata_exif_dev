data "external" "download_sample_image" {
  count   = var.image_test ? 1 : 0
  program = ["bash", "${path.module}/sample_image/download_sample_image.sh"]

  query = {
      url                  = "https://github.com/ianare/exif-samples/raw/master/jpg/exif-org/fujifilm-mx1700.jpg"
      destination_filename = "${path.module}/sample_image/my_test.jpg"
  }
}

resource "aws_s3_bucket_object" "test_sample_image" {
  count  = var.image_test ? 1 : 0
  bucket = module.s3_bucket_a.s3_bucket_id
  key    = "test/my_test.jpg"
  source = "${path.module}/${data.external.download_sample_image[0].result.file}"
  etag   = filemd5("${path.module}/${data.external.download_sample_image[0].result.file}")
  depends_on = [
    data.external.download_sample_image,
    module.lambda_function,
    aws_lambda_permission.allow_bucket_trigger
  ]
}