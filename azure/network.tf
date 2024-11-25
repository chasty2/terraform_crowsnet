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