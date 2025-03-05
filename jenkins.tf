resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "jenkins"
      }
    }
    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }
      spec {
        container {
          image = "jenkins/jenkins:lts"
          name  = "jenkins"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
  spec {
    selector = {
      app = "jenkins"
    }
    port {
      port        = 8080
      target_port = 8080
      node_port = 30080
    }
    type = "NodePort"
  }
}
