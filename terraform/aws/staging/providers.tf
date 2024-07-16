terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    helm = {
      source  = "hashicorp/helm"
    }
  }
}

provider "aws" {
}

provider "kubernetes" {
  host                   = module.app_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.app_eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "kubernetes" {
  alias = "cluster"

  host                   = module.app_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.app_eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.app_eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(module.app_eks.cluster_certificate_authority_data)
  }
}
