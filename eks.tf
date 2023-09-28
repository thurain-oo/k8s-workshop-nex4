module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = var.Cluster_name
  cluster_version = "1.27"

  vpc_id                         = aws_vpc.lab_vpc.id
  subnet_ids                     = [aws_subnet.private_subnets[0].id,aws_subnet.private_subnets[1].id]
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    thurain_ng = {
      name = "${var.Cluster_name}-ng"

      instance_types = ["m4.large"]

      min_size     = var.min
      max_size     = var.max
      desired_size = var.desired
    }

  }
}




