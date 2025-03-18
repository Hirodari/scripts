output "network_self_link" {
  description = "The self link of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "subnet_self_link" {
  description = "The self link of the subnetwork"
  value       = google_compute_subnetwork.subnet.self_link
}
