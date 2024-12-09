resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "terraform-demo-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_us" {
  project                    = var.project_id
  name                        = "terraform-demo-subnet-us"
  ip_cidr_range              = "10.0.1.0/24"
  region = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_europe" {
  project                    = var.project_id
  name = "terraform-demo-subnet-europe"
  ip_cidr_range              = "10.0.2.0/24"
 region = "europe-west1"
  network       = google_compute_network.vpc_network.id

}

resource "google_compute_subnetwork" "subnet_asia" {
 project                    = var.project_id
  name          = "terraform-demo-subnet-asia"
 ip_cidr_range              = "10.0.3.0/24"
 region = "asia-southeast1"
  network       = google_compute_network.vpc_network.id
}
