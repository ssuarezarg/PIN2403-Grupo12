resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  version    = "8.10.1" # Date 21-2-25
  values     = [
    <<EOF
    persistence:
      enabled: true
      size: 10Gi
    service:
      type: NodePort
      port: 3000
      nodePort: 30000
    EOF
  ]
}
