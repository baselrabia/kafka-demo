terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.17.0"
    }
  }
}

provider "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "minikube"
}

# Create a new namespace
resource "kubernetes_namespace" "go-app-namespace" {
  metadata {
    name = "go-app-namespace"
  }
}
