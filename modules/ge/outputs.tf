output "engine_id" {
  description = "GE app (search engine) ID"
  value       = google_discovery_engine_search_engine.ge.engine_id
}

output "data_store_ids" {
  description = "Attach 落 app 嘅 data store id"
  value       = google_discovery_engine_search_engine.ge.data_store_ids
}

output "gcs_data_store_ids" {
  description = "起咗嘅 Cloud Storage data store id"
  value       = [for k, v in google_discovery_engine_data_store.gcs : v.data_store_id]
}
