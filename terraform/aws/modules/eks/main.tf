module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.17"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION          = "true"
          ENABLE_POD_ENI                    = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        }
        enableNetworkPolicy = "true"
      })
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    default = {
      name                 = "default"
      instance_types       = ["m5.large"]
      subnet_ids           = [var.subnet_ids[0], var.subnet_ids[1], var.subnet_ids[2]]
      force_update_version = true

      min_size     = 3
      max_size     = 6
      desired_size = 3

      labels = {
        role = "managed-nodes"
      }

      update_config = {
        max_unavailable_percentage = 50
      }

      private_networking = true

      additional_tags = {
        "k8s.io/cluster-autoscaler/enabled"                            = "true"
        "k8s.io/cluster-autoscaler/${module.eks_cluster.cluster_name}" = "owned"
      }
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress_cluster_to_node_all_traffic = {
      description                   = "Cluster API to Nodegroup all traffic"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = var.tags
}

resource "aws_security_group_rule" "dns_udp" {
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = module.eks_cluster.node_security_group_id
}

resource "aws_security_group_rule" "dns_tcp" {
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = module.eks_cluster.node_security_group_id
}

module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.20"

  role_name_prefix = "ebs-csi-driver-"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks_cluster.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = var.tags
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.1"

  cluster_name      = module.eks_cluster.cluster_name
  cluster_endpoint  = module.eks_cluster.cluster_endpoint
  cluster_version   = module.eks_cluster.cluster_version
  oidc_provider_arn = module.eks_cluster.oidc_provider_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true
  enable_vpa                          = true
  enable_cluster_autoscaler           = true
  enable_kube_prometheus_stack        = true
  enable_argocd                       = true

  metrics_server = {
    name          = "metrics-server"
    chart_version = "3.12.1"
    repository    = "https://kubernetes-sigs.github.io/metrics-server/"
    namespace     = "kube-system"
    values        = []
  }
  vpa = {
    name          = "vpa"
    chart_version = "4.5.0"
    repository    = "https://charts.fairwinds.com/stable"
    namespace     = "vpa"
    values        = []
  }
  cluster_autoscaler = {
    name          = "cluster-autoscaler"
    chart_version = "9.37.0"
    repository    = "https://kubernetes.github.io/autoscaler"
    namespace     = "kube-system"
    values        = []
  }
  kube_prometheus_stack = {
    name          = "kube-prometheus-stack"
    chart_version = "61.3.1"
    repository    = "https://prometheus-community.github.io/helm-charts"
    namespace     = "monitoring"
    values        = []
  }
  argocd = {
    name          = "argocd"
    chart_version = "7.3.6"
    repository    = "https://argoproj.github.io/argo-helm"
    namespace     = "argocd"
    values        = []
  }
}

resource "time_sleep" "addons" {
  create_duration  = "30s"
  destroy_duration = "30s"

  depends_on = [
    module.eks_blueprints_addons
  ]
}

resource "null_resource" "cluster_blocker" {
  depends_on = [
    module.eks_cluster
  ]
}

resource "null_resource" "addons_blocker" {
  depends_on = [
    time_sleep.addons
  ]
}
