resource "google_compute_instance_template" "default" {
  name_prefix  = "web-server-template-${var.region}-"
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
    startup-script = templatefile("${path.module}/../../../scripts/startup_script.sh",
      {
        project_id = var.project_id,
        region     = var.region,
    })
  }

  tags = ["webserver"]

}

resource "google_compute_region_instance_group_manager" "mig" {
  provider = google-beta
  project = var.project_id
  name     = "web-server-mig-${var.region}" # Unique name based on region
  region   = var.region
 # wait_for_instances = false
  target_size = 2  #changed from 1 to 2 to demonstrate round-robin responses from MIG

  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  auto_healing_policies {
    health_check      = var.health_check_id
    initial_delay_sec = 30
  }



  base_instance_name = "web-server-${var.region}"

}
