# azure-terraform-challenge

## Step 0

The purpose of this step is to ensure that you have your local environment set up and are familiar with the basic Terraform CLI commands by creating a virtual network with an empty subnet.

The exercises in this repo does not declare credential within the source code, but rather relies on implicit credentials set on your local environment. For example, you can log into an existing Azure subscription using:
```
az login
```
This exercise also assumes that an existing resource group is created in your Azure environment, and will not create a new resource group for you. This is such that users of Cloud Sandboxes (with resource group level access only) can do this exercise.

Once you've logged to your Azure subscription, modify the `rg_name` local parameter in the `main.tf` file (and the `rg_location` local if need be) to reflect the target resource group name and location.

```
locals {
  rg_name = "my-resource-group" // Append the resource group name here
  rg_location = "westus"
}
```
Navigate to this step's working directory, and initialise the directory as a terraform workspace
```bash
$ cd step0/
$ terraform init
```
Next, plan your terraform run to see which resources are going to be created, updated, or destroyed
```
$ terraform plan
```
Lastly, apply and follow the prompts to finally create the resources within your Azure resource group
```
$ terraform apply 
```
Check that the virtual network and subnet have been created in the Azure portal. You can simply clean up these resources using 
```
$ terraform destroy
```

## Step 1