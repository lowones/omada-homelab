terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true

  ssh {
    agent    = true
    username = "root"
  }
}

locals {
  ssh_public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "proxmox_virtual_environment_vm" "omada" {
  name      = "omada-controller"
  node_name = var.proxmox_node
  vm_id     = var.vm_id

  agent {
    enabled = true
  }

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  cpu {
    cores = var.vm_cores
    type  = "host"
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.vm_disk_size
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.vm_ip}/24"
        gateway = var.vm_gateway
      }
    }
    user_account {
      username = "ubuntu"
      keys     = [local.ssh_public_key]
    }
  }
}

output "vm_id" {
  value = var.vm_id
}

output "vm_ip" {
  value = var.vm_ip
}

output "vm_name" {
  value = "omada-controller"
}
