data "google_iam_policy" "admin" {
  binding {
    role = "roles/owner"
    members = []
  }
}

resource "google_service_account" "tap" {
  account_id   = "tap-${var.environment}"
  display_name = "Service account used by TAP to interact with GCP"
}

resource "google_service_account_key" "tapkey" {
  service_account_id = google_service_account.tap.name
}

resource "google_service_account_iam_policy" "tap-admin" {
  service_account_id = google_service_account.tap.name
  policy_data        = data.google_iam_policy.admin.policy_data
}

output "service_account_key" {
  value = google_service_account_key.tapkey.private_key
  sensitive = true
}
