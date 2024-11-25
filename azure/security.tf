# Network Security Group/Rules
resource "azurerm_network_security_group" "internal" {
  name                = "internal"
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
