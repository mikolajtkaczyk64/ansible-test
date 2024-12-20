resource "proxmox_virtual_environment_download_file" "ubuntu_22_04_server_cloudimg_amd64_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "orange"
  file_name    = "ubuntu-22.04-server-cloudimg-amd64.img"
  url          = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name        = "terraform-provider-proxmox-ubuntu-vm"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu"]

  node_name = "orange"
  vm_id     = 4321

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores        = 2
    type         = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = 2048
    floating  = 2048 # set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_22_04_server_cloudimg_amd64_img.id
    interface    = "scsi0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "10.10.198.105/24"
        gateway = "10.10.198.1"
      }
    }

    user_account {
      keys     = [file("/home/semaphore/files/zotac.pub")]
      password = random_password.ubuntu_vm_password.result
      username = "ubuntu"
    }

  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version = "v2.0"
  }

  serial_device {}
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

output "ubuntu_vm_password" {
  value     = nonsensitive(random_password.ubuntu_vm_password.result)
  sensitive = true
}

output "ubuntu_vm_private_key" {
  value     = tls_private_key.ubuntu_vm_key.private_key_pem
  sensitive = true
}

output "ubuntu_vm_public_key" {
  value = tls_private_key.ubuntu_vm_key.public_key_openssh
}
