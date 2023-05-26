resource "google_service_account" "jumphost" {
  account_id   = "tap-${var.environment}-jumphost-sa"
  display_name = "TAP Jumphost Service Account For Environment ${var.environment}"
}

resource "google_compute_instance" "jumphost" {
  name         = "tap-gcp-${var.environment}-jumphost"
  machine_type = "e2-standard-2"
  zone         = var.jumphost_zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2210-amd64"
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
    ssh-keys = "${var.jumphost_user}:${var.jumphost_sshkey}"
  }

  metadata_startup_script = file("../common/jumphost-setup.sh")

  service_account {
    email  = google_service_account.jumphost.email
    scopes = ["cloud-platform"]
  }
}

output "jumphost_user" {
  value = "tapadmin"
}

output "jumphost_address" {
  value = google_compute_instance.jumphost.network_interface.0.access_config.0.nat_ip
}
