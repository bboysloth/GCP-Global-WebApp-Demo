variable "project_id" {
    type = string
    description = "The project ID"
}

variable "region" {
  type = string
  description = "The region for resources"
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID for compute instances"
}

variable "health_check_id" { # Add the health_check_id variable for auto-healing config
  type        = string
  description = "ID of the health check to use for autohealing"
}
