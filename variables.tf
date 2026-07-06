# BYO (bring-your-own) root: deploy into an existing project (e.g. a Qwiklabs lab
# project). Does not create the project, does not touch billing, no kill switch.
# Only deploys the GE app + connectors into the existing project.

variable "project_id" {
  description = "Existing project ID (lab / customer project). Required."
  type        = string
}

variable "region" {
  description = "Default region."
  type        = string
  default     = "us-central1"
}

variable "name_prefix" {
  description = "Resource name prefix (used for engine_id / connector collection)."
  type        = string
  default     = "ge-byo"
}

variable "create_ge_app" {
  description = "Whether to create the GE app. The trial subscription must be started in the Console first, otherwise the search engine cannot be created."
  type        = bool
  default     = true
}

variable "ge_app_display_name" {
  description = "GE app display name."
  type        = string
  default     = "GE Lab App"
}

variable "ge_app_location" {
  description = "GE app / data store location (global / us / eu)."
  type        = string
  default     = "global"
}

variable "create_ge_connectors" {
  description = "Whether to create Workspace connectors (requires Workspace Smart features to be enabled)."
  type        = bool
  default     = true
}

variable "ge_workspace_connectors" {
  description = "Which Workspace connectors to create (leave empty to use the module default of 4)."
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
  description = "Whether Terraform should enable the APIs GE needs. In the lab, starting the trial already activates discoveryengine etc., so set false to save time. Leave true for a generic existing project."
  type        = bool
  default     = true
}

variable "engine_id" {
  description = "Override engine_id. When importing an existing app (e.g. one created by hand in the lab), set the looked-up id here; leave null to let Terraform create its own app."
  type        = string
  default     = null
}

variable "gcs_data_stores" {
  description = "Cloud Storage (GCS) data stores."
  type = map(object({
    display_name = string
    folder       = string
    bucket       = optional(string)
  }))
  default = {}
}
