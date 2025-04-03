# output "load_balancer_url" {
#   description = "The public IP address of the load balancer to reach the app."
#   value       = module.gce-lb-http.ip_address
# }

output "load_balancer_url" {
  description = "The public IP address of the load balancer to reach the app."
  value       = module.gce-lb-http.external_ip
}

