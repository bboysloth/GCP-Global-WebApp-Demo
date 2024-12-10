resource "google_compute_region_health_check" "http_health_check_us" {
  project             = var.project_id
  name                = "web-server-health-check-us"
  region              = "us-central1"
  healthy_threshold   = 1
  unhealthy_threshold = 3
  timeout_sec         = 3
  check_interval_sec  = 5
  port                = 80  # Direct attribute of the health check
  request_path        = "/" # Direct attribute of the health check
}

resource "google_compute_region_health_check" "http_health_check_europe" {
  project             = var.project_id
  name                = "web-server-health-check-europe"
  region              = "europe-west1"
  healthy_threshold   = 1
  unhealthy_threshold = 3
  timeout_sec         = 3
  check_interval_sec  = 5
  port                = 80 # Direct attribute of the health check
  request_path        = "/" # Direct attribute of the health check
}

resource "google_compute_region_health_check" "http_health_check_asia" {
  project             = var.project_id
  name                = "web-server-health-check-asia"
  region              = "asia-southeast1"
  healthy_threshold   = 1
  unhealthy_threshold = 3
  timeout_sec         = 3
  check_interval_sec  = 5
  port                = 80  # Direct attribute of the health check
  request_path        = "/" # Direct attribute of the health check
}

resource "google_compute_region_backend_service" "backend_service_us" {
  provider              = google-beta
  project               = var.project_id
  name                  = "backend-service-us"
  region                = "us-central1"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_region_health_check.http_health_check_us.id]

  backend {
    group           = var.mig_us_instance_group
    balancing_mode  = "RATE"
    max_rate_per_instance = 10
    capacity_scaler = 1
  }
}

resource "google_compute_region_backend_service" "backend_service_europe" {
  provider              = google-beta
  project               = var.project_id
  name                  = "backend-service-europe"
  region                = "europe-west1"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_region_health_check.http_health_check_europe.id]

  backend {
    group           = var.mig_europe_instance_group
    balancing_mode  = "RATE"
    max_rate_per_instance = 10
    capacity_scaler = 1
  }
}

resource "google_compute_region_backend_service" "backend_service_asia" {
  provider              = google-beta
  project               = var.project_id
  name                  = "backend-service-asia"
  region                = "asia-southeast1"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_region_health_check.http_health_check_asia.id]

  backend {
    group           = var.mig_asia_instance_group
    balancing_mode  = "RATE"
    max_rate_per_instance = 10
    capacity_scaler = 1
  }
}

resource "google_compute_url_map" "url_map" {
  project         = var.project_id
  name            = "web-server-url-map"
  default_service = google_compute_region_backend_service.backend_service_us.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "region-matcher"
  }

  path_matcher {
    name            = "region-matcher"
    default_service = google_compute_region_backend_service.backend_service_us.id

    path_rule {
      paths   = ["/us/*"]
      service = google_compute_region_backend_service.backend_service_us.id
    }

    path_rule {
      paths   = ["/europe/*"]
      service = google_compute_region_backend_service.backend_service_europe.id
    }

    path_rule {
      paths   = ["/asia/*"]
      service = google_compute_region_backend_service.backend_service_asia.id
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
