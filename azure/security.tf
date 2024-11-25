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

# Connect default network interface with default security group
resource "azurerm_network_interface_security_group_association" "default_nic_nsg" {
  network_interface_id      = azurerm_network_interface.default_nic.id
  network_security_group_id = azurerm_network_security_group.default_nsg.id
}