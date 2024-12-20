terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.69.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = var.pve_api_token
  insecure  = true
  tmp_dir  = "/var/tmp"
  ssh {
    agent    = true
    username = "terraform"
  }
}
