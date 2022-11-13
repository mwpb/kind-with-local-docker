resource "kubernetes_deployment_v1" "bar" {
    metadata {
        name = "bar-deployment"
        labels = {
        app = "barDeployment"
        }
    }

  spec {
    selector {
      match_labels = {
        app = "barDeployment"
      }
    }

    template {
      metadata {
        labels = {
          app = "barDeployment"
        }
      }

      spec {
        container {
          image = "kindtest"
          name  = "bar-deployment"
          image_pull_policy = "Never"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 8080
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "bar" {
  metadata {
    name = "bar-service"
    labels = {
        app = "bar-service"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.bar.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }
}