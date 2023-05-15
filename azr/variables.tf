variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "clusters" {
  type = list
  default = ["cluster"]
}

variable "jumphost_sshkey" {
  type = string
}
