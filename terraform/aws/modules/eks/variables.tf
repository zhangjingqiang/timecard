variable "cluster_name" {
  description = "EKS cluster name."
  type = string
}

variable "cluster_version" {
  description = "EKS cluster version."
  type        = string
}

variable "tags" {
  description = "List of tags to be associated with resources."
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID used to create EKS cluster."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC ID used to create EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs used by EKS cluster nodes."
  type        = list(string)
}
