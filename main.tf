# BYO root: deploy GE into an existing project. No google_project, no kill switch.

locals {
  # Minimal API subset GE needs (no billing/pubsub/function APIs, since there is no kill switch).
  byo_services = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "discoveryengine.googleapis.com",
    "aiplatform.googleapis.com",
    "iam.googleapis.com",
  ]
}

# Enable the APIs GE needs (on the existing project).
# If the project is already activated (e.g. the trial has been started), set var.enable_apis = false to skip.
resource "google_project_service" "apis" {
  for_each = var.enable_apis ? toset(local.byo_services) : toset([])

  project = var.project_id
  service = each.value

  disable_on_destroy         = false
  disable_dependent_services = false
}

# GE app + connectors (shared module). Waits for the APIs to be enabled.
module "ge" {
  count  = var.create_ge_app ? 1 : 0
  source = "./modules/ge"

  providers = {
    google = google.billing
  }

  project_id           = var.project_id
  name_prefix          = var.name_prefix
  location             = var.ge_app_location
  app_display_name     = var.ge_app_display_name
  create_connectors    = var.create_ge_connectors
  workspace_connectors = var.ge_workspace_connectors
  engine_id            = var.engine_id
  gcs_data_stores      = var.gcs_data_stores

  depends_on = [google_project_service.apis]
}
