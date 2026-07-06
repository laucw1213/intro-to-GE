output "engine_id" {
  description = "GE app (search engine) ID."
  value       = google_discovery_engine_search_engine.ge.engine_id
}

output "data_store_ids" {
  description = "Data store IDs attached to the app."
  value       = google_discovery_engine_search_engine.ge.data_store_ids
}

output "gcs_data_store_ids" {
  description = "The Cloud Storage data store IDs that were created."
  value       = [for k, v in google_discovery_engine_data_store.gcs : v.data_store_id]
}
