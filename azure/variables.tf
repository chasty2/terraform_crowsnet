variable "username" {
  type        = string
  description = "local user that will be created on each VM"
  default     = "ansible"
}

variable "public_ssh_key" {
}