# Create a zip archive of the hello-world directory
data "archive_file" "lambda_hello_world" {
  type        = "zip"
  source_dir  = "${path.module}/hello-world"
  output_path = "${path.module}/build/hello-world.zip"
}

#  path.module is a special Terraform variable that represents the filesystem path 
#  of the module where the expression is defined.