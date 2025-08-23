module "compute" {
  source      = "./compute"
  environment = var.environment
  app_name    = local.name
  tags        = local.tags
  region      = local.region

  vpc_id              = module.vpc.vpc_id
  vpc_public_subnets  = module.vpc.public_subnets
  vpc_private_subnets = module.vpc.private_subnets

  ec2_web_instance_ami_id = var.ec2_web_instance_ami_id
  ec2_web_instance_type   = var.ec2_web_instance_type
  ec2_web_key_name        = var.ec2_web_key_name

  eks_kubernetes_version = var.eks_kubernetes_version
  eks_node_instance_type = var.eks_node_instance_type
  eks_min_size           = var.eks_min_size
  eks_max_size           = var.eks_max_size
  eks_desired_size       = var.eks_desired_size
}

module "database" {
  source      = "./database"
  environment = var.environment
  app_name    = local.name
  tags        = local.tags
  region      = local.region

  vpc_id              = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets
  security_group_eks  = module.compute.security_group_eks
  security_group_web  = module.compute.security_group_web
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "vpc-${local.name}-${var.environment}"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 52)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

data "aws_availability_zones" "available" {
  # Exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}