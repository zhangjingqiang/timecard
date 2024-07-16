module "storage" {
  source        = "../common/modules/storage"
  gcp_project   = var.gcp_project
  gcp_region    = var.gcp_region
  bucket_prefix = var.bucket_prefix
}