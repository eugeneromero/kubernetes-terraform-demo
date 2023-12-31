# Introduction
Demo setup for the **"Automate every layer: Using Terraform to deploy, configure and maintain Azure Kubernetes clusters"** talk.

# Pre-requisites
* [Azure subscription](https://azure.microsoft.com/en-us/free/)
* [Docker](https://docs.docker.com/get-docker/)

# Instructions
**NOTE:** Run all commands from the root of the repository.

## First time set up
This repository includes a [Dockerfile](./Dockerfile) for building a Docker image containing [`az-cli`](https://learn.microsoft.com/en-us/cli/azure/), [`terraform`](https://developer.hashicorp.com/terraform/intro), [`kubectl`](https://kubernetes.io/docs/reference/kubectl/) and [`kubectx/kubens`](https://github.com/ahmetb/kubectx). Build the image locally by running:
```
docker build . -t terraform-azcli
```

## Logging into Azure
Run the container built in the previous step:
```
docker run --rm -it -v $(pwd):/code terraform-azcli
```
**NOTE:** All commands from this point on are ran inside this container.

Log into Azure. This is necessary for Terraform to be able to deploy to your Azure subscription:
```
az login
```

## Deploy infrastructure repository
Enter the infrastructure directory:
```
cd /code/1-Infrastructure/
```
Set up Terraform:
```
terraform init
```
Get an overview of what will be created:
```
terraform plan --var="azure_region=[AZURE-REGION]" --out=terraform.tfplan
```
Finally, deploy the infrastructure:
```
terraform apply terraform.tfplan
```
This will create the resource group and Kubernetes cluster (should take about ~4 minutes).

## Deploy application and Kubernetes configuration
Once the cluster is in place, set up the Kubernetes credentials locally (adjust the values as needed if they have been changed in the Terraform code):
```
az aks get-credentials --resource-group terraform-kubernetes-demo --name my-cluster
```
Enter the configuration directory:
```
cd /code/2-Configuration/
```
Set up Terraform:
```
terraform init
```
Get an overview of what will be created:
```
terraform plan --var="app_title=[TEXT TO SHOW ON APP]" --var="dns_label=[UNIQUE-DNS-NAME]" --out=terraform.tfplan
```
Finally, deploy the infrastructure:
```
terraform apply terraform.tfplan
```

# Checks
To find the app's URL, run:
```
terraform output
```
For troubleshooting, check the ingress container's logs in the `ingress-nginx` namespace, and the app container's logs in the `app` namespace.

# Cleanup
The easiest way to clean up all the created resources is by deleting the Azure resource group (adjust naming if needed):
```
az group delete -n "terraform-kubernetes-demo"
```
To perform a new test, all Terraform files in each directory can be cleaned by running the `tr` alias found in the Docker image.
