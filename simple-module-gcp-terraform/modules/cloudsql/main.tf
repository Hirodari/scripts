resource "google_sql_database_instance" "instance" {
  name                = var.cloudsql_name
  region              = var.region
  database_version    = var.cloudsql_version
  deletion_protection = var.cloudsql_deletion_protection


  depends_on = [var.private_service_connection]

  settings {
    tier            = var.cloudsql_tier
    disk_autoresize = var.cloudsql_disk_autoresize
    ip_configuration {
      ipv4_enabled                                  = var.cloudsql_ipv4_enabled
      private_network                               = var.vpc_id
      enable_private_path_for_google_cloud_services = true
    }

    backup_configuration {
      enabled            = var.cloudsql_backup_enabled
      start_time         = var.cloudsql_backup_start_time
      binary_log_enabled = true
    }


    availability_type = var.cloudsql_availability_type
  }
}

resource "google_sql_database" "default" {
  depends_on = [google_sql_database_instance.instance]

  name     = var.db_name
  project  = var.project_id
  instance = google_sql_database_instance.instance.name
  charset  = "utf8mb4"
  # collation = "utf8mb4_0900_ai_ci"
}


# resource "google_sql_user" "default" {
#   depends_on = [google_sql_database_instance.instance]

#   project  = var.project_id
#   name     = var.master_username
#   instance = google_sql_database_instance.instance.name
#   host     = "%"
#   password = var.master_user_password
# }