resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "terraform-demo-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_us" {
  project                    = var.project_id
  name                        = "terraform-demo-subnet-us"
  ip_cidr_range              = "10.0.1.0/24"
  region                     = "us-central1"
 network                    = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_europe" {
  project                    = var.project_id
  name                        = "terraform-demo-subnet-europe"
  ip_cidr_range              = "10.0.2.0/24"
 region                     = "europe-west1"
  network                    = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_asia" {
  project                    = var.project_id
 name                        = "terraform-demo-subnet-asia"
  ip_cidr_range              = "10.0.3.0/24"
  region                     = "asia-southeast1"
  network                    = google_compute_network.vpc_network.id
}

resource "google_compute_router" "router_us" {
  name     = "terraform-demo-router-us-central1"
  region   = "us-central1"
  project  = var.project_id
  network  = google_compute_network.vpc_network.id
}

resource "google_compute_router" "router_europe" {
 name     = "terraform-demo-router-europe-west1"
 region   = "europe-west1"
 project  = var.project_id
 network  = google_compute_network.vpc_network.id
}

resource "google_compute_router" "router_asia" {
  name     = "terraform-demo-router-asia-southeast1"
  region   = "asia-southeast1"
 project  = var.project_id
 network  = google_compute_network.vpc_network.id

}

resource "google_compute_router_nat" "nat_us" {
 name                               = "terraform-demo-nat-us-central1"
 router                             = google_compute_router.router_us.name
 region                             = google_compute_router.router_us.region
 project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
 source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

}

resource "google_compute_router_nat" "nat_europe" {
  name                               = "terraform-demo-nat-europe-west1"
  router                             = google_compute_router.router_europe.name
 region                             = google_compute_router.router_europe.region
  project                            = var.project_id
 nat_ip_allocate_option             = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

}

resource "google_compute_router_nat" "nat_asia" {
  name                               = "terraform-demo-nat-asia-southeast1"
 router                             = google_compute_router.router_asia.name
  region                             = google_compute_router.router_asia.region
 project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
 source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

}

# Default route to the internet gateway (this is GLOBAL so only needs to be defined once)

resource "google_compute_route" "default_internet_gateway" {

 project = var.project_id
 name = "default-internet-gateway"
 dest_range = "0.0.0.0/0"

 network = google_compute_network.vpc_network.name
 next_hop_gateway = "global/gateways/default-internet-gateway"

 priority = 1000
}
