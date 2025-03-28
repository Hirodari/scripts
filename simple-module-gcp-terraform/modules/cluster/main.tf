resource "google_container_cluster" "gke_main" {
  
  project  = var.project_id   
  name     = var.cluster_name 
  location = var.region       
  description = var.cluster_description

  # network attributes
  network     = var.vpc_id 
  subnetwork = var.subnet_01_id 
  
  # Kubernetes version
  min_master_version = var.kubernetes_version 

  # Enable kubernetes monitoring for managed Prometheus and logging.
  monitoring_service       = var.kubernetes_monitoring_service 
  logging_service          = var.kubernetes_logging_service 
  deletion_protection      = var.infrastructure_environment == "prod" 
  
  # default set up
  remove_default_node_pool = true 
  initial_node_count = 1

  # Enable private cluster
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes 
    enable_private_endpoint = var.enable_private_endpoint
  }

  # enable vertical pod autoscaling
  # set to false initially, can be switching to true if required
  vertical_pod_autoscaling {
    enabled = var.vertical_pod_autoscaling
  }

  # Enable HTTP Load Balancing
  addons_config {
    http_load_balancing {
      disabled = var.cluster_load_balancer
    }
  }

  
  master_authorized_networks_config  {
    # enabled = true
    # gcp_public_cidrs_access_enabled = false

    private_endpoint_enforcement_enabled = true
    cidr_blocks {
      cidr_block   = var.master_authorized_networks_cidr 
      # display_name = "developing"
    }
  }

 

  release_channel {
    channel = "REGULAR"
  }


  ip_allocation_policy {
    cluster_secondary_range_name  = local.gke_pods_range_name
    services_secondary_range_name = local.gke_svc_range_name
  }

  cluster_autoscaling {
    enabled = var.horizontal_pod_autoscaling

    resource_limits {
      resource_type = "cpu"
      minimum       = var.cluster_autoscaling_cpu_min
      maximum       = var.cluster_autoscaling_cpu_max
    }

    resource_limits {
      resource_type = "memory"
      minimum       = var.cluster_autoscaling_memory_min
      maximum       = var.cluster_autoscaling_memory_max
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "gke_main_node_pool" {
  project  = var.project_id
  name     = "${var.cluster_name}-node-pool"
  cluster  = google_container_cluster.gke_main.id
  location = var.region

  node_count = var.cluster_pool_node_count
  autoscaling {
    min_node_count = var.cluster_node_pool_min_count
    max_node_count = var.cluster_node_pool_max_count
  }

  node_config {
    machine_type    = var.cluster_node_pool_machine_type
    disk_size_gb    = var.cluster_node_pool_disk_size_gb
    disk_type       = var.cluster_node_pool_disk_type
    preemptible     = false
    service_account = var.k8s_svc_account #"${var.cluster_name}-gke-svc-account@${var.project_id}.iam.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/bigquery",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/sqlservice.admin",
      "https://www.googleapis.com/auth/compute"
    ]
    metadata = {
      origin = "terraform"
    }

    # tags = lookup(var.node_pools_tags, "${var.cluster_name}-node-pool", [])
    labels = var.labels

    # Not sure the role of taint
    # taint {
    #   key    = "example-taint"
    #   value  = "true"
    #   effect = "NO_SCHEDULE"
    # }
  }
  management {
    auto_upgrade = true
    auto_repair  = true
  }
}
