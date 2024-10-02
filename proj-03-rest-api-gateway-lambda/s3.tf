# Generate a random name for the S3 bucket
# This ensures unique bucket names across AWS, which is required
resource "random_pet" "lambda_bucket_name" {
  # Set a prefix for the bucket name
  prefix = "learn-terraform-lambda"
  # Specify the number of words to add after the prefix
  length = 4
}

# Create an S3 bucket to store Lambda function code
resource "aws_s3_bucket" "lambda_bucket" {
  # Use the randomly generated name for the bucket
  bucket = random_pet.lambda_bucket_name.id
}

# Set ownership controls for the S3 bucket
# This is important for managing access and permissions
resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
  # Reference the S3 bucket we just created
  bucket = aws_s3_bucket.lambda_bucket.id

  # Set the ownership control rule
  rule {
    # "BucketOwnerPreferred" means the bucket owner will own all objects
    object_ownership = "BucketOwnerPreferred"
  }
}

# Set the Access Control List (ACL) for the S3 bucket
resource "aws_s3_bucket_acl" "lambda_bucket" {
  # Ensure this resource is created after the ownership controls
  # This is necessary because changing ownership can affect ACL settings
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket]

  # Reference the S3 bucket
  bucket = aws_s3_bucket.lambda_bucket.id
  # Set the ACL to private, restricting access to only the bucket owner
  acl = "private"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "hello-world.zip"
  source = data.archive_file.lambda_hello_world.output_path
  etag   = filemd5(data.archive_file.lambda_hello_world.output_path)
}