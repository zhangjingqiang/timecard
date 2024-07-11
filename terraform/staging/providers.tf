terraform {
  required_version = ">= 1.0.1"

  required_providers {
    google      = "~> 3.8"
    google-beta = "~> 3.8"
  }
  
  backend "gcs" {
    bucket = "myproj-terraform-bucket"
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

provider "kubernetes" {
  version = "~> 1.11"
}
