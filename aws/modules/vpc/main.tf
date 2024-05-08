# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
}