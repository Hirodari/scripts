terraform {
  backend "gcs" {
    bucket = "odi-dev-backend-bucket"  # Replace with your GCS bucket name
    prefix = "terraform/kareco-infrastructure"
  }
}
