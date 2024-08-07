data "aws_region" "current" {}

data "aws_eks_cluster_auth" "this" {
  name = module.app_eks.eks_cluster_id

  depends_on = [
    null_resource.cluster_blocker
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.app_eks.eks_cluster_id
}

resource "null_resource" "cluster_blocker" {
  triggers = {
    "blocker" = module.app_eks.cluster_blocker_id
  }
}
