variable "project_id" {
    description = "The project ID for the load balancer"
    type = string
}

variable "region" {
    description = "The default region for the load balancer"
    type = string
}

variable "mig_us_instance_group" {
    description = "The instance group for the load balancer in US"
    type = string
}
