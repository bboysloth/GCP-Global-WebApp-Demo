resource "google_compute_router" "router" {
  name     = "terraform-demo-router"
  region   = "us-central1"
  project  = var.project_id
  network  = google_compute_network.vpc_network.id

}

resource "google_compute_router_nat" "nat" {
  name                               = "terraform-demo-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Default route to the internet gateway
resource "google_compute_route" "default_internet_gateway" {

    project = var.project_id
 name = "default-internet-gateway"
 dest_range = "0.0.0.0/0"
 network = google_compute_network.vpc_network.name

 next_hop_ilb = google_compute_router_nat.nat.id

 priority = 1000
}
