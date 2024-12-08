output "network_id" {
  value = google_compute_network.vpc_network.id
}

output "subnet_us_id" {
  value = google_compute_subnetwork.subnet_us.id
}

output "subnet_europe_id" {
  value = google_compute_subnetwork.subnet_europe.id
}

output "subnet_asia_id" {
  value = google_compute_subnetwork.subnet_asia.id
}
