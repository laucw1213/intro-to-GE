# BYO root：現成 project 上部署 GE。無 google_project、無 kill switch。

locals {
  # GE 所需嘅最小 API 子集（無 billing/pubsub/function 嗰啲，因為冇 kill switch）
  byo_services = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "discoveryengine.googleapis.com",
    "aiplatform.googleapis.com",
    "iam.googleapis.com",
  ]
}

# Enable GE 所需 API（喺現成 project 上）。
# Lab：start trial 已 activate，可設 var.enable_apis = false 跳過。
resource "google_project_service" "apis" {
  for_each = var.enable_apis ? toset(local.byo_services) : toset([])

  project = var.project_id
  service = each.value

  disable_on_destroy         = false
  disable_dependent_services = false
}

# GE app + connectors（共享 module）。要等 API 開好。
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
