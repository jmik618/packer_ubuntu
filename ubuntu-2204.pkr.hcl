variable "build_password" {
  type        = string
  description = "The password to login to the guest operating system."
  sensitive   = true
}

source "qemu" "ubuntu-2204-amd64-qemu" {
  headless          = "true"
  vm_name           = "ubuntu-2204-amd64-qemu"
  iso_url           = "https://releases.ubuntu.com/jammy/ubuntu-22.04.1-live-server-amd64.iso"
  iso_checksum      = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
  memory            = 1024
  disk_image        = false
  output_directory  = "output-ubuntu-2204-amd64-qemu"
  accelerator       = "kvm"
  disk_size         = "77824M"
  disk_interface    = "virtio"
  format            = "qcow2"
  net_device        = "virtio-net"
  boot_wait         = "3s"
  boot_command      = [
    # Make the language selector appear...
    " <up><wait>",
    # ...then get rid of it
    " <up><wait><esc><wait>",

    # Go to the other installation options menu and leave it
    "<f6><wait><esc><wait>",

    # Remove the kernel command-line that already exists
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",

    # Add kernel command-line and start install
    "/casper/vmlinuz ",
    "initrd=/casper/initrd ",
    "autoinstall ",
    "ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ubuntu-2204-amd64-qemu/ ",
    "<enter>"
  ]
  http_directory    = "http-server"
  shutdown_command  = "echo ${var.build_password} | sudo -S shutdown -P now"
  ssh_username      = "ondemand"
  ssh_password      = "${var.build_password}"
  ssh_timeout       = "600m"
}

build {
  sources = ["source.qemu.ubuntu-2204-amd64-qemu"]
}
