# fundamentals
variable "project_id" {}
variable "region" {}


# variable "create_subnetworks" {}
variable "subnet_01_cidr" {}
variable "subnet_02_cidr" {}
variable "subnet_01_pods_cidr" {}
variable "subnet_01_svc_cidr" {}
variable "subnet_02_pods_cidr" {}
variable "subnet_02_svc_cidr" {}
variable "vpc_name" {}

# variable "cluster"
variable "cluster_name" {}
variable "cluster_description" {}
variable "kubernetes_version" {}
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



