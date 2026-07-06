# The GE module declares no provider block: the root passes in a provider that is
# already configured with user_project_override (the discoveryengine API requires
# the x-goog-user-project header).
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source = "hashicorp/google"
      # v7.7.0+ is the first to support Discovery Engine (Gemini Enterprise) resources
      version = ">= 7.7.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}
