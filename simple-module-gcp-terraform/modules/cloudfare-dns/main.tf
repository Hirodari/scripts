resource "cloudflare_record" "public_dns" {
  zone_id = "YOUR_CLOUDFLARE_ZONE_ID"
  name    = "public.example.com"
  value   = google_compute_global_address.lb_ip.address
  type    = "A"
  ttl     = 300
}

resource "cloudflare_record" "private_dns" {
  zone_id = "YOUR_CLOUDFLARE_ZONE_ID"
  name    = "private.example.com"
  value   = kubernetes_service.internal_lb.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 300
}