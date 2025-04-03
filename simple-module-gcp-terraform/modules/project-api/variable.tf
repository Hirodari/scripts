variable "project_id" {}
variable "gcp_apis" {
  type = list(string)
  default = [
    "admin.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "gkebackup.googleapis.com",
    "containersecurity.googleapis.com",
    "redis.googleapis.com",
    "datamigration.googleapis.com",
    "dns.googleapis.com",
    "networkservices.googleapis.com",
    "certificatemanager.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
  description = "GCP apis needed"
}