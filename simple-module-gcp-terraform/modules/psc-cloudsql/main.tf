// MYSQL instance Enterprise edition

resource "google_compute_global_address" "private_ip_address" {
  name          = var.cloudsql_allocated_ip_range
  purpose       = var.cloudsql_purpose
  address_type  = "INTERNAL"
  prefix_length = var.cloudsql_prefix
  network       = var.vpc_id
}

resource "google_service_networking_connection" "private_vpc_connection" {

  network                 = var.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  update_on_creation_fail = true
#   depends_on = [google_sql_database_instance.instance]
}