output "project_id" {
  description = "The existing project GE was deployed into."
  value       = var.project_id
}

output "ge_app_engine_id" {
  description = "GE app (search engine) ID; only set when create_ge_app = true."
  value       = var.create_ge_app ? module.ge[0].engine_id : null
}

output "next_step_manual" {
  description = "Manual steps Terraform cannot do."
  value       = <<-EOT

    Deploying GE into an existing project: billing is owned by the project owner;
    this root does not touch billing. If the search engine fails to create
    (subscription error), start the GE 30-day trial in the Console first:
    https://console.cloud.google.com/gen-app-builder?project=${var.project_id}
  EOT
}
