resource "proxmox_virtual_environment_download_file" "ubuntu_22_04_server_cloudimg_amd64_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "orange"
  file_name    = "ubuntu-22.04-server-cloudimg-amd64.img"
  url          = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
}
