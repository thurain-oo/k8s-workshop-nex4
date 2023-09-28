provider "aws" {
  region = "ap-southeast-1"  
  profile = "default"
}

resource "aws_vpc" "lab_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "EKS clusters VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = 2
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(["172.16.1.0/24", "172.16.2.0/24"], count.index)
  availability_zone = element(["ap-southeast-1a", "ap-southeast-1b"], count.index)
  tags = {  "kubernetes.io/cluster/${var.Cluster_name}" = "shared"
             "kubernetes.io/role/elb"                      = 1 
  }
}

resource "aws_subnet" "private_subnets" {
  count             = 2
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(["172.16.3.0/24", "172.16.4.0/24"], count.index)
  availability_zone = element(["ap-southeast-1a", "ap-southeast-1b"], count.index)
  tags = { 
    "kubernetes.io/cluster/${var.Cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1 
  } 
}

resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id
}


resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}


resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.public_subnets[0].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = aws_subnet.public_subnets[1].id
  route_table_id = aws_route_table.public_route_table.id
}

