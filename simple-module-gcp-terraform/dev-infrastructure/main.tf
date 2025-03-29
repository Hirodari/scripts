module "vpc" {
  source     = "../modules/network"
  project_id = var.project_id
  region     = var.region
  vpc_name   = var.vpc_name
}

module "subnet" {
  source              = "../modules/subnet"
  project_id          = var.project_id
  region              = var.region
  vpc_id              = module.vpc.vpc_id
  vpc_name            = var.vpc_name
  subnet_01_cidr      = var.subnet_01_cidr
  subnet_02_cidr      = var.subnet_02_cidr
  subnet_01_pods_cidr = var.subnet_01_pods_cidr
  subnet_01_svc_cidr  = var.subnet_01_svc_cidr
  subnet_02_pods_cidr = var.subnet_02_pods_cidr
  subnet_02_svc_cidr  = var.subnet_02_svc_cidr

}

# module "cloud_nat" {
#   source              = "../modules/cloud_nat"
#   project_id          = var.project_id
#   region              = var.region
#   vpc_id              = module.vpc.vpc_id
# }

module "firewall" {
  source = "../modules/firewall"
  vpc_id = module.vpc.vpc_id
}



# module "cluster" {
#   source                          = "../modules/cluster"
#   project_id                      = var.project_id
#   cluster_name                    = var.cluster_name
#   region                          = var.region
#   vpc_id                          = module.vpc.vpc_id
#   subnet_01_id                    = module.subnet.subnet_01_id
#   cluster_description             = var.cluster_description
#   enable_private_nodes            = var.enable_private_nodes
#   enable_private_endpoint         = var.enable_private_endpoint
#   kubernetes_version              = var.kubernetes_version
#   kubernetes_monitoring_service   = var.kubernetes_monitoring_service
#   kubernetes_logging_service      = var.kubernetes_logging_service
#   vertical_pod_autoscaling        = var.vertical_pod_autoscaling
#   cluster_load_balancer           = var.cluster_load_balancer
#   cluster_autoscaling_cpu_min     = var.cluster_autoscaling_cpu_min
#   cluster_autoscaling_cpu_max     = var.cluster_autoscaling_cpu_max
#   master_authorized_networks_cidr = var.master_authorized_networks_cidr
#   cluster_autoscaling_memory_min  = var.cluster_autoscaling_memory_min
#   cluster_autoscaling_memory_max  = var.cluster_autoscaling_memory_min
#   infrastructure_environment      = var.infrastructure_environment
#   horizontal_pod_autoscaling      = var.horizontal_pod_autoscaling
#   cluster_pool_node_count         = var.cluster_pool_node_initial_count
#   cluster_node_pool_min_count     = var.cluster_node_pool_min_count
#   cluster_node_pool_max_count     = var.cluster_node_pool_max_count
#   cluster_node_pool_machine_type  = var.cluster_node_pool_machine_type
#   cluster_node_pool_disk_size_gb  = var.cluster_node_pool_disk_size_gb
#   cluster_node_pool_disk_type     = var.cluster_node_pool_disk_type
#   k8s_svc_account                 = module.service-accounts.k8s_svc_account
# }

module "gke" {
  source                          = "../modules/GKE"
  project_id                      = var.project_id
  region                          = var.region
  # zones                           = var.zones
  cluster_name                    = var.cluster_name
  # vpc_id                          = module.vpc.vpc_id
  # subnet_01_id                    = module.subnet.subnet_01_id
  subnet_01_pods_cidr             = var.subnet_01_pods_cidr
  subnet_01_svc_cidr              = var.subnet_01_svc_cidr
  node_pools_name = var.node_pools_name
  cluster_node_pool_machine_type  = var.cluster_node_pool_machine_type
  cluster_node_pool_min_count     = var.cluster_node_pool_min_count
  cluster_node_pool_max_count     = var.cluster_node_pool_max_count
  cluster_node_pool_disk_size_gb  = var.cluster_node_pool_disk_size_gb
  cluster_node_pool_disk_type     = var.cluster_node_pool_disk_type
  image_type                      = var.image_type
  logging_variant                 = var.logging_variant
  cluster_pool_node_initial_count = var.cluster_pool_node_initial_count
  accelerator_count               = var.accelerator_count
  # accelerator_type                = var.accelerator_type
  gpu_driver_version              = var.gpu_driver_version
  gpu_sharing_strategy            = var.gpu_sharing_strategy
  max_shared_clients_per_gpu      = var.max_shared_clients_per_gpu
}

module "project-api" {
  source     = "../modules/project-api"
  project_id = var.project_id
}

module "service-accounts" {
  source       = "../modules/service-accounts"
  project_id   = var.project_id
  cluster_name = module.gke.cluster_name

}

module "namespace" {
  source     = "../modules/namespace"
  depends_on = [module.gke]
}

module "psc" {
  source                      = "../modules/psc-cloudsql"
  cloudsql_allocated_ip_range = var.cloudsql_allocated_ip_range
  cloudsql_purpose            = var.cloudsql_purpose
  cloudsql_prefix             = var.cloudsql_prefix
  vpc_id                      = module.vpc.vpc_id
}

module "cloudsql" {
  source                       = "../modules/cloudsql"
  project_id                   = var.project_id
  region                       = var.region
  vpc_id                       = module.vpc.vpc_id
  cloudsql_allocated_ip_range  = var.cloudsql_allocated_ip_range
  cloudsql_purpose             = var.cloudsql_purpose
  cloudsql_prefix              = var.cloudsql_prefix
  cloudsql_name                = var.cloudsql_name
  cloudsql_version             = var.cloudsql_version
  cloudsql_tier                = var.cloudsql_tier
  cloudsql_deletion_protection = var.cloudsql_deletion_protection
  cloudsql_disk_autoresize     = var.cloudsql_disk_autoresize
  cloudsql_ipv4_enabled        = var.cloudsql_ipv4_enabled
  cloudsql_availability_type   = var.cloudsql_availability_type
  cloudsql_backup_enabled      = var.cloudsql_backup_enabled
  cloudsql_backup_start_time   = var.cloudsql_backup_start_time
  private_service_connection   = module.psc.private_service_connection
  db_name                      = var.db_name
  # master_username = var.master_username
  # master_user_password = var.master_username
}

module "kafka" {
  source             = "../modules/kafka"
  project_id         = var.project_id
  region             = var.region
  subnet_01_name     = module.subnet.subnet_01_name
  kafka_cluster_name = var.kafka_cluster_name
  kafka_vcpu_count   = var.kafka_vcpu_count
  kafka_memory       = var.kafka_memory
  kafka_rebalance    = var.kafka_rebalance
  environment        = var.environment

}

module "redis" {
  source                     = "../modules/redis"
  redis_instance             = var.redis_instance
  redis_tier                 = var.redis_tier
  redis_memory               = var.redis_memory
  region                     = var.region
  redis_location             = var.redis_location
  redis_alternative_location = var.redis_alternative_location
  vpc_id                     = module.vpc.vpc_id
  redis_transit_encryption   = var.redis_transit_encryption
  redis_connect              = var.redis_connect
  redis_version              = var.redis_version
  redis_replica_count        = var.redis_replica_count
  redis_replicas_mode        = var.redis_replicas_mode
}