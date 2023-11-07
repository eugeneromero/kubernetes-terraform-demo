resource "azurerm_resource_group" "rg" {
  name     = "terraform-kubernetes-demo"
  location = var.azure_region
}
