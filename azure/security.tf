# Network Security Group/Rules
resource "azurerm_network_security_group" "internal" {
  name                = "internal"
  location            = azurerm_resource_group.crowsnet.location
  resource_group_name = azurerm_resource_group.crowsnet.name

  # TODO: Add internal network security rules
  security_rule {
    name                       = "SSH-Builder"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.builder_public_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH-Internal"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "192.168.4.0/24"
    destination_address_prefix = "192.168.4.0/24"
  }

  # Allow proxy to connect to jellyfin app on bailey
  security_rule {
    name                       = "Jellyfin"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8096"
    source_address_prefix      = "192.168.4.101"
    destination_address_prefix = "192.168.4.125"
  }

  # Allow proxy to connect to foundry app on bailey
  security_rule {
    name                       = "Foundry"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "30000"
    source_address_prefix      = "192.168.4.101"
    destination_address_prefix = "192.168.4.125"
  }
}

# TODO: Create 'public' network security group
