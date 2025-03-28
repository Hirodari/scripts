# General attributes
variable "project_id" {}
variable "region" {}
variable "cluster_name" {} #
variable "cluster_description" {} #

# network attributes
variable "vpc_id" {}
variable "subnet_01_id" {}

# cluster attributes
variable "kubernetes_version" {} #
variable "infrastructure_environment" {}
variable "master_authorized_networks_cidr" {}

# Monitoring 
variable "kubernetes_monitoring_service" {}
variable "kubernetes_logging_service" {}

# private cluster
variable "enable_private_nodes" {}
variable "enable_private_endpoint" {}

# cluster load balancer
variable "cluster_load_balancer" {}

# Autoscaling
variable "horizontal_pod_autoscaling" {}
variable "vertical_pod_autoscaling" {}
variable "cluster_autoscaling_cpu_min" {}
variable "cluster_autoscaling_cpu_max" {}
variable "cluster_autoscaling_memory_min" {}
variable "cluster_autoscaling_memory_max" {}

# Default node pool attributes
variable "cluster_pool_node_count" {}
variable "cluster_node_pool_min_count" {}
variable "cluster_node_pool_max_count" {}
variable "cluster_node_pool_machine_type" {}
variable "cluster_node_pool_disk_size_gb" {}
variable "cluster_node_pool_disk_type" {}

# service account for the cluster
variable "k8s_svc_account" {}

locals {
  gke_pods_range_name = "ip-range-pods"
  gke_svc_range_name  = "ip-range-svc"

}

variable "labels" {
  description = "Cluster resource labels"
  type        = map(string)
  default = {
    "name" = "kareco"
  }
}