# terraform-openstack-deployer

The repository contains Terraform configurations for deploying a virtual machine on openstack used for deploying other Terraform code.
This deployer Terraform configuration will:

- upload a ssh key
- create an internal network that will be used by 
- install Ansible
- install the python Openstack client
- download a git repository for deploying a HA Kubernetes cluster on openstack (this is an example of how this deployer can be used)

I find if useful to have a deployer virtual machine for each openstack project I have created. 
This allows me to run deployments from a single location containing the proper Terraform state.
Using this method also allows me to run deployments from a screen session, so I can disconnect without affecting the deployment.
