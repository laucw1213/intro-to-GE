# BYO（bring-your-own）root：用現成 project（例如 Qwiklabs lab project），
# 唔開 project、唔掂 billing、無 kill switch。只喺現成 project 部署 GE app + connectors。

variable "project_id" {
  description = "現成 project ID（lab / 客戶 project），必填。"
  type        = string
}

variable "region" {
  description = "預設 region"
  type        = string
  default     = "us-central1"
}

variable "name_prefix" {
  description = "資源命名前綴（engine_id / connector collection 用）"
  type        = string
  default     = "ge-byo"
}

variable "create_ge_app" {
  description = "係咪起 GE app。要先喺 Console 啟動 trial subscription，否則 search engine 會起唔到。"
  type        = bool
  default     = true
}

variable "ge_app_display_name" {
  description = "GE app 顯示名"
  type        = string
  default     = "GE Lab App"
}

variable "ge_app_location" {
  description = "GE app / data store location（global / us / eu）"
  type        = string
  default     = "global"
}

variable "create_ge_connectors" {
  description = "係咪起 Workspace connectors（要 Workspace Smart features 開咗）"
  type        = bool
  default     = true
}

variable "ge_workspace_connectors" {
  description = "要起邊啲 Workspace connector（留空就用 module 預設 4 個）"
  type = map(object({
    data_source  = string
    entity_name  = string
    display_name = string
  }))
  default = {
    gdrive   = { data_source = "google_drive", entity_name = "google_drive", display_name = "Google Drive" }
    gmail    = { data_source = "google_mail", entity_name = "google_mail", display_name = "Gmail" }
    calendar = { data_source = "google_calendar", entity_name = "google_calendar", display_name = "Google Calendar" }
    chat     = { data_source = "google_chat", entity_name = "google_chat", display_name = "Google Chat" }
  }
}

variable "enable_apis" {
  description = "係咪由 Terraform enable GE 所需 API。Lab：start trial 已 activate discoveryengine 等，設 false 慳時間。通用現成 project 留 true。"
  type        = bool
  default     = true
}

variable "engine_id" {
  description = "Override engine_id。import 現有 app（例如 lab 手動整嗰個）時填返查到嘅 id；留 null 就由 Terraform 自己起 app。"
  type        = string
  default     = null
}

variable "gcs_data_stores" {
  description = "Cloud Storage (GCS) data stores"
  type = map(object({
    display_name = string
    folder       = string
    bucket       = optional(string)
  }))
  default = {}
}
