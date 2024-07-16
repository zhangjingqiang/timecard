output "configure_kubectl" {
  description = "Command to update kubeconfig for this cluster"
  value       = module.app_eks.configure_kubectl
}
