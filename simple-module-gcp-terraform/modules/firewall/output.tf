output "allow_https_fr_name" {
  description = "The ID of the VPC network"
  value       = google_compute_firewall.allow_http_https.name
}