locals {
  kubeconfig_path = var.kubeconfig_path
}

provider "kubernetes" {
  config_path = local.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = local.kubeconfig_path
  }
}

provider "kubectl" {
  config_path = local.kubeconfig_path
}

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = var.keycloak_namespace
  }
}

locals {
  keycloak_namespace = kubernetes_namespace.keycloak.metadata[0].name
}
