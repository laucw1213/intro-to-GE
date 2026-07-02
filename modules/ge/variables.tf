variable "project_id" {
  description = "要部署 GE app / connectors 嘅 project ID（demo 用新 project，byo 用現成 lab project）"
  type        = string
}

variable "name_prefix" {
  description = "資源命名前綴（engine_id / connector collection 用），例如 ge-demo-tria"
  type        = string
}

variable "location" {
  description = "GE app / data store location（只可 global / us / eu）"
  type        = string
  default     = "global"
}

variable "app_display_name" {
  description = "GE app 顯示名"
  type        = string
  default     = "GE Demo App"
}

variable "create_connectors" {
  description = "係咪起 Google Workspace data connectors（並 attach 落 app）"
  type        = bool
  default     = true
}

variable "engine_id" {
  description = "Override engine_id。null = 由 name_prefix 推導（{prefix}-app）；填值 = 對齊現有 app（import 用）。"
  type        = string
  default     = null
}

variable "gcs_data_stores" {
  description = "Cloud Storage (GCS) unstructured data stores。key = data_store_id 後綴。bucket 留空就用 project_id。"
  type = map(object({
    display_name = string
    folder       = string           # bucket 內 folder，例如 gemini-enterprise-cloud-storage
    bucket       = optional(string) # 預設 = project_id
  }))
  default = {}
}

variable "workspace_connectors" {
  description = "要起邊啲 Workspace connector（key = 短名）"
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

variable "features" {
  description = "GE app 嘅 end-user feature controls（25 個 toggle）。注意 disable-* key 設 OFF = 啟用。"
  type        = map(string)
  default = {
    # 正向 key（ON = 啟用）
    "agent-gallery"                        = "FEATURE_STATE_ON"
    "no-code-agent-builder"                = "FEATURE_STATE_ON"
    "prompt-gallery"                       = "FEATURE_STATE_ON"
    "model-selector"                       = "FEATURE_STATE_ON"
    "notebook-lm"                          = "FEATURE_STATE_ON"
    "session-sharing"                      = "FEATURE_STATE_ON"
    "personalization-memory"               = "FEATURE_STATE_ON"
    "personalization-suggested-highlights" = "FEATURE_STATE_ON"
    "people-search-org-chart"              = "FEATURE_STATE_ON"
    "mobile-app-access"                    = "FEATURE_STATE_ON"
    "agent-sharing-without-admin-approval" = "FEATURE_STATE_ON"
    "enable-end-user-sharing-with-groups"  = "FEATURE_STATE_ON"

    # 反向 key（OFF = 啟用該功能）
    "disable-canvas"              = "FEATURE_STATE_OFF"
    "disable-canvas-workspace"    = "FEATURE_STATE_OFF"
    "disable-image-generation"    = "FEATURE_STATE_OFF"
    "disable-video-generation"    = "FEATURE_STATE_OFF"
    "disable-talk-to-content"     = "FEATURE_STATE_OFF"
    "disable-google-drive-upload" = "FEATURE_STATE_OFF"
    "disable-onedrive-upload"     = "FEATURE_STATE_OFF"
    "disable-agent-sharing"       = "FEATURE_STATE_OFF"
    "disable-welcome-emails"      = "FEATURE_STATE_OFF"
    "disable-skills"              = "FEATURE_STATE_OFF"

    # orchestration / 雙向語音 維持原樣
    "disable-single-agent-orchestration" = "FEATURE_STATE_ON"
    "disable-multi-agent-orchestration"  = "FEATURE_STATE_ON"
    "bi-directional-audio"               = "FEATURE_STATE_OFF"
  }
}
