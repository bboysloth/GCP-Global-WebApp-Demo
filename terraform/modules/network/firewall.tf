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

# Allow internal traffic within the VPC network
resource "google_compute_firewall" "allow_internal" {

 project = var.project_id
 name = "allow-internal"
 network = google_compute_network.vpc_network.name

 description = "Allow internal traffic on the network"

 priority = 65534
 direction = "INGRESS"

 allow {
 protocol = "all"
 }



 source_ranges = [

 "10.0.1.0/24", # us-central1 subnet
 "10.0.2.0/24", # europe-west1 subnet
 "10.0.3.0/24"  # asia-southeast1 subnet

 ]
 target_tags = ["webserver"] # Added target tag for this firewall rule
}
