variable "region" {
  description = "The region where instances will be created"
  type        = string
}

variable "project_id" {
    description = "The project where instances will be created"
    type = string
}

variable "subnet_id" {
  description = "The ID of the subnet where instances will be created"
  type = string
}
