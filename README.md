<p align="center">
  <h1 align="center">Kubecloak 🕸️🔑</h1>
  <p align="center">
    A easy-to-use starting point to deploy a <a href="https://keycloak.com" target="_blank">Keycloak</a> Cluster in a <a href="https://kubernetes.io" target="_blank">Kubernetes</a> environment.
  </p>
  <hr />
</p>

## About The Project

Setting up a single Keycloak node is easy, but setting it up in a Kubernetes Cluster for the first time is a complex process. This project aims to create a starting point for your Keycloak Cluster deployment in Kubernetes.

This deployment is fully written in [Terraform](https://www.terraform.io).

## Getting Started

### 📦 Prerequisites

You'll need to have [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and [kubectl](https://kubernetes.io/docs/tasks/tools) installed on your machine, follow the links to see the recommended installation steps for your OS.

### ✈️ Setup & Deploy

1. Clone the repository to your local system.
1. Rename `.env.auto.tfvars.example` to `.env.auto.tfvars` and adjust the variables.
1. If you want to change more granular settings you can do this in the terraform files directly.
1. Run `terraform apply --auto-approve` to deploy it to your cluster.
