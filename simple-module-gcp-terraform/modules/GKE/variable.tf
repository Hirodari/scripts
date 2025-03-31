# cluster attributes
variable "project_id" {}
variable "cluster_name" {}
variable "region" {}
variable "zones" {
  type = list(string)
  default = [
    "africa-south1-a",
    "africa-south1-b",
    "africa-south1-c"
  ]
  description = "Cluster zone to deploy into"
}

locals {
  gke_pods_range_name = "ip-range-pods"
  gke_svc_range_name  = "ip-range-svc"

}
variable "network_name" {}
variable "subnet_name" {}
variable "subnet_01_pods_cidr" {}
variable "subnet_01_svc_cidr" {}

# nodes attributes
variable "node_locations" {}
variable "cluster_node_pool_machine_type" {}
variable "cluster_node_pool_min_count" {}
variable "cluster_node_pool_max_count" {}
variable "cluster_node_pool_disk_size_gb" {}
variable "cluster_node_pool_disk_type" {}
variable "image_type" {}
variable "logging_variant" {}
# variable "k8s_svc_account" {}
variable "cluster_pool_node_initial_count" {}
variable "accelerator_count" {}
# variable "accelerator_type" {}
variable "gpu_driver_version" {}
variable "gpu_sharing_strategy" {}
variable "max_shared_clients_per_gpu" {}