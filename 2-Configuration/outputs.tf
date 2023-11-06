output "ingress_url" {
  description = "URL of Kubernetes ingress"
  value       = "http://${var.dns_label}.norwayeast.cloudapp.azure.com/"
}
