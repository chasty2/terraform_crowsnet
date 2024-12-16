variable "internal_vm_names" {
  type        = list(string)
  description = "Array of names of internal virtual machines"
  default     = ["web", "nfs"]
}

variable "public_vm_names" {
  type        = list(string)
  description = "Array of names of public virtual machines"
  default     = ["gate"]
}

variable "public_ssh_key" {
  description = "SSH key of 'ansible' user"
}

variable "builder_public_ip" {
  description = "IP address of machine running Ansible to configure VM's"
}