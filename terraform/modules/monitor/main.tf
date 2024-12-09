resource "google_compute_instance" "monitoring_instance" {
  project      = var.project_id
  name         = "monitoring-instance"
  machine_type = "e2-micro"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
  }
}
