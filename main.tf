resource "google_iam_workload_identity_pool" "github_actions" {
  provider                  = google-beta
  project                   = var.project
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions pool"
  description               = "Workload Identity Pool managed by Terraform"
  depends_on                = [google_project_service.enabled_apis]
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  provider                           = google-beta
  project                            = var.project
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  display_name                       = "GitHub Actions provider"
  description                        = "Workload Identity Pool Provider managed by Terraform"
  attribute_condition                = "attribute.repository_owner==\"${var.github_username}\""
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.aud"              = "assertion.aud"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "github_actions" {
  project      = var.project
  account_id   = "github-actions"
  display_name = "github actions"
  description  = "Service Accounf for Workload Identity Pool used by GitHub Actions"
  depends_on   = [google_project_service.enabled_apis]
}

resource "google_project_iam_member" "roles" {
  project = var.project
  for_each = {
    "roles/resourcemanager.projectIamAdmin" = "roles/resourcemanager.projectIamAdmin",
    "roles/editor"                          = "roles/editor",
  }
  role   = each.value
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_service_account_iam_member" "wif-sa" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/*"
}