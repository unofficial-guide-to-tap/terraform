resource "google_compute_firewall" "icmp" {
  name    = "tap-${var.environment}-firewall-icmp"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = []
}

resource "google_compute_firewall" "ssh" {
  name    = "tap-${var.environment}-firewall-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}
