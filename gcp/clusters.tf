resource "google_service_account" "cluster" {
  count        = length(var.clusters)
  account_id   = "tap-${var.environment}-${var.clusters[count.index]}-sa"
  display_name = "TAP Service Account For Environment ${var.environment} (${var.clusters[count.index]})"
}

data "google_container_engine_versions" "versions" {
  provider       = google-beta
  location       = var.region
  project        = var.project_id
  version_prefix = "1.26."
}

resource "google_container_cluster" "cluster" {
  count                    = length(var.clusters)
  name                     = "tap-${var.environment}-${var.clusters[count.index]}"
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
  count      = length(var.clusters)
  name       = "pool1"
  location   = var.region
  cluster    = google_container_cluster.cluster[count.index].name
  node_count = 1
  version    = data.google_container_engine_versions.versions.latest_node_version

  node_config {
    preemptible  = false
    machine_type = "e2-standard-4"
    disk_size_gb = 100

    service_account = google_service_account.cluster[count.index].email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
