module "tags" {
  source = "../modules/tags"

  environment_name = var.environment_name
}

module "vpc" {
  source = "../modules/vpc"

  environment_name = var.environment_name

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }

  tags = module.tags.result
}

module "app_eks" {
  source = "../modules/eks"

  providers = {
    kubernetes.cluster = kubernetes.cluster
    kubernetes.addons  = kubernetes

    helm = helm
  }

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.inner.vpc_id
  vpc_cidr        = module.vpc.inner.vpc_cidr_block
  subnet_ids      = module.vpc.inner.private_subnets
  tags            = module.tags.result
}
