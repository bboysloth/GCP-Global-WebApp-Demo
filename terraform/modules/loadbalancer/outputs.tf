# Capture LoadBalancer Assigned IP

output "load_balancer_ip" {
  value = google_compute_global_address.web_server_lb_ip.address
}

output "http_health_check_id" {
  value = google_compute_http_health_check.http_health_check.id
}
