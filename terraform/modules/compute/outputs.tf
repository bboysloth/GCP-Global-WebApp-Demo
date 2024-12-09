output "instance_template_id" {
    value = google_compute_instance_template.default.self_link
}

output "instance_group" {
    value = google_compute_region_instance_group_manager.mig.instance_group
}
