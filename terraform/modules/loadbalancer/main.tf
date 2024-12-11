resource "google_compute_http_health_check" "http_health_check" {
 project             = var.project_id
 name                = "web-server-health-check-global"
 check_interval_sec  = 5
 timeout_sec         = 1
 healthy_threshold   = 2
 unhealthy_threshold = 3

 request_path = "/"  #  Added a required field
}

resource "google_compute_backend_service" "backend_service" {
  provider = google-beta
 project             = var.project_id
 name                = "web-server-backend-global" # Global backend service
 port_name           = "http"
 protocol            = "HTTP"
 timeout_sec         = 10
 health_checks       = [google_compute_http_health_check.http_health_check.id]
 load_balancing_scheme = "EXTERNAL_MANAGED"


 dynamic "backend" { # Dynamically create backend for US for GLOBAL backend Service
   for_each = var.mig_us_instance_group != null ? [1] : []

   content {
     group           = var.mig_us_instance_group
     balancing_mode  = "RATE"
     max_rate_per_instance = 10
     capacity_scaler = 1

   }
 }

 dynamic "backend" { # Dynamically create backend for Europe for GLOBAL backend Service
   for_each = var.mig_europe_instance_group != null ? [1] : []

   content {
     group           = var.mig_europe_instance_group
     balancing_mode  = "RATE"
     max_rate_per_instance = 10
     capacity_scaler = 1

   }
 }

 dynamic "backend" { # Dynamically create backend for ASIA for GLOBAL backend Service
   for_each = var.mig_asia_instance_group != null ? [1] : []

   content {
     group           = var.mig_asia_instance_group
     balancing_mode  = "RATE"
     max_rate_per_instance = 10
     capacity_scaler = 1

   }
 }

}

#Stand-Alone (URL Map) Asia based Backend Service

resource "google_compute_backend_service" "backend_service_asia" {
  provider = google-beta
 project             = var.project_id
 name                = "web-server-backend-asia" # Global backend service
 port_name           = "http"
 protocol            = "HTTP"
 timeout_sec         = 10
 health_checks       = [google_compute_http_health_check.http_health_check.id]
 load_balancing_scheme = "EXTERNAL_MANAGED" 

dynamic "backend" { # Dynamically create backend for Asia
   for_each = var.mig_asia_instance_group != null ? [1] : []

   content {
     group           = var.mig_asia_instance_group
     balancing_mode  = "RATE"
     max_rate_per_instance = 10
 capacity_scaler = 1

   }
 }
}

# Stand-Alone (URL Map) European based Backend Service

resource "google_compute_backend_service" "backend_service_europe" {
  provider = google-beta
 project             = var.project_id
 name                = "web-server-backend-europe" # Global backend service
 port_name           = "http"
 protocol            = "HTTP"
 timeout_sec         = 10
 health_checks       = [google_compute_http_health_check.http_health_check.id]
 load_balancing_scheme = "EXTERNAL_MANAGED"

 dynamic "backend" { # Dynamically create backend for Europe
   for_each = var.mig_europe_instance_group != null ? [1] : []

   content {
     group           = var.mig_europe_instance_group
     balancing_mode  = "RATE"
     max_rate_per_instance = 10
     capacity_scaler = 1

   }
 }
}

resource "google_compute_url_map" "url_map" {
 project         = var.project_id
 name            = "web-server-url-map"
 default_service = google_compute_backend_service.backend_service.id

 host_rule {
   hosts        = ["*"]
   path_matcher = "allpaths"
 }

 path_matcher {
   name            = "allpaths"
   default_service = google_compute_backend_service.backend_service.id
   # This Rule will default everything to the US backend unless geo-locationally closer to other Europe/Asia MIGs

   path_rule {
     paths   = ["/us/*"]
     service = google_compute_backend_service.backend_service.id

   }

   path_rule {

     paths   = ["/europe/*"]
     service = google_compute_backend_service.backend_service_europe.id

 }
 path_rule {

  paths = ["/asia/*"]
  service = google_compute_backend_service.backend_service_asia.id
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
