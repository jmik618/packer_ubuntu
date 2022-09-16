source "qemu" "ubuntu-2004-amd64-qemu" {
  headless          = "true"
  vm_name           = "ubuntu-2004-amd64-qemu"
  iso_url           = "https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso"
  iso_checksum      = "f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  memory            = 1024
  disk_image        = false
  output_directory  = "output-ubuntu-2004-amd64-qemu"
  accelerator       = "hvf"
  disk_size         = "69632M"
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
    "ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ubuntu-2004-amd64-qemu/ ",
    "<enter>"
  ]
  http_directory    = "http-server"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username      = "ubuntu"
  ssh_password      = "ubuntu"
  ssh_timeout       = "600m"
}

build {
  sources = ["source.qemu.ubuntu-2004-amd64-qemu"]

}
