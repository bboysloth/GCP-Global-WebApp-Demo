output "instance_template_id" {
  value = google_compute_instance_template.default.id
}

output "mig_us_self_link" {
  value = google_compute_region_instance_group_manager.us_mig.self_link
}

output "mig_europe_self_link" {
  value = google_compute_region_instance_group_manager.europe_mig.self_link
}
