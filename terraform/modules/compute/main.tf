resource "google_compute_instance_template" "default" {
  name           = "web-server-template"
  machine_type   = "e2-micro"
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    subnetwork = var.subnet_id
  }

# startup script moved to main/scripts/startup_script.sh
  metadata = {
    startup-script = templatefile("${path.module}/../../../scripts/startup_script.sh", {
      project_id = var.project_id
    })
  }
}




resource "google_compute_region_instance_group_manager" "us_mig" {
  provider = google-beta
  name     = "web-server-mig-us"
  region   = "us-central1"
  project = var.project_id

  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }

  base_instance_name = "web-server-us"
}

resource "google_compute_region_instance_group_manager" "europe_mig" {
  provider = google-beta
  name     = "web-server-mig-europe"
  region   = "europe-west1"
  project = var.project_id

  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }

  base_instance_name = "web-server-europe"
}
