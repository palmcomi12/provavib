resource "harvester_ssh_key" "mysshkey" {
  name      = "mysshkey"
  namespace = "default"

  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQc/VS2iSUwJ7Lzl6f9Nw3O8mguzdq3WcEOwISLcdqJ koumi@KOUMIKOMPUTER"
}

variable "vm_network" {
  description = "VLAN per a maquines virtuals"
  type = object({
    vlanid = string
    namespace = string
  })
  default = {
    vlanid = "vlan-1"
    namespace = "default"
  }
}