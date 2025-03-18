resource "google_compute_firewall" "default" {
  name    = "ssh"
  network = var.network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = var.source_ranges
}
