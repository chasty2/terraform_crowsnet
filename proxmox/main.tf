terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  # References our vars.tf file to plug in the api_url 
  pm_api_url = var.api_url
  # References our secrets.tfvars file to plug in our token_id
  pm_api_token_id = var.token_id
  # References our secrets.tfvars to plug in our token_secret 
  pm_api_token_secret = var.token_secret
  # Default to `true` unless you have TLS working within your pve setup 
  pm_tls_insecure = true
}

# Creates a proxmox_vm_qemu entity named test
resource "proxmox_vm_qemu" "lab" {
  name = "lab"
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
  cores = 1
  sockets = 1
  memory = 4096
  vmid = 200
  bootdisk = "scsi0"
  scsihw = "virtio-scsi-single"
  ipconfig0 = "ip=192.168.4.200/22,gw=192.168.4.1"

  disk {
    slot = "scsi0"
    type = "disk"
    storage = "ssd_mirror" # Name of storage local to the host you are spinning the VM up on
    size = "32G"
  }

  network {
    model = "virtio"
    bridge = var.nic_name
    macaddr = "CA:9B:F1:85:90:C0" # MAC-associated IP address
    # tag = var.vlan_num # This tag can be left off if you are not taking advantage of VLANs
  }

  #provisioner "local-exec" {
    # Provisioner commands can be run here.
    # We will use provisioner functionality to kick off ansible
    # playbooks in the future
    #command = "touch /home/tcude/test.txt"
  #}
}