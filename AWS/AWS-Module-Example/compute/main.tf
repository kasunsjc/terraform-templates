provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu_latest" {
  owners = ["099720109477"]
  most_recent = true

  filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami = data.aws_ami.ubuntu_latest.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "ec2newkeypair"
  subnet_id = var.public_subnet1_id

  tags = {
    Name = var.instance_name
  }
}


