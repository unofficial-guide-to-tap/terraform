resource "google_service_account" "jumphost" {
  account_id   = "tap-${var.environment}-jumphost-sa"
  display_name = "TAP Jumphost Service Account For Environment ${var.environment}"
}

resource "google_compute_instance" "jumphost" {
  name         = "tap-${var.environment}-jumphost"
  machine_type = "e2-standard-2"
  zone = var.jumphost_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network =  google_compute_network.vpc.self_link
    access_config {
      // Ephemeral public IP
    }
  }
 
  tags = ["ssh"]

  metadata = {
    ssh-keys = "tapadmin:${var.jumphost_sshkey}"
  }

  metadata_startup_script = file("../common/jumphost-setup.sh")

  service_account {
    email  = google_service_account.jumphost.email
    scopes = ["cloud-platform"]
  }
}
