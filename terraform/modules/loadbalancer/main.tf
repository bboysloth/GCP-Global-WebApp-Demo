resource "google_compute_region_health_check" "http_health_check" {
  project             = var.project_id
  name                = "web-server-health-check-${var.region}"
  region              = var.region
  healthy_threshold   = 1
  unhealthy_threshold = 3
  timeout_sec         = 3
  check_interval_sec  = 5
  http_health_check {
    port = "80"
  }
}

resource "google_compute_region_backend_service" "backend_service" {
  provider = google-beta
  project             = var.project_id
  name                = "web-server-backend-${var.region}"
  region              = var.region
  protocol            = "HTTP"
  health_checks       = [google_compute_region_health_check.http_health_check.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group           = var.mig_us_instance_group # Correct: Use mig_us_instance_group here
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
    max_utilization = 0.8
  }
}

resource "google_compute_url_map" "url_map" {
  project         = var.project_id
  name            = "web-server-url-map"
  default_service = google_compute_region_backend_service.backend_service.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.backend_service.id
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
  name    = "web-server-lb-ip"
}
