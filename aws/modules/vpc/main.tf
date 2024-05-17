# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "vpc-gateway"
  }
}