resource "google_storage_bucket" "default" {
 project  = var.project_id
 name                        = "gcp-simple-global-web-app-demo-${var.project_id}" # Simplified bucket name
 location = "US"  # Fixed location for simplicity
 uniform_bucket_level_access = true

 website {
   main_page_suffix = "index.html"
   not_found_page   = "404.html"
 }
}

resource "google_storage_bucket_object" "object_us" {
 name   = "image_bullet.jpg"
 bucket = google_storage_bucket.default.name #Reference single bucket
 source = "${path.module}/images/image_bullet.jpg"
}

resource "google_storage_bucket_object" "object_europe" {
 name   = "image_dome.jpg"
 bucket = google_storage_bucket.default.name #Reference single bucket
 source = "${path.module}/images/image_dome.jpg"
}

resource "google_storage_bucket_object" "object_asia" {
 name   = "image_asia.jpg"
 bucket = google_storage_bucket.default.name #Reference single bucket
 source = "${path.module}/images/image_asia.jpg"
}
