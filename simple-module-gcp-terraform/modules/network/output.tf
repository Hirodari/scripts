output "vpc_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}

output "vpc_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "static_ip_name" {
  description = "The name of odi-wallet-app-global-ip"
  value       = google_compute_global_address.odi-wallet-app-global-ip.name
}
