resource "google_storage_bucket" "bucket" {  # Removed "_us" suffix, will append region later
  project  = var.project_id

  # Dynamically create bucket name per region using variable
  name                        = "gcp-simple-global-web-app-demo-${var.region}-${var.project_id}"
  location = var.region # Use variable to determine location
  uniform_bucket_level_access = true

  website {

    main_page_suffix = "index.html"
    not_found_page   = "404.html"

  }
}

resource "google_storage_bucket_object" "object_us" {
    name = "image_bullet.jpg"
    bucket = google_storage_bucket.bucket["us_central1"].name

    source = "${path.module}/images/image_bullet.jpg"

}

resource "google_storage_bucket_object" "object_europe" {
    name = "image_dome.jpg"

 bucket = google_storage_bucket.bucket["europe_west1"].name
    source = "${path.module}/images/image_dome.jpg"

}

resource "google_storage_bucket_object" "object_asia" {

    name = "image_asia.jpg"
 bucket = google_storage_bucket.bucket["asia_southeast1"].name
    source = "${path.module}/images/image_eye.jpg"

}
