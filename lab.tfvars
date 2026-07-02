# ── Cymbal Foods「Introduction to Gemini Enterprise」lab（GSP1320）config ──
# 用法：cd byo && terraform apply -var-file=lab.tfvars
# 每次開新 lab 要改：project_id（同 engine_id，如果用 import 模式）。

# 每次換成 lab 畀你嘅 project ID（bucket 名同 project ID）
project_id = "REPLACE_WITH_LAB_PROJECT_ID"

name_prefix         = "cymbal"
ge_app_display_name = "Cymbal Foods - Gemini Enterprise" # lab grading 要求嘅 exact app 名
ge_app_location     = "global"

# start trial 已 activate discoveryengine 等 API，唔使 Terraform 再 enable
enable_apis = false

create_ge_app        = true
create_ge_connectors = true

# import 模式：學員喺 Console 整完 app 後，用 display name 查返 engine_id 填呢度，
# 然後 terraform import；留 null 就 Terraform 自己起一個 app（會係另一個 app）。
# engine_id = "cymbal-foods-gemini-enterp_xxxxxxxxxx"

# lab 只要 Drive + Calendar（冇 Gmail / Chat）；data store 名對齊 grading
ge_workspace_connectors = {
  gdrive   = { data_source = "google_drive", entity_name = "google_drive", display_name = "Google Drive" }
  calendar = { data_source = "google_calendar", entity_name = "google_calendar", display_name = "Google Calendar" }
}

# Cloud Storage data store（lab Task 3 要）。bucket 預設 = project_id。
gcs_data_stores = {
  "cloud-storage" = {
    display_name = "Cloud Storage"
    folder       = "gemini-enterprise-cloud-storage"
  }
}
