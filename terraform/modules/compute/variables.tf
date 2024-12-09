variable "region" {
  description = "The region where instances will be created"
  type        = string
}

variable "project_id" {
    description = "The project where instances will be created"
    type = string
}

variable "subnet_us_id" {
  description = "The ID of the subnet where US instances will be created"
  type = string
}

variable "subnet_europe_id" {
  description = "The ID of the subnet where Europe instances will be created"
  type = string
}
