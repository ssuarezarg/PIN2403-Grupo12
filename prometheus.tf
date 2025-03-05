resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "15.0.0" # Ajusta a la versión deseada
  values     = [
    <<EOF
    alertmanager:
      enabled: true
    server:
      service:
        type: NodePort
    EOF
  ]
}

