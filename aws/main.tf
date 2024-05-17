
module "vpc" {
  source = "./modules/vpc"
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name = "tf_public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.private_subnet_cidr_block

  tags = {
    Name = "tf_private_subnet"
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

resource "aws_instance" "web_app" {
  ami           = "ami-0babef7f814da8951"
  subnet_id     = aws_subnet.public_subnet.id
  instance_type = "t3.micro"
  user_data     = <<-EOF
            #!/bin/bash
            echo "Hello World !" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF
  tags = {
    Name = var.name
  }
}

resource "aws_eip" "web_app_eip" {
  instance = aws_instance.web_app.id
  domain   = "vpc"
}