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
  source     = "./modules/network"
  project_id = var.project_id
}

# Call the compute module
module "compute" {
  source     = "./modules/compute"
  region     = var.region
  project_id = var.project_id

  subnet_id     = module.network.subnet_us_id # For us-central1
}

# Compute Module for Europe (explicit)

module "compute" {
  source     = "./modules/compute"
  region     = "europe-west1" # Explicitly set the region for europe-west1
  project_id = var.project_id

  subnet_id = module.network.subnet_europe_id # For europe-west1
}

# Call the storage module
module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
}

# Call the loadbalancer module
module "loadbalancer" {
  source                   = "./modules/loadbalancer"
  region                   = var.region
  project_id               = var.project_id
  subnet_us_id             = module.network.subnet_us_id
  subnet_europe_id         = module.network.subnet_europe_id
  mig_us_instance_group    = module.compute.mig_us_instance_group
  mig_europe_instance_group = module.compute.mig_europe_instance_group
}

# Call the monitor module
module "monitor" {
  source     = "./modules/monitor"
  project_id = var.project_id
  subnet_id  = module.network.subnet_asia_id
}
