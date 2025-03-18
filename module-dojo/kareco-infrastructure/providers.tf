provider "google" {
  project = var.project_id # The project ID in GCP where resources will be managed.
  region  = var.region     # The default region for resources.
#   zone    = var.gcp_zone       # The default zone for resources.
}

# Google Cloud Beta Provider
# This provider allows access to beta features in Google Cloud Platform.
provider "google-beta" {
  project = var.project_id # The project ID in GCP where resources will be managed.
  region  = var.region     # The default region for resources.
#   zone    = var.gcp_zone       # The default zone for resources.
}

# Kubernetes Provider
# This provider is used to manage resources within a Kubernetes cluster.
provider "kubernetes" {
  host                   = "https://${module.gke_main.endpoint}"         # The API server URL of the Kubernetes cluster. 
  token                  = data.google_client_config.config.access_token # OAuth2 token used for authentication.
  cluster_ca_certificate = base64decode(module.gke_main.ca_certificate)  # CA certificate of the cluster, base64 encoded.
}

# Helm Provider
# This provider is used to manage Helm chart releases in a Kubernetes cluster.
provider "helm" {
  kubernetes {
    host                   = "https://${module.gke_main.endpoint}"         # The API server URL of the Kubernetes cluster.
    token                  = data.google_client_config.config.access_token # OAuth2 token used for authentication.
    cluster_ca_certificate = base64decode(module.gke_main.ca_certificate)  # CA certificate of the cluster, base64 encoded.
  }
}

# Google Client Config Data Source
# Provides access to the configuration of the Google Cloud client.
data "google_client_config" "config" {}

