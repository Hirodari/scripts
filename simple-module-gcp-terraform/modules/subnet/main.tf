# locals {
#   gke_pods_range_name = "ip-range-pods"
#   gke_svc_range_name  = "ip-range-svc"

# }

resource "google_compute_subnetwork" "subnet_01" {

  project       = var.project_id
  name          = "${var.vpc_name}-subnet-01"
  region        = var.region
  network       = var.vpc_id
  ip_cidr_range = var.subnet_01_cidr

  # purpose          = "PRIVATE_NAT"
  # subnet_private_access = var.gke_network_subnet_private_access 
  # subnet_flow_logs      = var.gke_network_subnet_flow_logs

  # secondary_ip_range {
  #   range_name    = "subnet-01-secondary-01"
  #   ip_cidr_range = "192.168.64.0/24"
  # }

  secondary_ip_range {
    range_name    = local.gke_pods_range_name
    ip_cidr_range = var.subnet_01_pods_cidr #"192.40.0.0/20"
  }

  secondary_ip_range {
    range_name    = local.gke_svc_range_name
    ip_cidr_range = var.subnet_01_svc_cidr #"192.40.16.0/20"
  }
  depends_on = [var.vpc_id]
}



# Create the second subnet without secondary IP ranges
resource "google_compute_subnetwork" "subnet_02" {
  project       = var.project_id
  name          = "${var.vpc_name}-subnet-02"
  region        = var.region
  network       = var.vpc_id
  ip_cidr_range = var.subnet_02_cidr

  secondary_ip_range {
    range_name    = local.gke_pods_range_name
    ip_cidr_range = var.subnet_02_pods_cidr #"192.40.32.0/20"
  }

  secondary_ip_range {
    range_name    = local.gke_svc_range_name
    ip_cidr_range = var.subnet_02_svc_cidr #"192.40.48.0/20"
  }
  depends_on = [var.vpc_id]
}

# Create an egress route for internet traffic
resource "google_compute_route" "egress_internet" {
  project    = var.project_id
  name       = "${var.vpc_name}-egress-internet"
  network    = var.vpc_id
  dest_range = "0.0.0.0/0"
  # next_hop_internet = true
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  tags             = ["egress-inet"]
  depends_on       = [var.vpc_id]
}
