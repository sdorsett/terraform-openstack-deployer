variable "private_key" {
  default = "~/.ssh/id_rsa-project-kubernetes"
}

variable "public_key" {
  default = "~/.ssh/id_rsa-project-kubernetes.pub"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "network-identifier" {
  default = "default-internal"
}

variable "internal-ip-address" {
  default = "10.240.0.1"
}
