terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "ap-southeast-1" 
}

provider "aws" {
    region = "ap-southeast-2"
    alias = "ap-southeast-2"
}

resource "aws_s3_bucket" "my_bucket_ap_southeast_1" {
    bucket = "my-bucket-tf-05-providers"
    # this will use the default provider ap-southeast-1
}

resource "aws_s3_bucket" "my_bucket_ap_southeast_2" {
    bucket = "my-bucket-tf-05-providers"
    provider = aws.ap-southeast-2
}