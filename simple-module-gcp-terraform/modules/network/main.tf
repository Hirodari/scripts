resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = var.create_subnetworks
  routing_mode            = var.network_routing_mode
  mtu                     = 1460

}


