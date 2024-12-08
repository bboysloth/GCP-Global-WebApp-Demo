# Capture LoadBalancer Assigned IP

output "load_balancer_ip" {
  value = google_compute_global_address.web_server_lb_ip.address
}
