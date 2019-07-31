provider "openstack" {}

data "openstack_images_image_v2" "ubuntu_18_04" {
  name = "Ubuntu 18.04"
  most_recent = true
}

data "openstack_compute_flavor_v2" "s1-2" {
  name = "s1-2"
}

resource "openstack_compute_instance_v2" "deployer" {
  name            = "kubernetes-deployer"
  image_id        = "${data.openstack_images_image_v2.ubuntu_18_04.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.s1-2.id}"
  key_pair        = "${openstack_compute_keypair_v2.deploy-keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.deploy-deployer-allow-external-8443.name}"]
  user_data       = "${data.template_file.ens4_netcfg.rendered}"

  network {
    name = "Ext-Net",
  }

  network {
    name = "${openstack_networking_network_v2.default-internal.name}"
    fixed_ip_v4 = "${var.internal-ip-address}"
  }

  metadata {
    deploy-k8s = "deployer"
  }

  provisioner "file" {
    source      = "${var.private_key}"
    destination = "~/.ssh/id_rsa"
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key)}"
    }
  }

  provisioner "file" {
    source      = "${var.public_key}"
    destination = "~/.ssh/id_rsa.pub"
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key)}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/.ssh/*",
    ]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key)}"
    }
  }

}

data "template_file" "ens4_netcfg" {
    template = "${file("01-ens4.yaml.tpl")}"
    vars {
        private_ip = "${var.internal-ip-address}" 
    }
}
