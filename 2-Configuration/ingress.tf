resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_controller" {
  name       = "ingress"
  namespace  = kubernetes_namespace.ingress.metadata.0.name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
    value = var.dns_label
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }
}

resource "kubectl_manifest" "ingress" {
  yaml_body = <<YAML
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: app
      namespace: ${kubernetes_namespace.app.metadata.0.name}
    spec:
      ingressClassName: nginx
      rules:
      - http:
          paths:
          - path: /
            pathType: ImplementationSpecific
            backend:
              service:
                name: aks-helloworld
                port:
                  number: 80
  YAML
}
