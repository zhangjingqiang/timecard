resource "google_storage_bucket" "access_logs_source" {
  name          = "${var.bucket_prefix}-access-logs-source"
  storage_class = "REGIONAL"
  project       = var.gcp_project
  location      = var.gcp_region
}

resource "google_storage_bucket" "access_logs_error" {
  name          = "${var.bucket_prefix}-access-logs-error"
  storage_class = "REGIONAL"
  project       = var.gcp_project
  location      = var.gcp_region
}

resource "google_storage_bucket" "access_logs_success" {
  name          = "${var.bucket_prefix}-access-logs-success"
  storage_class = "COLDLINE"
  project       = var.gcp_project
  location      = var.gcp_region
}

resource "google_storage_bucket" "action_logs_source" {
  name          = "${var.bucket_prefix}-action-logs-source"
  storage_class = "REGIONAL"
  project       = var.gcp_project
  location      = var.gcp_region
}

resource "google_storage_bucket" "action_logs_error" {
  name          = "${var.bucket_prefix}-action-logs-error"
  storage_class = "REGIONAL"
  project       = var.gcp_project
  location      = var.gcp_region
}

resource "google_storage_bucket" "action_logs_success" {
  name          = "${var.bucket_prefix}-action-logs-success"
  storage_class = "COLDLINE"
  project       = var.gcp_project
  location      = var.gcp_region
}