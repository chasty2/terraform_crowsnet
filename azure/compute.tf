module "internal" {
  vm_count                  = 3
  source                    = "./modules/linux_virtual_machines"
  hostname_list             = var.internal_vm_names
  location                  = azurerm_resource_group.crowsnet.location
  resource_group_name       = azurerm_resource_group.crowsnet.name
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.internal.id
  public_ssh_key            = var.public_ssh_key
  storage_account           = azurerm_storage_account.diagnostics_storage.primary_blob_endpoint
}
