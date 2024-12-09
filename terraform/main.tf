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

# Call the compute module for US
module "compute_us" {
  source     = "./modules/compute"
  region     = var.region          # us-central1
  project_id = var.project_id
  subnet_id  = module.network.subnet_us_id
}

# Call the compute module for Europe
module "compute_europe" {
  source     = "./modules/compute"
  region     = "europe-west1"      # Explicitly set for Europe
  project_id = var.project_id
  subnet_id  = module.network.subnet_europe_id
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
  mig_us_instance_group    = module.compute_us.mig_us_instance_group # Updated reference
  mig_europe_instance_group = module.compute_europe.mig_europe_instance_group # Updated reference
}

# Call the monitor module
module "monitor" {
  source     = "./modules/monitor"
  project_id = var.project_id
  subnet_id  = module.network.subnet_asia_id
}
