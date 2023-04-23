
resource "google_dns_managed_zone" "zone" {
  count       = var.use_existing_zone ? 0 : 1
  name        = "tap-${var.environment}"
  dns_name    = var.zone_dns_name
  description = "DNS zone for the TAP ${var.environment} environment"
}

resource "google_dns_record_set" "tap" {
  count       = var.use_existing_zone ? 0 : 1
  name = "*.${google_dns_managed_zone.zone[0].dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = google_dns_managed_zone.zone[0].name

  rrdatas = [ var.tap_address ]
}

resource "google_dns_record_set" "cnrs" {
  count       = var.use_existing_zone ? 0 : 1
  name = "*.cnrs.${google_dns_managed_zone.zone[0].dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = google_dns_managed_zone.zone[0].name

  rrdatas = [ var.cnrs_address ]
}