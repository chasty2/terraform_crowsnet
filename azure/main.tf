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

# Resource Group
resource "azurerm_resource_group" "crowsnet" {
  name     = "CrowsNet"
  location = "eastus"

  tags = {
    Environment = "HomeLab"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "crowsnet_virtual_network"
  address_space       = ["192.168.4.0/22"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.crowsnet.name
}

# Subnet
resource "azurerm_subnet" "subnet_1" {
  name                 = "subnet_1"
  resource_group_name  = azurerm_resource_group.crowsnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.4.0/24"]
}

# Public IPs
resource "azurerm_public_ip" "public_ip" {
  name                = "crowsnet_public_ip"
  location            = azurerm_resource_group.crowsnet.location
  resource_group_name = azurerm_resource_group.crowsnet.name
  allocation_method   = "Dynamic"
}

# Network Security Group/Rules
resource "azurerm_network_security_group" "default_nsg" {
  name                = "crowsnet_default_security_group"
  location            = azurerm_resource_group.crowsnet.location
  resource_group_name = azurerm_resource_group.crowsnet.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Interface
resource "azurerm_network_interface" "default_nic" {
  name                = "crowsnet_default_nic"
  location            = azurerm_resource_group.crowsnet.location
  resource_group_name = azurerm_resource_group.crowsnet.name

  ip_configuration {
    name                          = "default_nic_config"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Connect default network interface with default security group
resource "azurerm_network_interface_security_group_association" "default_nic_nsg" {
  network_interface_id      = azurerm_network_interface.default_nic.id
  network_security_group_id = azurerm_network_security_group.default_nsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "diagnostics_storage" {
  name                     = "crowsnetdiagz"
  location                 = azurerm_resource_group.crowsnet.location
  resource_group_name      = azurerm_resource_group.crowsnet.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "crowsnet_vm" {
  name                  = "template"
  location              = azurerm_resource_group.crowsnet.location
  resource_group_name   = azurerm_resource_group.crowsnet.name
  network_interface_ids = [azurerm_network_interface.default_nic.id]
  size                  = "Standard_DC1ds_v3"

  os_disk {
    name                 = "osDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "template"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = var.public_ssh_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diagnostics_storage.primary_blob_endpoint
  }
}