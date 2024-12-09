output "bucket_self_link_us" {
    value = google_storage_bucket.bucket["us_central1"].self_link
}

output "bucket_self_link_europe" {
    value = google_storage_bucket.bucket["europe_west1"].self_link

}
output "bucket_self_link_asia" {
    value = google_storage_bucket.bucket["asia_southeast1"].self_link
}
