output "cluster_name" {
  description = "The ID of the VPC network"
  value       = module.gke.name
}

output "endpoint" {
  description = "The private endpoint of the GKE cluster master"
  value       = module.gke.endpoint
}

output "cluster_ca_certificate" {
  description = "The CA certificate for the cluster"
  value       = module.gke.ca_certificate
}