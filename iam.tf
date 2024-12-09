
# Grant Storage Object Viewer role to the default Compute Engine service account for each region.

data "google_compute_default_service_account" "us_central_default" {

 project = var.project_id
}
resource "google_project_iam_member" "viewer_us" {

 project = var.project_id
 role = "roles/storage.objectViewer"
 member = "serviceAccount:${data.google_compute_default_service_account.us_central_default.email}"
}

data "google_compute_default_service_account" "europe_west_default" {
    project = var.project_id

}

resource "google_project_iam_member" "viewer_europe" {

 project = var.project_id
 role = "roles/storage.objectViewer"
 member = "serviceAccount:${data.google_compute_default_service_account.europe_west_default.email}"

}

data "google_compute_default_service_account" "asia_southeast_default" {

 project = var.project_id
}

resource "google_project_iam_member" "viewer_asia" {

 project = var.project_id
 role = "roles/storage.objectViewer"
 member = "serviceAccount:${data.google_compute_default_service_account.asia_southeast_default.email}"
}
