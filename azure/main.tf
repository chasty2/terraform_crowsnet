# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "crowsnet" {
  name     = "CrowsNet"
  location = "eastus"

  tags = {
    Environment = "HomeLab"
  }
}

resource "azurerm_virtual_network" "vnet" {
    name                = "crowsnet_virtual_network"
    address_space       = ["192.168.4.0/22"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.crowsnet.name
}
