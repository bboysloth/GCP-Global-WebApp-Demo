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

# startup script can be moved to a seperate file later
    metadata_startup_script = <<-EOF
        #!/bin/bash
        sudo apt-get update
        sudo apt-get install apache2 -y
        sudo a2enmod rewrite
        cat <<EOT > /etc/apache2/sites-available/000-default.conf
        <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/html

            <Directory /var/www/html/>
                RewriteEngine On
                RewriteCond %{REQUEST_URI} !^/index.html$
                RewriteRule ^(.*)$ /index.html [L]
            </Directory>

            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined
        </VirtualHost>
        EOT
        sudo systemctl restart apache2
        echo "<h1>Hello from $(hostname) in $(curl -s http://metadata.google.internal/computeMetadata/v1/instance/zone -H 'Metadata-Flavor: Google')</h1><img src='https://storage.googleapis.com/gcp-simple-global-web-app-demo-us-${var.project_id}/image_bullet.jpg'>" > /var/www/html/index.html
        EOF
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
