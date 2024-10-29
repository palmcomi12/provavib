resource "harvester_clusternetwork" "cluster-vlan" {
  name = "cluster-vlan"
}

resource "harvester_network" "vm_network" {
    name = var.vm_network.vlanid
    namespace = var.vm_network.namespace

    vlan_id = 1

    route_mode = "auto"
    route_dhcp_server_ip = ""

    cluster_network_name = "mgmt"
}
