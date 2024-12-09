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
