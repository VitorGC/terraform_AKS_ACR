terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.14.0"
    }
  }
}


provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "rg-terraform" {
  name     = "rg-terraform-aks"
  location = "East US"
}


resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "aks-vgc-01"
  location            = azurerm_resource_group.rg-terraform.location
  resource_group_name = azurerm_resource_group.rg-terraform.name
  dns_prefix          = "terraform"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_a2_v2"
    zones = [1,2,3]
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "acrvgc01"
  resource_group_name = azurerm_resource_group.rg-terraform.name
  location            = azurerm_resource_group.rg-terraform.location
  sku                 = "Premium"
  admin_enabled       = false
}
