terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.69.0"
    }
  }
}

variable "pve_endpoint" {
  type = string
}

variable "pve_api_token" {
  type = string
}

provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = var.pve_api_token
  insecure  = true
  tmp_dir  = "/var/tmp"
  ssh {
    agent    = false
    username = "terraform"
    private_key = file("/home/semaphore/zotac")
  }
}
