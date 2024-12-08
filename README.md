# GCP-Global-WebApp-Demo
Demo a Globally Distributed Web Application with Load Balancing and Static Content


Each Modules is broken out into 3 Terraform files (per standard) and will be used in a similar fashion to this example: 

    terraform/modules/network/main.tf: The Terraform code to create a VPC network (we'll use the default VPC for now to stay within the free tier).
    terraform/modules/network/variables.tf: Any variables needed for the network module.
    terraform/modules/network/outputs.tf: Any outputs from the network module (none for now).

