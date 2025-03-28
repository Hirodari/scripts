# ############### Create Kafka Service Accounts ##############

# resource "google_service_account" "kafka_producer" {
#   account_id   = "kafka-producer"
#   display_name = "Kafka Producer Service Account"
# }

# resource "google_service_account" "kafka_consumer" {
#   account_id   = "kafka-consumer"
#   display_name = "Kafka Consumer Service Account"
# }

# # IAM Binding for Kafka Publisher (Producer)
# resource "google_project_iam_binding" "kafka_producer" {
#   project = var.project_id
#   role    = "roles/pubsub.publisher" # Adjusted role

#   members = [
#     "serviceAccount:${google_service_account.kafka_producer.email}"
#   ]

#   condition {
#     title       = "KafkaProducerAccess"
#     description = "Allows publishing messages to Kafka topics"
#     expression  = <<EOT
#     resource.name.startsWith("projects/${var.project_id}/locations/${var.gcp_region}/clusters/${google_managed_kafka_cluster.wallet_kafka.cluster_id}/topics/")
#     EOT
#   }
# }

# # IAM Binding for Kafka Subscriber (Consumer)
# resource "google_project_iam_binding" "kafka_consumer" {
#   project = var.project_id
#   role    = "roles/pubsub.subscriber" # Adjusted role

#   members = [
#     "serviceAccount:${google_service_account.kafka_consumer.email}"
#   ]

#   condition {
#     title       = "KafkaConsumerAccess"
#     description = "Allows consuming messages from Kafka topics"
#     expression  = <<EOT
#     resource.name.startsWith("projects/${var.project_id}/locations/${var.gcp_region}/clusters/${google_managed_kafka_cluster.wallet_kafka.cluster_id}/topics/")
#     EOT
#   }
# }

# ############### Create Redis Service Accounts ##############

# resource "google_service_account" "redis" {
#   account_id   = "odi-dev-redis-sa"
#   display_name = "Redis memorystore Service Account"
# }

# # IAM Binding admin role for Redis SA
# resource "google_project_iam_binding" "redis" {
#   project = var.project_id
#   role    = "roles/redis.admin" # Adjusted role

#   members = [
#     "serviceAccount:${google_service_account.redis.email}"
#   ]
# }

############### Google Service Accounts for the k8s cluster ##############

resource "google_service_account" "k8s" {
  account_id   = "${var.cluster_name}-svc-account"
  display_name = "K8s cluster service account"
}

# IAM cloudsql client for kubernetes
resource "google_project_iam_binding" "k8s" {
  project = var.project_id
  role    = "roles/cloudsql.client" # Adjusted role

  members = [
    "serviceAccount:${google_service_account.k8s.email}"
  ]
}

############### Cloud SQL Service Accounts ##############
resource "google_service_account" "cloudsql" {
  project      = var.project_id
  account_id   = "odi-dev-cloudsql-gsa-terraform"
  display_name = "GSA for Kubernetes to access Cloud SQL via Workload Identity"
  
}

# Grant the Cloud SQL client role to the GSA
resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudsql.email}"
}

############### Kubernetes Service Accounts ##############

data "kubernetes_namespace" "odi_dev" {
  metadata {
    name = "odi-dev"
  }
}

resource "kubernetes_service_account" "cloudsql_ksa" {
  metadata {
    name      = "odi-dev-cloudsql-ksa"
    namespace = "odi-dev"
    annotations = {
      # Annotate the KSA with the email of the GSA
      "iam.gke.io/gcp-service-account" = google_service_account.cloudsql.email
    }
  }
  depends_on = [data.kubernetes_namespace.odi_dev]
}

# Bind the GSA to the KSA for Workload Identity (allow the KSA to impersonate the GSA)
resource "google_service_account_iam_member" "cloudsql_ksa_binding" {
  service_account_id = google_service_account.cloudsql.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[odi-dev/odi-dev-cloudsql-ksa]"
}