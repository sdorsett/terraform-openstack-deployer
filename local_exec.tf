resource "null_resource" "run-ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i openstack_inventory.py site.yml",
  }
  depends_on = ["openstack_compute_instance_v2.deployer"]
}
