provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-local"
}

resource "kubernetes_ingress_v1" "local" {
  metadata {
    name = "local-ingress"
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = "foo-service"
              port {
                number = 80
              }
            }
          }

          path = "/foo/"
        }

        path {
          backend {
            service {
              name = "bar-service"
              port {
                number = 80
              }
            }
          }

          path = "/"
        }
      }
    }

    # tls {
    #   secret_name = "tls-secret"
    # }
  }
}

module "service" {
    source = "./services"
}