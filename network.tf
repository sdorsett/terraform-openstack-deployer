resource "openstack_compute_keypair_v2" "deploy-keypair" {
  name       = "deploy-keypair"
  public_key = "${file(var.public_key)}"
}

resource "openstack_compute_secgroup_v2" "deploy-deployer-allow-external-8443" {
  name        = "deploy-deployer-allow-external-8443"
  description = "permitted inbound external TCP 8443 traffic"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "10.240.0.0/24"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    cidr        = "10.240.0.0/24"
  }

}

resource "openstack_networking_network_v2" "default-internal" {
  name             = "default-internal"
  admin_state_up   = "true"
}

resource "openstack_networking_subnet_v2" "default-internal" {
  name       = "default-internal"
  network_id = "${openstack_networking_network_v2.default-internal.id}"
  cidr       = "10.240.0.0/24"
  ip_version = 4
}
