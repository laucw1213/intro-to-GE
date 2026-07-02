# GE module 唔放 provider block：由 root 傳入配好 user_project_override 嘅 provider
# （discoveryengine API 一定要 x-goog-user-project header）。
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source = "hashicorp/google"
      # v7.7.0+ 先支援 Discovery Engine (Gemini Enterprise) resources
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
