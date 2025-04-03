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

module "cloud_nat" {
  source              = "../modules/cloud_nat"
  project_id          = var.project_id
  region              = var.region
  vpc_id              = module.vpc.vpc_id
}

module "firewall" {
  source = "../modules/firewall"
  vpc_id = module.vpc.vpc_id
}

module "vm" {
  source = "../modules/VM"
  instance_name = var.instance_name
  instance_machine_type = var.instance_machine_type
  instance_zone = var.instance_zone
  instance_image = var.instance_image
  subnet_01_name = module.subnet.subnet_01_name
}


module "gke" {
  source                          = "../modules/GKE"
  project_id                      = var.project_id
  region                          = var.region
  environment = var.environment
  domain_name = var.domain_name
  static_ip_name = module.vpc.static_ip_name
  load_balancer_url = module.public_lb.load_balancer_url
  cluster_name                    = var.cluster_name
  network_name = var.network_name
  subnet_name = var.subnet_name
  subnet_01_pods_cidr             = var.subnet_01_pods_cidr
  subnet_01_svc_cidr              = var.subnet_01_svc_cidr
  node_locations = var.node_locations
  cluster_node_pool_machine_type  = var.cluster_node_pool_machine_type
  cluster_node_pool_min_count     = var.cluster_node_pool_min_count
  cluster_node_pool_max_count     = var.cluster_node_pool_max_count
  cluster_node_pool_disk_size_gb  = var.cluster_node_pool_disk_size_gb
  cluster_node_pool_disk_type     = var.cluster_node_pool_disk_type
  image_type                      = var.image_type
  logging_variant                 = var.logging_variant
  cluster_pool_node_initial_count = var.cluster_pool_node_initial_count
  accelerator_count               = var.accelerator_count
  # accelerator_type                = var.accelerator_type # non existent in africa region
  gpu_driver_version              = var.gpu_driver_version
  gpu_sharing_strategy            = var.gpu_sharing_strategy
  max_shared_clients_per_gpu      = var.max_shared_clients_per_gpu
}

module "project-api" {
  source     = "../modules/project-api"
  project_id = var.project_id
}

module "namespace" {
    source     = "../modules/namespace"
    depends_on = [module.gke]
  }

module "service-accounts" {
    source       = "../modules/service-accounts"
    project_id   = var.project_id
    cluster_name = module.gke.cluster_name
    depends_on = [module.namespace]

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
  # master_user_password = var.master_username # can set only with pipeline
}

# module "kafka" {
#   source             = "../modules/kafka"
#   project_id         = var.project_id
#   region             = var.region
#   subnet_01_name     = module.subnet.subnet_01_name
#   kafka_cluster_name = var.kafka_cluster_name
#   kafka_vcpu_count   = var.kafka_vcpu_count
#   kafka_memory       = var.kafka_memory
#   kafka_rebalance    = var.kafka_rebalance
#   environment        = var.environment

# }

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

module "public_lb" {
  source             = "../modules/loadbalancer"
  project_id = var.project_id
  vpc_name = module.vpc.vpc_name
  node_pools_instance_group_urls = module.gke.node_pools_instance_group_urls
}

module "registry_repo" {
  source             = "../modules/artifact_registry"
  project_id = var.project_id
  region = var.region
  registry_name = var.registry_name
  registry_format = var.registry_format
}