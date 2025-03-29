module "cloud_nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 2.0"
  
  project_id  = var.project_id
  region      = var.region
  router      = google_compute_router.router.name
  network     = var.vpc_id # google_compute_network.vpc_network.name
}

  resource "google_compute_router" "router" {
    name    = "cloud-router"
    network = var.vpc_id
    region  = var.region
  }
