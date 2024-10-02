
provider "aws" {
  # Set the AWS region where resources will be created
  # The value is pulled from a variable, allowing for flexibility
  region = var.aws_region

  # Set default tags for all resources created by this provider
  # Tags are key-value pairs used for organizing and tracking AWS resources
  default_tags {
    tags = {
      # This tag indicates that the resource is part of the "lambda-api-gateway" learning module
      hashicorp-learn = "lambda-api-gateway"
    }
  }
}
