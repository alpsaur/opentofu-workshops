# This is not a valid Terraform file. It is just an example of HCL.

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Managed by Terraform
resource "aws_s3_bucket" "my_bucket" {
    bucket = var.bucket_name
}

# Managed somewhere else
data "aws_s3_bucket" "my_ext_bucket" {
    bucket = "my-sample-data-bucket"
}

variable "bucket_name" {
    type = string
    description = "The name of the S3 bucket"
    default = "my-sample-bucket"
}

output "bucket_id" {
    value = aws_s3_bucket.my_bucket.id
}

locals {
    local_example = "This is a local value"
}

module "my_module" {
    source = "./modules/my_module"
    input_variable = local.local_example
}