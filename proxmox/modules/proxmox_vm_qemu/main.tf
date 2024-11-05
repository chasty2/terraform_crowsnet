terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

resource "proxmox_vm_qemu" "virtual_machine" {
  name = var.name
  count = 1 # Establishes how many instances will be created 
  target_node = var.proxmox_host

  # References our vars.tf file to plug in our template name
  clone = var.template_name
  # Creates a full clone, rather than linked clone 
  # https://pve.proxmox.com/wiki/VM_Templates_and_Clones
  full_clone  = "true"

  # VM Settings. `agent = 1` enables qemu-guest-agent
  os_type = "cloud_init"
  agent = 1
  cores = var.cores
  sockets = 1
  memory = var.memory
  vmid = var.vmid
  bootdisk = "scsi0"
  scsihw = "virtio-scsi-single"
  ipconfig0 = var.ip_config

  disk {
    slot = "scsi0"
    type = "disk"
    storage = var.storage_pool # Name of storage local to the host you are spinning the VM up on
    size = var.template_disk_size
  }

  network {
    model = "virtio"
    bridge = var.nic_name
    macaddr = var.macaddr # MAC-associated IP address
    # tag = var.vlan_num # This tag can be left off if you are not taking advantage of VLANs
  }
}