locals {
  issuer      = var.cert_issuer
  cert_secret_name = "keycloak-cert"
}

resource "kubectl_manifest" "keycloak_certificate" {
  yaml_body = <<-EOF
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: keycloak
      namespace: ${local.keycloak_namespace}
    spec:
      dnsNames:
        - ${var.keycloak_domain}
      issuerRef:
        kind: ClusterIssuer
        name: ${local.issuer}
      secretName: ${local.cert_secret_name}
    EOF
}
