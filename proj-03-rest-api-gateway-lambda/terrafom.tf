terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # random is used to generate random names for resources
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    # archive is used to create a zip archive of the Lambda function code
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.2"
    }
  }
}