output "resource_group_id" {
  value = azurerm_resource_group.crowsnet.id
}

# TODO: Collect static public IP's 
# output "public_ip_address" {
#   value = azurerm_linux_virtual_machine.crowsnet_vm.public_ip_address
# }