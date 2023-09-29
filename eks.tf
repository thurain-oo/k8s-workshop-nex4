provider "aws" {
  region = "ap-southeast-1"  
}

# Data blocks to fetch VPC and subnet IDs
data "aws_vpc" "existing_vpc" {
  tags = {
    Name = "EKS clusters VPC"
  }
}

data "aws_subnets" "public_subnets" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }

  # You can filter public subnets based on tags or other criteria
  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}

data "aws_subnets" "private_subnets" {
  
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }

  # You can filter private subnets based on tags or other criteria
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = var.Cluster_name
  cluster_version = "1.28"

  vpc_id                         = data.aws_vpc.existing_vpc.id
  subnet_ids                     = data.aws_subnets.private_subnets.ids
  cluster_endpoint_public_access = true
  


  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "${var.Cluster_name}-ng"

      instance_types = ["m4.large"] 

      min_size     = var.min
      max_size     = var.max
      desired_size = var.desired
    }

  }
}

