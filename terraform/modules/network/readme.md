Explanation of this code block:


    google_compute_network "vpc_network": This resource creates a custom VPC network named terraform-demo-vpc.

    auto_create_subnetworks = false: We set this to false because we want to create our own custom subnets.

    google_compute_subnetwork: This creates our subnets.

    subnet_us in us-central1 with CIDR 10.0.1.0/24

    subnet_europe in europe-west1 with CIDR 10.0.2.0/24

    subnet_asia in asia-southeast1 with CIDR 10.0.3.0/24
