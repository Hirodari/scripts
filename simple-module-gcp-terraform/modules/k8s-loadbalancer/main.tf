resource "kubernetes_service" "internal_lb" {
  metadata {
    name      = "internal-lb"
    namespace = "default"
    annotations = {
      "cloud.google.com/load-balancer-type" = "Internal"
    }
  }

  spec {
    selector = {
      app = "my-app"
    }
    type = "LoadBalancer"
    ports {
      port        = 80
      target_port = 8080
    }
  }
}