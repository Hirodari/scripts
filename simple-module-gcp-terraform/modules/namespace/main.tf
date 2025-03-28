resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name   = "cert-manager" # Name of the namespace
    # labels = var.labels     # Labels applied to the namespace
  }
} 

resource "kubernetes_namespace" "odi-dev" {
  metadata {
    name   = "odi-dev" # Name of the namespace
    labels = var.labels     # Labels applied to the namespace
  }

} 

resource "kubernetes_namespace" "odi-prod" {
  metadata {
    name   = "odi-prod" # Name of the namespace
    labels = var.labels     # Labels applied to the namespace
  }
} 