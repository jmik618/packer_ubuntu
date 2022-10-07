variable "vm_name" {
  type        = string
  description = "Name of the VM Instance being built"
}

variable "iso_image_url" {
  type        = string
  description = "URL to be used to pull down the ISO for new image"
}

variable "iso_image_checksum" {
  type        = string
  description = "SHA256 hash for the 'iso_image_url' being used"
}

variable "output_directory" {
  type        = string
  description = "Directory where the image will be placed once 'packer build' command completes"
}

variable "user_data_dir" {
  type        = string
  description = "Directory NAME where the Ubuntu subiquity 'user-data' file exists with unattended installtion values\n This directory must already exist"
}

variable "build_password" {
  type        = string
  description = "The password to login to the guest operating system."
  sensitive   = true
}

source "qemu" "ubuntu-amd64-qemu" {
  headless             = "true"
  vm_name              = "${var.vm_name}"
  iso_url              = "${var.iso_image_url}"
  iso_checksum         = "${var.iso_image_checksum}"
  memory               = 1024
  disk_image           = false
  output_directory     = "${var.output_directory}"
  accelerator          = "kvm"
  disk_size            = "78G"
  disk_interface       = "virtio"
  format               = "qcow2"
  net_device           = "virtio-net"
  boot_wait            = "3s"
  boot_command         = [
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
    "ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/${var.user_data_dir}/ ",
    "<enter>"
  ]
  http_directory    = "http-server"
  shutdown_command  = "echo '' | sudo -S shutdown -P now"
  ssh_username      = "ondemand"
  ssh_password      = "${var.build_password}"
  ssh_timeout       = "600m"
}

build {
  sources = ["source.qemu.ubuntu-amd64-qemu"]
}
