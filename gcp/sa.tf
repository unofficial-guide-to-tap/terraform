
resource "google_service_account" "tap" {
  account_id   = "tap-${var.environment}"
  display_name = "Service account used by TAP to interact with GCP"
}

resource "google_service_account_key" "tapkey" {
  service_account_id = google_service_account.tap.name
}

resource "google_project_iam_member" "tap_owner" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.tap.email}"
}

output "service_account_key" {
  value = google_service_account_key.tapkey.private_key
  sensitive = true
}
