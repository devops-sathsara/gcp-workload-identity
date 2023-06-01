variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "github_username" {
  type    = string
  default = "devops-sathsara"
}

variable "enabled_apis" {
  type = set(string)
  default = [
    # MUST-HAVE for GitHub Actions setup
    "iam.googleapis.com",                  # Identity and Access Management (IAM) API
    "iamcredentials.googleapis.com",       # IAM Service Account Credentials API
    "cloudresourcemanager.googleapis.com", # Cloud Resource Manager API
    "sts.googleapis.com",                  # Security Token Service API

    # You can add more apis to enable in the project
  ]
}