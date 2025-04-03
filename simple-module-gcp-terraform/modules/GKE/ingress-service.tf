resource "kubernetes_service" "kareco-dev-app-service" {
  depends_on = [var.static_ip_name]
  metadata {
    name = "kareco-app-service"
    labels = {
      app = "kareco-app"
    }
    namespace = "default"
  }
  spec {
    selector = {
      app = "kareco-app"
    }
    port {
      port        = 80
      target_port = 8000
      name        = "kareco-app-port"
    }
    type             = "NodePort"
    # load_balancer_ip = var.load_balancer_url
  }
}