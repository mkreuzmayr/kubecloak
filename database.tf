locals {
  db_name = "keycloak-db"
}

resource "helm_release" "keycloak_database" {
  name      = local.db_name
  namespace = local.keycloak_namespace

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql-ha"
}
