variable "project_id" {
  type = string
  description = "The Project ID"
}

variable "region" {
  type = string
  description = "The region"
}

variable "mig_us_instance_group" {
  type = string
  description = "The instance group for the load balancer in US",
  default = null
}

variable "mig_europe_instance_group" {
  type = string
  description = "Instance group for europe"
  default     = null
}

variable "mig_asia_instance_group" {
    type = string
    description = "Instance group for asia"
    default = null
}
