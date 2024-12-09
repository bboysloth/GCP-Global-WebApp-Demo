resource "google_compute_http_health_check" "http_health_check" { # Corrected resource type
 project             = var.project_id
 name                = "web-server-health-check-global"
 healthy_threshold   = 1
 unhealthy_threshold = 3
 timeout_sec         = 3
 check_interval_sec  = 5

 # http_health_check {
 #  port = 80
 # }
}

resource "google_compute_backend_service" "backend_service" { # Global backend service

 project             = var.project_id
 name                = "web-server-backend-global"
 port_name           = "http"
 protocol            = "HTTP"
 timeout_sec         = 10
 health_checks       = [google_compute_http_health_check.http_health_check.id]
 load_balancing_scheme = "EXTERNAL_MANAGED"

 dynamic "backend" {
   for_each = var.mig_us_instance_group != null ? [1] : []

   content {
     group = var.mig_us_instance_group
     balancing_mode = "RATE"
     max_rate_per_instance = 10
     capacity_scaler = 1

   }
 }

 dynamic "backend" { # second backend definition
  for_each = var.mig_europe_instance_group != null ? [1] : []
    content {
      group = var.mig_europe_instance_group

      balancing_mode = "RATE"
      max_rate_per_instance = 10

 capacity_scaler = 1
    }
 }
}

resource "google_compute_url_map" "url_map" {

 project         = var.project_id
 name            = "web-server-url-map"
 default_service = google_compute_backend_service.backend_service.id #Points to global backend service

 host_rule {

   hosts        = ["*"]
   path_matcher = "allpaths"

 }

 path_matcher {
   name            = "allpaths"
   default_service = google_compute_backend_service.backend_service.id #Points to global backend service

   path_rule {
     paths   = ["/us/*"]
     service = google_compute_backend_service.backend_service.self_link #Points to global backend service
   }

   path_rule {
     paths   = ["/europe/*"]
     service = google_compute_backend_service.backend_service.self_link#Points to global backend service
 }

 }
}

resource "google_compute_target_http_proxy" "http_proxy" {

 project  = var.project_id
 name     = "web-server-http-proxy"
 url_map  = google_compute_url_map.url_map.id

}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {

 project               = var.project_id
 name                  = "web-server-forwarding-rule"
 target                = google_compute_target_http_proxy.http_proxy.id
 port_range            = "80"

 load_balancing_scheme = "EXTERNAL_MANAGED"
 ip_address            = google_compute_global_address.web_server_lb_ip.address



}

resource "google_compute_global_address" "web_server_lb_ip" {

 project = var.project_id
 name    = "web-server-lb-ip-${var.region}"



}
