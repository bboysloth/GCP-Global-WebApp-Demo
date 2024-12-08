variable "project_id" {
    description = "The project ID for the load balancer"
    type = string
}

variable "region" {
    description = "The default region for the load balancer"
    type = string
}

variable "mig_us_self_link" {
    description = "The self link of the MIG in the US"
    type = string
}

variable "mig_europe_self_link" {
    description = "The self link of the MIG in Europe"
    type = string
}

variable "subnet_us_id" {
    description = "The ID of the subnet in the us region"
    type = string
}

variable "subnet_europe_id" {
    description = "The ID of the subnet in the europe region"
    type = string
}
