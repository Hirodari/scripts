# module "cloud_nat" {
#   source  = "terraform-google-modules/cloud-nat/google"
#   version = "~> 2.0"
  
#   project_id  = var.project_id
#   region      = var.region
#   router      = google_compute_router.router.name
#   network     = var.vpc_id # google_compute_network.vpc_network.name
# }

  # resource "google_compute_router" "router" {
  #   name    = "cloud-router"
  #   network = var.vpc_id
  #   region  = var.region
  # }

resource "google_compute_router" "router" {
  name    = "odi-dev-router"
  network = var.vpc_id
  region  = var.region

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "odi-dev-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
