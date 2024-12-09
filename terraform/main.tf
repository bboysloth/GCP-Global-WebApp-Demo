# Configure the Google Cloud provider

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region = var.region
}

# Declare the project_id variable
variable "project_id" {
  type = string
}

# Declare the region variable
variable "region" {
  type        = string
  default     = "us-central1"
}

# Declare the project_number variable  <-- Added this line
variable "project_number" {
  type = number
}

# Call the network module
module "network" {
  source     = "./modules/network"
  project_id = var.project_id
}

# Call the compute module for US
module "compute_us" {
  source     = "./modules/compute"
  region     = var.region
  project_id = var.project_id
  subnet_id  = module.network.subnet_us_id
}

# Call the compute module for Europe
module "compute_europe" {
  source     = "./modules/compute"
  region     = "europe-west1"
  project_id = var.project_id
  subnet_id  = module.network.subnet_europe_id
}

# Call the storage module for US
module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
}

# Call the storage module for Europe
module "storage_europe" { #Renamed to avoid conflict
  source     = "./modules/storage"
  project_id = var.project_id

}

# Call the storage module for Asia
module "storage_asia" { #Renamed to avoid conflict
  source     = "./modules/storage"
  project_id = var.project_id

}

# Call the loadbalancer module for US
module "loadbalancer" {
  source = "./modules/loadbalancer"
  project_id = var.project_id
  region = var.region
  mig_us_instance_group = module.compute_us.instance_group
  mig_europe_instance_group = module.compute_europe.instance_group

}

# Call the loadbalancer module for europe, this will be removed because we are now using a global loadbalancer instead of a regional one
# module "loadbalancer_europe" {
#   source = "./modules/loadbalancer"
#   project_id = var.project_id
#   region = "europe-west1"
# mig_us_instance_group = null # explicitly set to null since it is optional
#   mig_europe_instance_group = module.compute_europe.instance_group

# }

# Call the monitor module
module "monitor" {
  source     = "./modules/monitor"
  project_id = var.project_id
  subnet_id  = module.network.subnet_asia_id
}
