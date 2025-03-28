resource "google_redis_instance" "redis" {
  name                    = var.redis_instance
  tier                    = var.redis_tier
  memory_size_gb          = var.redis_memory
  region                  = var.region
  location_id             = var.redis_location
  alternative_location_id = var.redis_alternative_location

  authorized_network = var.vpc_id

  transit_encryption_mode = var.redis_transit_encryption
  connect_mode            = var.redis_connect
  redis_version           = var.redis_version
  display_name            = "Odi Dev Redis for wallet"
  replica_count           = var.redis_replica_count
  read_replicas_mode      = var.redis_replicas_mode

  lifecycle {
    # logic for prod or dev
    prevent_destroy = false
  }
}