# Generate a random suffix for the S3 bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create an S3 bucket for hosting the static website
resource "aws_s3_bucket" "static_website" {
  bucket = "terraform-course-project-1-${random_id.bucket_suffix.hex}"
}

# Configure public access settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket                  = aws_s3_bucket.static_website.id
  # Allow public ACLs (e.g., public read access)
  block_public_acls       = false
  # Allow public bucket policies
  block_public_policy     = false
  # Don't ignore public ACLs
  ignore_public_acls      = false
  # Allow the bucket to be public
  restrict_public_buckets = false
}

# Set up a bucket policy to allow public read access
resource "aws_s3_bucket_policy" "static_website_public_read" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Unique identifier for this policy statement
        Sid       = "PublicReadGetObject"
        # Specifies that this policy allows the defined actions
        Effect    = "Allow"
        # Allows any user or service to access the bucket
        Principal = "*"
        # Permits the GetObject action, which allows retrieval of objects from the bucket
        Action    = "s3:GetObject"
        # Specifies that this policy applies to all objects within the bucket
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}

# Configure the S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Upload the index.html file to the S3 bucket
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  source       = "build/index.html"
  etag         = filemd5("build/index.html")
  content_type = "text/html"
}

# Upload the error.html file to the S3 bucket
resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "error.html"
  source       = "build/error.html"
  etag         = filemd5("build/error.html")
  content_type = "text/html"
}
