source "qemu" "ubuntu-2004-amd64-qemu" {
  headless          = "true"
  vm_name           = "ubuntu-2004-amd64-qemu"
  iso_url           = "https://releases.ubuntu.com/focal/ubuntu-20.04.5-live-server-amd64.iso"
  iso_checksum      = "5035be37a7e9abbdc09f0d257f3e33416c1a0fb322ba860d42d74aa75c3468d4"
  memory            = 1024
  disk_image        = false
  output_directory  = "output-ubuntu-2004-amd64-qemu"
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
    "ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ubuntu-2004-amd64-qemu/ ",
    "<enter>"
  ]
  http_directory    = "http-server"
  shutdown_command  = "echo '' | sudo -S shutdown -P now"
  ssh_username      = "ondemand"
  ssh_password      = ""
  ssh_timeout       = "600m"
}

build {
  sources = ["source.qemu.ubuntu-2004-amd64-qemu"]
}
