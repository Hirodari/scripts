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

module "firewall" {
  source = "../modules/firewall"
  vpc_id = module.vpc.vpc_id
}

module "cluster" {
  source                          = "../modules/cluster"
  project_id                      = var.project_id
  cluster_name                    = var.cluster_name
  region                          = var.region
  vpc_id                          = module.vpc.vpc_id
  subnet_01_id                    = module.subnet.subnet_01_id
  cluster_description             = var.cluster_description
  enable_private_nodes            = var.enable_private_nodes
  enable_private_endpoint         = var.enable_private_endpoint
  kubernetes_version              = var.kubernetes_version
  kubernetes_monitoring_service   = var.kubernetes_monitoring_service
  kubernetes_logging_service      = var.kubernetes_logging_service
  vertical_pod_autoscaling        = var.vertical_pod_autoscaling
  cluster_load_balancer           = var.cluster_load_balancer
  cluster_autoscaling_cpu_min     = var.cluster_autoscaling_cpu_min
  cluster_autoscaling_cpu_max     = var.cluster_autoscaling_cpu_max
  master_authorized_networks_cidr = var.master_authorized_networks_cidr
  cluster_autoscaling_memory_min  = var.cluster_autoscaling_memory_min
  cluster_autoscaling_memory_max  = var.cluster_autoscaling_memory_min
  infrastructure_environment      = var.infrastructure_environment
  horizontal_pod_autoscaling      = var.horizontal_pod_autoscaling
  cluster_pool_node_count         = var.cluster_pool_node_count
  cluster_node_pool_min_count     = var.cluster_node_pool_min_count
  cluster_node_pool_max_count     = var.cluster_node_pool_max_count
  cluster_node_pool_machine_type  = var.cluster_node_pool_machine_type
  cluster_node_pool_disk_size_gb  = var.cluster_node_pool_disk_size_gb
  cluster_node_pool_disk_type     = var.cluster_node_pool_disk_type
}

module "project-api" {
  source = "../modules/project-api"
  project_id = var.project_id
}

# module "service-accounts" {
#   source = "../modules/service-accounts"
#   project_id = var.project_id

# }