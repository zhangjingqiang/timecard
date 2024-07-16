terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.57.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.31.0"
      configuration_aliases = [ kubernetes.cluster, kubernetes.addons ]
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.14.0"
    }
  }
}
