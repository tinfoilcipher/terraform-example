# terraform-example

Example code to create an Azure Terraform environment based on my own tinfoilcipher environment.

To run, first download terraform from https://www.terraform.io/downloads.html.

You will need to have an authenticated service principle set up in your Azure Tenancy for this to work and to launch *terraform init* which establishes the connection to azurerm.

Once a connection is made, running *terraform plan* or *terraform apply* will prompt for your environment details and provision.
