
variable "project_id" {
    description = "The project ID for the load balancer"
    type = string
}

variable "region" {
    description = "The default region for the load balancer"
    type = string
}

variable "mig_us_instance_group" {
    description = "The self link of the MIG in the US"
    type = string
}

variable "mig_europe_instance_group" {
    description = "The self link of the MIG in Europe"
    type = string
}
