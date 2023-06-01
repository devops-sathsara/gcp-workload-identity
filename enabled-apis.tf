resource "google_project_service" "enabled_apis" {
  for_each = var.enabled_apis
  project  = var.project
  service  = each.value
}