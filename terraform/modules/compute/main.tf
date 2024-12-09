resource "google_compute_instance_template" "default" {
  name_prefix  = "web-server-template-${var.region}-" # Make names unique per region
  machine_type = "e2-micro"
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    subnetwork = var.subnet_id
  }

  metadata = {
    startup-script = templatefile("${path.module}/../../../scripts/startup_script.sh", {
      project_id = var.project_id,
      region     = var.region # Pass the region to the startup script
    })
  }
}

resource "google_compute_region_instance_group_manager" "mig" { # Removed us and europe from name
  provider              = google-beta
  name                  = "web-server-mig-${var.region}"  # Make names unique per region
  region                = var.region
  project               = var.project_id
  wait_for_instances    = false
  base_instance_name    = "web-server-${var.region}"

  version {
    name              = "primary"
    instance_template = google_compute_instance_template.default.id
  }
}
