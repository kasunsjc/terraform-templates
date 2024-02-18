# Azure Provider for AKS Deployment
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.22.0"
    }
  }
}

provider "azurerm" {
   features {}
}

# Kubernetes Provider for Manifests
provider "kubernetes" {
  host = azurerm_kubernetes_cluster.cluster.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

resource "azurerm_resource_group" "rg" {
  location = "southeast asia"
  name     = "aks-demo-cluster-rg"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "example-aks3"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aksdemo3242"
  azure_policy_enabled = false


  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Test"
  }
}

# Deploy Nginx Deployment
resource "kubernetes_manifest" "deployment" {
  manifest = yamldecode(file("./manifests/deployment.yaml"))
  depends_on = [
    azurerm_kubernetes_cluster.cluster
  ]
}

# Deploy Nginx Service
resource "kubernetes_manifest" "service" {
  manifest = yamldecode(file("./manifests/service.yaml"))
  depends_on = [
    azurerm_kubernetes_cluster.cluster
  ]
}