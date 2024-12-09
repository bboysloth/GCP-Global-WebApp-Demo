resource "google_compute_health_check" "http_health_check" {
  project             = var.project_id
  name                = "web-server-health-check"
  healthy_threshold   = 1
  unhealthy_threshold = 3
  timeout_sec         = 3
  check_interval_sec  = 5
  http_health_check {
    port = "80"
  }
}

resource "google_compute_region_backend_service" "backend_service_us" {
  provider              = google-beta
  project               = var.project_id
  name                  = "web-server-backend-us"
  region                = "us-central1"
  protocol              = "HTTP"
  health_checks         = [google_compute_health_check.http_health_check.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group           = google_compute_region_instance_group_manager.us_mig.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }
}

resource "google_compute_region_backend_service" "backend_service_europe" {
  provider              = google-beta
  project               = var.project_id
  name                  = "web-server-backend-europe"
  region                = "europe-west1"
  protocol              = "HTTP"
  health_checks         = [google_compute_health_check.http_health_check.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group           = google_compute_region_instance_group_manager.europe_mig.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }
}

resource "google_compute_url_map" "url_map" {
  project         = var.project_id
  name            = "web-server-url-map"
  default_service = google_compute_region_backend_service.backend_service_us.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.backend_service_us.id

    path_rule {
      paths   = ["/us/*"]
      service = google_compute_region_backend_service.backend_service_us.id
    }

    path_rule {
      paths   = ["/europe/*"]
      service = google_compute_region_backend_service.backend_service_europe.id
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
  name    = "web-server-lb-ip"
}
