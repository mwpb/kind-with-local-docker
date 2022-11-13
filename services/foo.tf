resource "kubernetes_deployment_v1" "foo" {
    metadata {
    name = "foo-deployment"
    labels = {
      app = "FooDeployment"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "FooDeployment"
      }
    }

    template {
      metadata {
        labels = {
          app = "FooDeployment"
        }
      }

      spec {
        container {
          image = "nginx:1.21"
          name  = "foo-deployment"

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
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "foo" {
  metadata {
    name = "foo-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.foo.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}