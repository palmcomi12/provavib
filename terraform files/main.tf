terraform {
  required_version = ">= 0.13"
  required_providers {
    harvester = {
      source = "harvester/harvester"
      version = "0.6.5"
    }
  }
}

provider "harvester" {
  kubeconfig = var.harvester_kubeconfig_path
}

resource "harvester_ssh_key" "mysshkey" {
  name      = "laputallave"
  namespace = "default"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP13XVjdWjrobx0Fi6mUEVdC+X2zcmBWPLEiiLToFcdI root@fernando-virtualbox"
}

resource "harvester_clusternetwork" "VMs" {
  name = var.harvester_clusternetwork_name
  description = "Cluster network used for VMs"
}

resource "harvester_cloudinit_secret" "config_vm_fedora" {
  name = "redditordistro"
  namespace = "default"

  depends_on = [ harvester_ssh_key.mysshkey ]

    user_data    = <<-EOF
    #cloud-config
    password: 123456
    chpasswd:
      expire: false
    ssh_pwauth: true
    package_update: true
    packages:
      - qemu-guest-agent
    runcmd:
      - - systemctl
        - enable
        - '--now'
        - qemu-guest-agent
    ssh_authorized_keys:
      - >-
        public_key content of harvester_ssh_key.mysshkey
    EOF
  network_data = ""
}

resource "harvester_image" "wireguard" {
  name      = "wireguard"
  namespace = "default"

  display_name = "wireguard"
  source_type  = "download"
  url          = "http://mirror.turnkeylinux.org/turnkeylinux/images/iso/turnkey-wireguard-18.0-bookworm-amd64.iso"
}

resource "harvester_image" "fedora-server" {
    name = "fedora-server"
    namespace = "default"

    display_name = "fedora-server"
    source_type = "download"
    url = "https://download.fedoraproject.org/pub/fedora/linux/releases/40/Server/x86_64/iso/Fedora-Server-netinst-x86_64-40-1.14.iso"
}

resource "harvester_network" "networkmaquinas" {
  name      = "networkmaquinas"
  namespace = "default"

  vlan_id = 0

  route_mode           = "auto"
  route_dhcp_server_ip = ""

  cluster_network_name = data.harvester_clusternetwork.mgmt.name
}

resource "harvester_virtualmachine" "wireguard" {
    count = 1
    name = wireguard
    namespace = default

    description = "wireguard vpn koumi"
    tags = {
        ssh-user = "koumi"
    }

    cpu = 1
    memory = "512Mi"

    efi = true
    secure_boot = false

    network_name = harvester_clusternetwork.mgmt-vlan1.id

}