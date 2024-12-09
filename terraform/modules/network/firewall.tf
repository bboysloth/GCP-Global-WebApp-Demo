resource "google_compute_firewall" "allow_ssh" {
  project     = var.project_id
  name        = "allow-ssh"
  network     = google_compute_network.vpc_network.name
  description = "Allow SSH traffic from anywhere"
  priority    = 1000
  direction   = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] 
}

resource "google_compute_firewall" "allow_http" {
  project     = var.project_id
  name        = "allow-http"
  network     = google_compute_network.vpc_network.name
  description = "Allow HTTP traffic from anywhere"
  priority    = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80"]

  }
  source_ranges = ["0.0.0.0/0"] 
}

resource "google_compute_firewall" "allow_https" {
  project     = var.project_id
  name        = "allow-https"
  network     = google_compute_network.vpc_network.name
  description = "Allow HTTPS traffic from anywhere"
  priority    = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["443"]

  }
  source_ranges = ["0.0.0.0/0"] 
}
