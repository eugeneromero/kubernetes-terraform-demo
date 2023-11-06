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
cd 1-Infrastructure/
```
Deploy the infrastructure with Terraform:
```
terraform init
terraform plan
terraform apply
```
This will create the resource group and Kubernetes cluster (~4 mins).

## Deploy application and Kubernetes configuration
Once the cluster is in place, set up the Kubernetes credentials locally (adjust the values as needed if they have been changed in the Terraform code):
```
az aks get-credentials --resource-group terraform-kubernetes-demo --name my-cluster
```
Enter the configuration directory:
```
cd 2-Configuration/
```
Deploy the app and configuration with Terraform:
```
terraform init
terraform plan --var="app_title=fresh demo app" --var="dns_label=unique-dns-record" --out=terraform.tfplan
terraform apply terraform.tfplan
```

# Cleanup
The easiest way to clean up all the created resources is by deleting the Azure resource group (adjust naming if needed):
```
az group delete -n "terraform-kubernetes-demo"
```
