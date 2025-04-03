#   provider "google" {
#       project = "PROJECT-ID"
#   }

#   resource "google_artifact_registry_repository" "my-repo" {
#     location = "LOCATION"
#     repository_id = "REPOSITORY"
#     description = "DESCRIPTION"
#     format = "docker"
#     # kms_key_name = "KEY"
#     cleanup_policy_dry_run = DRY_RUN_STATUS
#     cleanup_policies {
#       id     = "POLICY_NAME"
#       action = "DELETE"
#       condition {
#         tag_state    = "TAG_STATE"
#         tag_prefixes = ["TAG_PREFIX", "TAG_PREFIX_N"]
#         older_than   = "TIME_SINCE_UPLOAD"
#       }
#     }
#     cleanup_policies {
#       id     = "POLICY_NAME"
#       action = "KEEP"
#       condition {
#         tag_state             = "TAG_STATE"
#         tag_prefixes          = ["TAG_PREFIX", "TAG_PREFIX_N"]
#         package_name_prefixes = ["PKG_PREFIX", "PKG_PREFIX_N"]
#       }
#     }
#     cleanup_policies {
#       id     = "POLICY_NAME"
#       action = "KEEP"
#       most_recent_versions {
#         package_name_prefixes = ["PKG_PREFIX", "PKG_PREFIX_N"]
#         keep_count            = KEEP_COUNT
#       }
#     }
#   }

resource "google_artifact_registry_repository" "my-repo" {
  location      = var.region
  project = var.project_id
  repository_id = var.registry_name 
  description   = "docker repository"
  format        = var.registry_format  
}