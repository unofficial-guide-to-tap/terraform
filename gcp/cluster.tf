resource "google_service_account" "cluster" {
  account_id   = "tap-${var.environment}-cluster-sa"
  display_name = "TAP Service Account For Environment ${var.environment}"
}

data "google_container_engine_versions" "versions" {
  provider       = google-beta
  location       = var.region
  project        = var.project_id
  version_prefix = "1.25."
}

resource "google_container_cluster" "cluster" {
  name                     = "tap-${var.environment}-cluster"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  release_channel {
    channel =  "UNSPECIFIED"
  }
  min_master_version = data.google_container_engine_versions.versions.latest_node_version
  network =  google_compute_network.vpc.self_link
}

resource "google_container_node_pool" "pool1" {
  name       = "pool1"
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  version = data.google_container_engine_versions.versions.latest_node_version

  node_config {
    preemptible  = false
    machine_type = "e2-standard-4"
    disk_size_gb = 100

    service_account = google_service_account.cluster.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
