# Azure Databricks Backend Private Link Terraform

Each folder contains a separate set of terraform that can you can run.
Run the terraform in this order:

1. azure_dbx_infra
2. uc

Each folder will also contain its own terraform state as we walk through the setup below.

## Setup

In the```azure_dbx_infra``` folder, copy the ```env.tfvars.example``` file into ```env.tfvars```. Modify the variables in the file to define your specifications. 

Make sure you have [az cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed on your terminal/cli.

On the terminal, run ```az login``` to log in to your Azure Portal. Depending on your permissions, you may need to request the cloud administrator to give you the appropriate permissions to create a resource group and objects within that.

Install the [terraform cli](https://developer.hashicorp.com/terraform/install) before proceeding.

In the terminal, change directory into the ```azure_dbx_infra``` folder and run ```terraform init``` to initializes the terraform configuration files. It will automatically download the appropriate providers defined in the ```providers.tf```. 

Run ```terraform plan -var-file="env.tfvars"``` to scope out the resources to be made/changed. 

After checking the plan, run ```terraform apply -var-file="env.tfvars"``` to create the objects. It will ask you to confirm in the terminal.

...

## Governance 

Below are optional choices in which you can configure UC. 

###  (Optional) Choice 1 - Set Up Unity Catalog (Creating the metastore, storage location, access connector, and assigning the workspace)


Change directory into the ```uc-secure``` folder.

Again, copy the ```env.tfvars.example``` file into ```env.tfvars```. Grab the ```resource ID``` string of the Databricks resource previously created and put it in the variable in the ```env.tfvars``` file. 

Run ```terraform init``` here to initializes the terraform configuration files again. 

Again, run ```terraform plan -var-file="env.tfvars"``` to scope out the resources to be made/changed. 

After checking the plan, run ```terraform apply -var-file="env.tfvars"``` to create the objects. It will ask you to confirm in the terminal.

Your workspace should now be enabled with Unity Catalog.

### (Optional) Choice 2 - Set Up Unity Catalog by Default (Creating the metastore and assigning the workspace)



Change directory into the ```uc-by-default``` folder.

Again, copy the ```env.tfvars.example``` file into ```env.tfvars```. Grab the ```resource ID``` string of the Databricks resource previously created and put it in the variable in the ```env.tfvars``` file. 

Run ```terraform init``` here to initializes the terraform configuration files again. 

Again, run ```terraform plan -var-file="env.tfvars"``` to scope out the resources to be made/changed. 

After checking the plan, run ```terraform apply -var-file="env.tfvars"``` to create the objects. It will ask you to confirm in the terminal.

Your workspace should now be enabled with Unity Catalog.

## Clean Up

Clean up the resources created, run ```terraform destroy -var-file="env.tfvars"``` in the ```uc``` folder first, then in the ```azure_dbx_infra``` folder. 