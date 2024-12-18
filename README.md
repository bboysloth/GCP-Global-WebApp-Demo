# GCP-Global-WebApp-Demo
Demo a Globally Distributed Web Application with Load Balancing and Static Content


Each Modules is broken out into 3 Terraform files (per standard) and will be used in a similar fashion to this example: 

    terraform/modules/network/main.tf: The Terraform code to create a VPC network (we'll use the default VPC for now to stay within the free tier).
    terraform/modules/network/variables.tf: Any variables needed for the network module.
    terraform/modules/network/outputs.tf: Any outputs from the network module (none for now).

The demo is meant to be launched from a local terminal. 
Once you have performed a 'terraform init' and pulled down the repo, you will need to run your commands with the proper flags for the variables to populate
      Examples: 
            terraform plan -var="<project_id>" -var="<project_number>"
            terraform apply -var="<project_id>" -var="<project_number>"
            terraform destroy -var="<project_id>" -var="<project_number>"
