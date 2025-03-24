terraform {
  backend "gcs" {
    bucket = "odi-dev-backend-bucket" # Replace with your GCS bucket name
    prefix = "terraform/kareco-infrastructure"
  }
  required_providers {
    time = {
      source = "hashicorp/time" # Source of the 'time' provider (from HashiCorp)
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.64.0, < 7.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.64.0, < 7.0.0"
    }
  }
}
