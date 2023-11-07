data "azurerm_kubernetes_cluster" "aks" {
  name                = "my-cluster"
  resource_group_name = "terraform-kubernetes-demo"
}
