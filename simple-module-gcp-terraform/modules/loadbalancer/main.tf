# resource "google_compute_global_address" "lb_ip" {
#   name         = "odi-dev-public-lb-ip"
#   address_type = "EXTERNAL"
# }

# resource "google_compute_backend_service" "backend" {
#   name        = "public-backend"
#   protocol    = "HTTP"
#   timeout_sec = 30

#   backend {
#     group = google_compute_instance_group.my_group.self_link
#   }
# }

# resource "google_compute_url_map" "url_map" {
#   name            = "public-url-map"
#   default_service = google_compute_backend_service.backend.self_link
# }

# resource "google_compute_target_http_proxy" "http_proxy" {
#   name    = "http-proxy"
#   url_map = google_compute_url_map.url_map.self_link
# }

# resource "google_compute_global_forwarding_rule" "http" {
#   name       = "http-rule"
#   target     = google_compute_target_http_proxy.http_proxy.self_link
#   port_range = "80"
#   ip_address = google_compute_global_address.lb_ip.address
# }

# resource "google_compute_managed_ssl_certificate" "example" {
#   name = "gke-managed-ssl-certificate"

#   managed {
#     # Replace this with your actual domain name
#     domains = ["wallet.fredbitenyo.click"]
#   }
# }

# resource "google_compute_instance_group_named_port" "gke_named_port" {
#   name       = "http"
#   port       = 80
#   instance_group = var.node_pools_instance_group_urls[0]
#   zone       = "africa-south1-b" # Adjust based on your instance group's zone
# }



module "gce-lb-http" {
  source            = "terraform-google-modules/lb-http/google"
  version           = "~> 12.0"
  name              = "gke-https-redirect-loadbalancer"
  project           = var.project_id
  firewall_networks = [var.vpc_name]
  # ssl               = true
  # ssl_certificates  = [google_compute_managed_ssl_certificate.example.self_link]
  https_redirect    = false # set to true later

  backends = {
    gke-backend = {
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false

      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = var.node_pools_instance_group_urls[0]
        }
      ]
      iap_config = {
        enable = false
      }
    }
  }
}

