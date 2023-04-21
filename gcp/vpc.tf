resource "google_compute_network" "vpc" {
  name = "tap-${var.environment}-vpc"
  project  = var.project_id
  auto_create_subnetworks = true
}
