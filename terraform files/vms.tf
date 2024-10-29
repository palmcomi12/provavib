resource "harvester_virtualmachine" "ubuntu20" {
  name                 = "ubuntu24"
  namespace            = "default"
  restart_after_update = true

  description = "test ubuntu24 iso"
  tags = {
    ssh-user = "ubuntu"
  }

  cpu    = 2
  memory = "2Gi"

  efi         = true
  secure_boot = false

  run_strategy    = "RerunOnFailure"
  hostname        = "ubuntu24"
  reserved_memory = "100Mi"
  machine_type    = "q35"

  network_interface {
    name           = "nic-1"
    wait_for_lease = true
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = "10Gi"
    bus        = "virtio"
    boot_order = 1

    image       = harvester_image.ubuntu-24.id
    auto_delete = true
  }

  disk {
    name        = "emptydisk"
    type        = "disk"
    size        = "20Gi"
    bus         = "virtio"
    auto_delete = true
  }

  cloudinit {
    user_data_secret_name    = harvester_cloudinit_secret.cloud-config-ubuntu24.name
    network_data_secret_name = harvester_cloudinit_secret.cloud-config-ubuntu24.name
  }
}