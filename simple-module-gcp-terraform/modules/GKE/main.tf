# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  # config_path = "~/.kube/config"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster-update-variant"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  zones                      = var.zones
  network                    = var.network_name  
  subnetwork                 = var.subnet_name 
  ip_range_pods              = local.gke_pods_range_name 
  ip_range_services          = local.gke_svc_range_name
  create_service_account      =  true  
  service_account_name = "cluster-svc"
  http_load_balancing        = true # false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  enable_private_endpoint    = false
  enable_private_nodes       = true
  dns_cache                  = false
  deletion_protection = false
  master_authorized_networks = [
                                  {
                                    cidr_block   = "105.244.164.33/32"
                                    display_name = "management"
                                  }
                              ]


  node_pools = [
    {
      name                        = "${var.cluster_name}-node-pool"  
      machine_type                = var.cluster_node_pool_machine_type 
      node_locations              = var.node_locations
      min_count                   = var.cluster_node_pool_min_count 
      max_count                   = var.cluster_node_pool_max_count 
      local_ssd_count             = 0
      spot                        = false
      disk_size_gb                = var.cluster_node_pool_disk_size_gb 
      disk_type                   = var.cluster_node_pool_disk_type 
      image_type                  = var.image_type 
      enable_gcfs                 = false
      enable_gvnic                = false
      logging_variant             = var.logging_variant 
      auto_repair                 = true
      auto_upgrade                = true
      # service_account             = "cluster-svc@${var.project_id}.iam.gserviceaccount.com"
      preemptible                 = false
      initial_node_count          = var.cluster_pool_node_initial_count #80
      accelerator_count           = var.accelerator_count # 1
      # accelerator_type            = var.accelerator_type # "nvidia-l4"
      gpu_driver_version          = var.gpu_driver_version # "LATEST"
      gpu_sharing_strategy        = var.gpu_sharing_strategy # "TIME_SHARING"
      max_shared_clients_per_gpu = var.max_shared_clients_per_gpu # 2
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/bigquery",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/sqlservice.admin",
      "https://www.googleapis.com/auth/compute"
    ]
  }

  node_pools_labels = {
    all = {
      environment = "dev",
      name = "odi-dev-cluster"
    }

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}