# allow http and https traffic from outside

resource "google_compute_firewall" "allow_http_https" {
  name        = "allow-https-traffic"
  description = "Allow http/s traffic from internet"
  network     = var.vpc_id

  direction = "INGRESS"
  priority  = 500

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  #   target_tags   = ["gke-${var.gke_name}"]
  source_ranges = ["0.0.0.0/0"]
  depends_on    = [var.vpc_id]
}


# allow internal traffic to reach mysql and redis ports
resource "google_compute_firewall" "allow_internal_traffic" {
  #   count       = var.create_new_network ? 1 : 0
  name        = "allow-internal-traffic-odi"
  description = <<EOF
                  This rule allows only internal required ports:
                  - MySQL: 3306
                  - Redis: 6379
                  - HTTP: 80
                  - HTTPS: 443
                  - DNS resolution: 53 (both TCP and UDP)
                  - Kustomize-controller: 9090
                  - GitOps: 9001
                  - Kubernetes API: 10250
                  - Flux Kustomization: 8443
                  EOF
  network     = var.vpc_id

  direction = "INGRESS"
  priority  = 600

  allow {
    protocol = "tcp"
    ports    = ["53", "80", "443", "3306", "3307", "6379", "8443", "9001", "9090", "10250"]
  }

  allow {
    protocol = "udp"
    ports    = ["53"] # 53 UDP is DNS port, very important for pods to communicate
  }

  source_ranges = ["10.10.10.0/24", "10.10.20.0/24", "10.10.0.0/16", "192.40.0.0/16", "192.50.0.0/16", "192.168.64.0/24", "10.29.237.0/24"] # Include both node and pod CIDRs
  #   target_tags   = ["gke-${var.gke_name}"]
  depends_on = [var.vpc_id]
}

# Firewall rule to deny all incoming traffic (default deny-all rule)
resource "google_compute_firewall" "deny_all_incoming" {
  #   count   = var.create_new_network ? 1 : 0 # Only create the firewall rule if a new network is created.
  name    = "deny-all-incoming-odi" # Name of the firewall rule.
  network = var.vpc_id              # Apply the rule to the VPC network created above.

  direction = "INGRESS" # Applies to incoming traffic.
  priority  = 1000      # Priority of the rule (higher number means lower priority).

  deny { # Denies all incoming traffic by default.
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"] # Applies to all incoming traffic from any source.
  #   target_tags   = ["gke-${var.gke_name}"]
  depends_on = [var.vpc_id]
}