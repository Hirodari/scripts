output "k8s_svc_account" {
  description = "The service account for the cluster"
  value       = google_service_account.k8s.email
}