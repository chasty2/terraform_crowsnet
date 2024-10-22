# Creates a proxmox_vm_qemu entity
resource "proxmox_vm_qemu" "proxy" {
  name = "proxy"
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
  cores = 2
  sockets = 1
  memory = 8192
  vmid = 101
  bootdisk = "scsi0"
  scsihw = "virtio-scsi-single"
  ipconfig0 = "ip=192.168.4.101/22,gw=192.168.4.1"

  disk {
    slot = "scsi0"
    type = "disk"
    storage = "ssd_mirror" # Name of storage local to the host you are spinning the VM up on
    size = "32G"
  }

  network {
    model = "virtio"
    bridge = var.nic_name
    macaddr = "BC:24:11:88:D8:67" # MAC-associated IP address
    # tag = var.vlan_num # This tag can be left off if you are not taking advantage of VLANs
  }
}