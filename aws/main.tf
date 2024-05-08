
module "vpc" {
  source = "./modules/vpc"
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.public_subnet_cidr_block

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.private_subnet_cidr_block

  tags = {
    Name = "private_subnet"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "ec2_server"
  }
}