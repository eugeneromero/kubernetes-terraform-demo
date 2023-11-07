data "azurerm_kubernetes_cluster" "cluster" {
  name                = "my-cluster"
  resource_group_name = "terraform-kubernetes-demo"
}
