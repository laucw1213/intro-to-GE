output "project_id" {
  description = "部署 GE 嘅現成 project"
  value       = var.project_id
}

output "ge_app_engine_id" {
  description = "GE app (search engine) ID，create_ge_app = true 先有"
  value       = var.create_ge_app ? module.ge[0].engine_id : null
}

output "next_step_manual" {
  description = "Terraform 做唔到嘅手動步驟"
  value       = <<-EOT

    ℹ️ 現成 project 部署 GE：billing 由 project 擁有者 / lab 負責，呢個 root 唔掂 billing。
    如果 search engine 起唔到（subscription 錯誤），要先去 Console 啟動 GE 30-day trial：
    https://console.cloud.google.com/gen-app-builder?project=${var.project_id}
  EOT
}
