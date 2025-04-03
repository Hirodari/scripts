resource "cloudflare_tunnel" "k8s_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "k8s-cluster-odibets"
  secret     = "eyJhIjoiMjRmYjcwMWY1ZWU5OWI5YTk3ODM1NTM2OWUwZTM2YjIiLCJ0IjoiYTdkNWZlNTYtNDAwYy00Y2QzLTg5MTItYTM0ODUyYTYxMjFjIiwicyI6IlptUTVaakU1TTJZdE16aGpZaTAwTnpJd0xXSTBabVV0T0RRek9EWmlZekkxWlRBNSJ9"
}

resource "cloudflare_tunnel_config" "k8s_config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.k8s_tunnel.id
  config {
    ingress_rule {
      hostname = "k8s.odibets.com"
      service  = "https://localhost:6443"
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

resource "cloudflare_access_application" "k8s_app" {
  zone_id          = var.cloudflare_zone_id
  name             = "Kubernetes Cluster"
  domain           = "https://k8s.odibets.com"
  session_duration = "24h"
}

resource "cloudflare_access_policy" "google_workspace_access" {
  application_id = cloudflare_access_application.k8s_app.id
  zone_id        = var.cloudflare_zone_id
  name           = "Allow Google Workspace"
  precedence     = 1
  decision       = "allow"

  include {
    email_domain = ["foresightechgroup.com"]
  }
}