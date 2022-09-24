locals {
  app_name = "keycloak"
  app_port = 8080
}

resource "kubernetes_service" "keycloak" {
  metadata {
    name      = local.app_name
    namespace = local.keycloak_namespace

    labels = {
      app = "keycloak"
    }

    annotations = {
      "traefik.ingress.kubernetes.io/service.sticky.cookie"        = "true"
      "traefik.ingress.kubernetes.io/service.sticky.cookie.secure" = "true"
    }
  }

  spec {
    port {
      name        = "http"
      port        = local.app_port
      target_port = local.app_port
    }

    selector = {
      app = local.app_name
    }
  }

  depends_on = [
    helm_release.keycloak_database
  ]
}

resource "kubernetes_service" "keycloak_headless" {
  metadata {
    name      = "${local.app_name}-headless"
    namespace = local.keycloak_namespace
  }

  spec {
    type                        = "ClusterIP"
    cluster_ip                  = "None"
    publish_not_ready_addresses = true
    ip_family_policy            = "SingleStack"
    ip_families                 = ["IPv4"]

    port {
      name        = "http"
      port        = local.app_port
      target_port = "http"
      protocol    = "TCP"
    }

    selector = {
      app = "keycloak"
    }
  }

  depends_on = [
    helm_release.keycloak_database
  ]
}

resource "kubernetes_deployment" "keycloak" {
  metadata {
    name      = local.app_name
    namespace = local.keycloak_namespace

    labels = {
      app = local.app_name
    }
  }

  spec {
    replicas = var.keycloak_replicas

    selector {
      match_labels = {
        app = local.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.app_name
        }
      }

      spec {
        container {
          name  = local.app_name
          image = "quay.io/keycloak/keycloak:19.0.1"
          args  = ["start"]

          port {
            name           = "http"
            container_port = local.app_port
          }

          env {
            name  = "KC_LOG_LEVEL"
            value = var.keycloak_log_level
          }

          env {
            name  = "KC_METRICS_ENABLED"
            value = "true"
          }

          env {
            name  = "KC_HEALTH_ENABLED"
            value = "true"
          }

          env {
            name  = "KEYCLOAK_ADMIN"
            value = var.keycloak_admin_username
          }

          env {
            name  = "KEYCLOAK_ADMIN_PASSWORD"
            value = var.keycloak_admin_password
          }

          env {
            name  = "KC_PROXY"
            value = "edge"
          }

          env {
            name  = "KC_CACHE"
            value = "ispn"
          }

          env {
            name  = "KC_CACHE_STACK"
            value = "kubernetes"
          }

          env {
            name  = "KC_HOSTNAME"
            value = var.keycloak_domain
          }

          env {
            name  = "KC_DB"
            value = "postgres"
          }

          env {
            name  = "KC_DB_SCHEMA"
            value = "public"
          }

          env {
            name  = "KC_DB_URL_HOST"
            value = "keycloak-db-postgresql-ha-pgpool"
          }

          env {
            name  = "KC_DB_URL_DATABASE"
            value = "postgres"
          }

          env {
            name  = "KC_DB_USERNAME"
            value = "postgres"
          }

          env {
            name = "KC_DB_PASSWORD"

            value_from {
              secret_key_ref {
                name = "keycloak-db-postgresql-ha-postgresql"
                key  = "postgresql-password"
              }
            }
          }

          env {
            name  = "JAVA_OPTS_APPEND"
            value = "-Djgroups.dns.query=${local.app_name}-headless.${local.keycloak_namespace}.svc.cluster.local"
          }

          readiness_probe {
            http_get {
              path = "/realms/master"
              port = local.app_port
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.keycloak
  ]
}

resource "kubernetes_ingress_v1" "keycloak" {
  metadata {
    name      = "keycloak-ingress"
    namespace = local.keycloak_namespace

    annotations = {
      "kubernetes.io/ingress.class" = var.ingress_class
    }
  }

  spec {
    tls {
      hosts       = [var.keycloak_domain]
      secret_name = local.cert_secret_name
    }

    rule {
      host = var.keycloak_domain

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = local.app_name

              port {
                number = local.app_port
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_deployment.keycloak
  ]
}
