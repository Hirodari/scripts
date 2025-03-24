output "vpc_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}
