# Create a new VPC (Virtual Private Cloud)
# A VPC is a virtual network dedicated to your AWS account
resource "aws_vpc" "main" {
  # Define the CIDR block for the VPC
  # This specifies the IP address range for the entire VPC
  cidr_block = "10.0.0.0/16"

  # Add tags to the VPC for better organization and identification
  # Tags are key-value pairs that can be used to categorize and manage AWS resources
  tags = {
    Project = local.project  # Use the project name from local variables
    Name    = local.project  # Set the Name tag to the project name
  }
}

# Create subnets within the VPC
# Subnets are subdivisions of a VPC, each with its own IP address range
resource "aws_subnet" "main" {
  # Use for_each to create multiple subnets based on the subnet_config variable
  # for_each allows us to create multiple similar resources efficiently
  for_each = var.subnet_config

  # Associate the subnet with the VPC we created above
  # This ensures the subnet is part of our defined VPC
  vpc_id = aws_vpc.main.id

  # Set the CIDR block for this specific subnet
  # This is a subset of the VPC's CIDR block
  cidr_block = each.value.cidr_block

  # Add tags to the subnet for better organization and identification
  tags = {
    Project = local.project  # Use the project name from local variables
    Name    = "${local.project}-${each.key}"  # Create a unique name for each subnet
  }
}