output "google_service_account_email" {
  description = "Service Account Email used by GitHub Actions"
  value       = google_service_account.github_actions.email
}

output "google_iam_workload_identity_pool_provider_name" {
  description = "Workload Identity Pool Provider Name"
  value       = google_iam_workload_identity_pool_provider.github_actions.name
}