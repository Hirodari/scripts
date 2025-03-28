# fundamentals attributes
variable "project_id" {}
variable "region" {}
# variable "zones" {}
variable "environment" {}

# vpc attributes
variable "vpc_name" {}

# subnetwork attributes
variable "subnet_01_cidr" {}
variable "subnet_02_cidr" {}
variable "subnet_01_pods_cidr" {}
variable "subnet_01_svc_cidr" {}
variable "subnet_02_pods_cidr" {}
variable "subnet_02_svc_cidr" {}


# variable k8s GKE cluster
variable "cluster_name" {}
variable "cluster_description" {}
variable "kubernetes_version" {}
variable "infrastructure_environment" {}
variable "node_pools_name" {}
variable "master_authorized_networks_cidr" {}
# Default node pool attributes
variable "cluster_node_pool_machine_type" {}
variable "cluster_pool_node_initial_count" {}
variable "cluster_node_pool_min_count" {}
variable "cluster_node_pool_max_count" {}
variable "cluster_node_pool_disk_size_gb" {}
variable "cluster_node_pool_disk_type" {}
variable "image_type" {}
variable "logging_variant" {}
variable "accelerator_count" {}
# variable "accelerator_type" {}
variable "gpu_driver_version" {}
variable "gpu_sharing_strategy" {}
variable "max_shared_clients_per_gpu" {}
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


# Cloudsql attributes
variable "cloudsql_allocated_ip_range" {}
variable "cloudsql_purpose" {}
variable "cloudsql_prefix" {}
variable "cloudsql_name" {}
variable "cloudsql_version" {}
variable "cloudsql_deletion_protection" {}
variable "cloudsql_tier" {}
variable "cloudsql_disk_autoresize" {}
variable "cloudsql_ipv4_enabled" {}
variable "cloudsql_backup_enabled" {}
variable "cloudsql_backup_start_time" {}
variable "cloudsql_availability_type" {}
variable "db_name" {}
# variable "master_username" {}
# variable "master_user_password" {}

# kafka attributes
variable "kafka_cluster_name" {}
variable "kafka_vcpu_count" {}
variable "kafka_memory" {} # memory in bytes
variable "kafka_rebalance" {}

# redis attributes
variable "redis_instance" {}
variable "redis_tier" {}
variable "redis_memory" {}
variable "redis_location" {}
variable "redis_alternative_location" {}
variable "redis_transit_encryption" {}
variable "redis_connect" {}
variable "redis_version" {}
variable "redis_replica_count" {}
variable "redis_replicas_mode" {}

