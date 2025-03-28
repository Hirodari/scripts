# Deploying Kafka resource for wallet service

resource "google_managed_kafka_cluster" "wallet_kafka" {

  cluster_id = var.kafka_cluster_name
  location   = var.region
  provider   = google-beta

  capacity_config {
    vcpu_count   = var.kafka_vcpu_count
    memory_bytes = var.kafka_memory
  }

  gcp_config {
    access_config {
      network_configs {
        subnet = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnet_01_name}"
      }
    }
  }

  rebalance_config {
    mode = var.kafka_rebalance
  }

  labels = {
    environment = var.environment
    name        = var.kafka_cluster_name
  }
}


data "google_project" "project" {
}
