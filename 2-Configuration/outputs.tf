output "ingress_url" {
  description = "URL of Kubernetes ingress"
  value       = "http://${var.dns_label}.${data.azurerm_kubernetes_cluster.aks.location}.cloudapp.azure.com/"
}
