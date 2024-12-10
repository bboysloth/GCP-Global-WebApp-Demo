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

# Variables
variable "project_id" {}
variable "region" {
  default = "us-central1"
}

variable "project_number" {
  type = number
}

# Call the network module
module "network" {
  source     = "./modules/network"
  project_id = var.project_id
}

# Storage Bucket (single bucket for all regions)
module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
}

# Compute instances
module "compute_us" {
  source     = "./modules/compute"
  region     = var.region
  project_id = var.project_id
  subnet_id  = module.network.subnet_us_id
  health_check_id = module.loadbalancer.http_health_check_id # Pass health check ID
}

module "compute_europe" {
  source     = "./modules/compute"
  region     = "europe-west1"
  project_id = var.project_id
  subnet_id  = module.network.subnet_europe_id
  health_check_id = module.loadbalancer.http_health_check_id # Pass health check ID
}

module "compute_asia" {
  source     = "./modules/compute"
  region     = "asia-southeast1"
  project_id = var.project_id
  subnet_id  = module.network.subnet_asia_id
  health_check_id = module.loadbalancer.http_health_check_id # Pass health check ID
}

# Load Balancer
module "loadbalancer" {
  source                    = "./modules/loadbalancer"
  project_id                = var.project_id
  region                    = var.region 
  mig_us_instance_group     = module.compute_us.instance_group
  mig_europe_instance_group = module.compute_europe.instance_group
  mig_asia_instance_group   = module.compute_asia.instance_group

}
