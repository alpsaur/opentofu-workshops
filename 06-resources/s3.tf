resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-${random_id.bucket_suffix.hex}"
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}