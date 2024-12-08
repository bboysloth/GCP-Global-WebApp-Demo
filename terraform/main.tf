# Initial Main.tf for defining the providers, and calling all Modules

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0, < 5.0.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">=4.0.0, < 5.0.0"
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

# Call the network module
module "network" {
  source = "./modules/network"
  project_id = var.project_id
}

# Call the compute module
module "compute" {
  source = "./modules/compute"
  region = var.region
  project_id = var.project_id
}

# Call the storage module
module "storage" {
  source = "./modules/storage"
  project_id = var.project_id
}

# Call the loadbalancer module
module "loadbalancer" {
  source = "./modules/loadbalancer"
  region = var.region
  project_id = var.project_id
}

# Call the monitor module
module "monitor" {
  source = "./modules/monitor"
  project_id = var.project_id
}
