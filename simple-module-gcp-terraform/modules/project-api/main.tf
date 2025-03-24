resource "google_project_service" "project-apis-to-enable" {
  for_each = toset(var.gcp_apis)
  project = var.project_id 
  service = each.key 

  timeouts {
    create = "30m" 
    update = "40m"
  }

  disable_dependent_services = true

  # Configure whether to disable the service when the resource is destroyed (default is `false`).
  disable_on_destroy = var.disable_services_on_destroy
  depends_on = [data.google_client_config.config]
}


variable "disable_services_on_destroy" {
  type    = bool
  default = false 
}
