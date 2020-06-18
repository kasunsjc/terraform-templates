provider "aws" {
  region = var.region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "Prod-VPC"
  }

}

resource "aws_subnet" "public_subnet1" {
  cidr_block = var.public_subnet1_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  cidr_block = var.public_subnet2_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name = "PublicSubnet2"
  }
}

resource "aws_subnet" "public_subnet3" {
  cidr_block = var.public_subnet3_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "PublicSubnet3"
  }
}

resource "aws_subnet" "private_subnet1" {
  cidr_block = var.private_subnet1_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "PrivateSubnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  cidr_block = var.private_subnet2_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name = "PrivateSubnet2"
  }
}

resource "aws_subnet" "private_subnet3" {
  cidr_block = var.private_subnet3_cidr
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "PrivateSubnet3"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Private-rt"
  }
}

resource "aws_route_table_association" "public_subnet1_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_subnet1.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_subnet2.id
}

resource "aws_route_table_association" "public_subnet3_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_subnet3.id
}

resource "aws_route_table_association" "private_subnet1_association" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_subnet1.id
}

resource "aws_route_table_association" "private_subnet2_association" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_subnet2.id
}

resource "aws_route_table_association" "private_subnet3_association" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_subnet3.id
}

resource "aws_eip" "elastic_ip_natgw" {
  vpc = true
  #associate_with_private_ip = var.eip_association_address

  tags = {
    Name = "Prod-EIP"
  }
}

resource "aws_nat_gateway" "vpc_nat_gw" {
  allocation_id = aws_eip.elastic_ip_natgw.id
  subnet_id = aws_subnet.public_subnet1.id
}

resource "aws_route" "nat_gw_route" {
  route_table_id = aws_route_table.private_rt.id
  nat_gateway_id = aws_nat_gateway.vpc_nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "vpc_internet_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Prod-IGW"
  }
}

resource "aws_route" "igw_route" {
  route_table_id = aws_route_table.public_rt.id
  gateway_id = aws_internet_gateway.vpc_internet_gw.id
  destination_cidr_block = "0.0.0.0/0"
}
