resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  }
}

resource "helm_release" "app" {
  name       = "webapp"
  namespace  = kubernetes_namespace.app.metadata.0.name
  repository = "https://azure-samples.github.io/helm-charts/"
  chart      = "aks-helloworld"

  set {
    name  = "title"
    value = var.app_title
  }
}
