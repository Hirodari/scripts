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

output "node_pools_instance_group_urls" {
  description = "Instance group URLs for each node pool in the GKE cluster."
  # value       = module.gke.node_pools_instance_group_urls
  value       = module.gke.instance_group_urls
}