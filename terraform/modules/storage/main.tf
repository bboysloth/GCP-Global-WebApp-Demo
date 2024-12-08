# Create Regional Bucket for Static Content in the US

resource "google_storage_bucket" "bucket_us" {
  name     = "gcp-simple-global-web-app-demo-us-${var.project_id}" # Using project ID for unique naming
  project  = var.project_id
  location = "US-CENTRAL1"
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Create Regional bucket for static content in Europe

resource "google_storage_bucket" "bucket_europe" {
  name     = "gcp-simple-global-web-app-demo-europe-${var.project_id}" # Using project ID for unique naming
  project  = var.project_id
  location = "EUROPE-WEST1"
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_object" "object_us" {
    name = "image.png"
    bucket = google_storage_bucket.bucket_us.name
    source = "image.png"
}

resource "google_storage_bucket_object" "object_europe" {
    name = "image.png"
    bucket = google_storage_bucket.bucket_europe.name
    source = "image.png"
}
