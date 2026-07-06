variable "project_id" {
  description = "Project ID to deploy the GE app / connectors into (demo uses a new project, byo uses an existing project)."
  type        = string
}

variable "name_prefix" {
  description = "Resource name prefix (used for engine_id / connector collection), e.g. ge-demo-tria."
  type        = string
}

variable "location" {
  description = "GE app / data store location (global / us / eu only)."
  type        = string
  default     = "global"
}

variable "app_display_name" {
  description = "GE app display name."
  type        = string
  default     = "GE Demo App"
}

variable "create_connectors" {
  description = "Whether to create Google Workspace data connectors (and attach them to the app)."
  type        = bool
  default     = true
}

variable "engine_id" {
  description = "Override engine_id. null = derive from name_prefix ({prefix}-app); set a value to match an existing app (for import)."
  type        = string
  default     = null
}

variable "gcs_data_stores" {
  description = "Cloud Storage (GCS) unstructured data stores. key = data_store_id suffix. bucket defaults to project_id when empty."
  type = map(object({
    display_name = string
    folder       = string           # folder inside the bucket, e.g. gemini-enterprise-cloud-storage
    bucket       = optional(string) # defaults to project_id
  }))
  default = {}
}

variable "workspace_connectors" {
  description = "Which Workspace connectors to create (key = short name)."
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
  description = "GE app end-user feature controls (25 toggles). Note: disable-* keys set to OFF means the feature is enabled."
  type        = map(string)
  default = {
    # Positive keys (ON = enabled)
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

    # Inverted keys (OFF = the feature is enabled)
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

    # orchestration / bi-directional audio: keep as-is
    "disable-single-agent-orchestration" = "FEATURE_STATE_ON"
    "disable-multi-agent-orchestration"  = "FEATURE_STATE_ON"
    "bi-directional-audio"               = "FEATURE_STATE_OFF"
  }
}
