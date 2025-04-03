resource "kubernetes_ingress_v1" "kareco-app-ingress" {
  depends_on = [kubernetes_manifest.app-ingress-managed-cert]
  metadata {
    name = "kareco-app-ingress"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = var.static_ip_name
      "networking.gke.io/managed-certificates"      = "kareco-${var.environment}-certificate"
      "kubernetes.io/ingress.allow-http"            = false
      "kubernetes.io/ingress.class"                 = "gce"
    }
    labels = {
      app    = "kareco-app"
      origin = "terraform"
    }
    namespace = "default"
  }
  wait_for_load_balancer = false

  spec {
    default_backend {
      service {
        name = "test-app-service"
        port {
          number = 80
        }
      }
    }
  }
}


# Creates a Kubernetes Service for multiple applications using the ExternalName type.
# This service resolves to internal services in other namespaces.
# resource "kubernetes_service" "mirror_services" {
#   for_each = {
#     for pair in local.app_namespace_pairs :
#     "${pair.appname}-${pair.namespace}" => pair
#   }

#   metadata {
#     name      = "${each.value.appname}-${each.value.namespace}-service"  # Service name derived from app and namespace.
#     namespace = "default"  # Services are placed in the default namespace.
#   }

#   spec {
#     type = "ExternalName"  # ExternalName service, which routes traffic to other services via DNS.
#     external_name = "${each.value.appname}-${each.value.namespace}-service.${each.value.namespace}.svc.cluster.local"  # Resolves to internal service.
#   }
# }

# # Kubernetes Service for the Kuma monitoring service.
# resource "kubernetes_service_v1" "kuma-service" {
#   metadata {
#     name      = "kuma"
#     namespace = "default"
#   }
#   spec {
#     type          = "ExternalName"  # ExternalName service type to resolve to an internal service.
#     external_name = "kuma.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local"  # Resolves to kuma service in monitoring namespace.
#     port {
#       port        = 80  # Expose port 80 externally.
#       target_port = 80  # Route traffic to port 80 in the internal service.
#       protocol    = "TCP"  # Use TCP protocol.
#     }
#   }
# }

# # Kubernetes Service for the Grafana service.
# resource "kubernetes_service_v1" "grafana-service" {
#   metadata {
#     name      = "grafana"
#     namespace = "default"
#   }
#   spec {
#     type          = "ExternalName"  # ExternalName service type to resolve to an internal service.
#     external_name = "grafana.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local"  # Resolves to grafana service in monitoring namespace.
#     port {
#       port        = 80  # Expose port 80 externally.
#       target_port = 80  # Route traffic to port 80 in the internal service.
#       protocol    = "TCP"  # Use TCP protocol.
#     }
#   }
# }

# # Kubernetes Service for the jsreport service.
# resource "kubernetes_service_v1" "jsreport-service" {
#   metadata {
#     name      = "jsreport"
#     namespace = "default"
#   }
#   spec {
#     type          = "ExternalName"  # ExternalName service type to resolve to an internal service.
#     external_name = "jsreport.${kubernetes_namespace.jsreport.metadata[0].name}.svc.cluster.local"  # Resolves to jsreport service in jsreport namespace.
#     port {
#       port        = 80  # Expose port 80 externally.
#       target_port = 80  # Route traffic to port 80 in the internal service.
#       protocol    = "TCP"  # Use TCP protocol.
#     }
#   }
# }