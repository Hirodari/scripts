resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = var.create_subnetworks
  routing_mode            = var.network_routing_mode
  mtu                     = 1460

}

# Create an egress route for internet traffic
resource "google_compute_route" "egress_internet" {
  project    = var.project_id
  name       = "${var.vpc_name}-egress-internet"
  network    = google_compute_network.vpc_network.id # var.vpc_id
  dest_range = "0.0.0.0/0"
  # next_hop_internet = true
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  tags             = ["egress-inet"]
  depends_on       = [ google_compute_network.vpc_network]
}



