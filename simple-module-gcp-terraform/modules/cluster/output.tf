output "cluster_name" {
  description = "The ID of the VPC network"
  value       = google_container_cluster.gke_main.name
}

output "endpoint" {
  description = "The private endpoint of the GKE cluster master"
  value       = google_container_cluster.gke_main.endpoint
}

output "cluster_ca_certificate" {
  description = "The CA certificate for the cluster"
  value       = google_container_cluster.gke_main.master_auth[0].cluster_ca_certificate
}