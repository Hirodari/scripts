resource "kubernetes_namespace" "odi" {
  metadata {
    name   = "odi" 
  }
}