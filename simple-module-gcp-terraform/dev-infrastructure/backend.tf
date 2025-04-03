# terraform {
#   backend "gcs" {
#     bucket = "odi-dev-backend-bucket" # Replace with your GCS bucket name
#     prefix = "terraform/kareco-infrastructure"
#   }
#   required_providers {
#     time = {
#       source = "hashicorp/time" # Source of the 'time' provider (from HashiCorp)
#     }
#     google = {
#       source  = "hashicorp/google"
#       version = ">= 3.53.0, < 7.0.0" # 4.64.0
#     }
#     google-beta = {
#       source  = "hashicorp/google-beta"
#       version = ">= 3.53.0, < 7.0.0" # 4.64.0
#     }
#   }
# }

terraform {
  backend "gcs" {
    bucket = "odi-dev-backend-bucket" 
    prefix = "terraform/kareco-infrastructure"
  }
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = ">= 0.8.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 6.14.0, < 7.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.14.0, < 7.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}