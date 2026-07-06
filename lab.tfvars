# -- Cymbal Foods "Introduction to Gemini Enterprise" lab (GSP1320) config --
# Usage: terraform apply -var-file=lab.tfvars
# Change per lab: project_id (and engine_id, if using import mode).

# Replace with the Project ID the lab gives you (bucket name = Project ID).
project_id = "REPLACE_WITH_LAB_PROJECT_ID"

name_prefix         = "cymbal"
ge_app_display_name = "Cymbal Foods - Gemini Enterprise" # exact app name required by lab grading
ge_app_location     = "global"

# The trial already activates discoveryengine etc., so Terraform need not enable APIs.
enable_apis = false

create_ge_app        = true
create_ge_connectors = true

# Import mode: after the student creates the app in the Console, look up its
# engine_id by display name and set it here, then terraform import. Leave null
# (commented out) to let Terraform create its own app (a separate app).
# engine_id = "cymbal-foods-gemini-enterp_xxxxxxxxxx"

# The lab only needs Drive + Calendar (no Gmail / Chat); names align with grading.
ge_workspace_connectors = {
  gdrive   = { data_source = "google_drive", entity_name = "google_drive", display_name = "Google Drive" }
  calendar = { data_source = "google_calendar", entity_name = "google_calendar", display_name = "Google Calendar" }
}

# Cloud Storage data store (required by lab Task 3). bucket defaults to project_id.
gcs_data_stores = {
  "cloud-storage" = {
    display_name = "Cloud Storage"
    folder       = "gemini-enterprise-cloud-storage"
  }
}
