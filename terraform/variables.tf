variable "proxmox_endpoint" {
  type    = string
  default = "https://192.168.0.122:8006/"
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_node" {
  type    = string
  default = "grid"
}

variable "template_vm_id" {
  type    = number
  default = 9000
}

variable "vm_id" {
  type    = number
  default = 249
}

variable "vm_ip" {
  type    = string
  default = "192.168.0.249"
}

variable "vm_gateway" {
  type    = string
  default = "192.168.0.1"
}

variable "vm_cores" {
  type    = number
  default = 2
}

# Omada Controller bundles MongoDB; 4GB is a comfortable floor.
variable "vm_memory" {
  type    = number
  default = 4096
}

variable "vm_disk_size" {
  type    = number
  default = 40
}

variable "datastore_id" {
  type    = string
  default = "local-lvm"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}
