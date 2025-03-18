output "firewall_name" {
  description = "Name of the created firewall rule"
  value       = google_compute_firewall.default.name
}
