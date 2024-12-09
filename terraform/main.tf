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

variable "project_id" {
  type = string
}

variable "region" {
  type        = string
  default     = "us-central1"
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

# Call the monitor module
module "monitor" {
  source     = "./modules/monitor"
  project_id = var.project_id
  subnet_id  = module.network.subnet_asia_id
}

module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
}

# Call the loadbalancer module for US
module "loadbalancer" {
  source                = "./modules/loadbalancer"
  project_id            = var.project_id
  region                = var.region
  mig_us_instance_group = module.compute_us.instance_group

}

# Call the loadbalancer module for europe
module "loadbalancer_europe" {
  source                = "./modules/loadbalancer"
  project_id            = var.project_id
  region                = "europe-west1"
  mig_us_instance_group = module.compute_europe.instance_group

}
