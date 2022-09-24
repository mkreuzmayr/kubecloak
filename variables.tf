variable "keycloak_domain" {
  type = string
}

variable "keycloak_admin_username" {
  type = string
}

variable "keycloak_admin_password" {
  type      = string
  sensitive = true
}

variable "keycloak_log_level" {
  type    = string
  default = "info"
}

variable "keycloak_namespace" {
  type    = string
  default = "keycloak"
}

variable "keycloak_replicas" {
  type    = number
  default = 3
}

variable "cert_issuer" {
  type    = string
  default = "letsencrypt-prod"
}

variable "ingress_class" {
  type    = string
  default = "nginx"
}

variable "kubeconfig_path" {
  type = string
}

