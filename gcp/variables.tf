variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "project_id" {
  type = string
}

variable "clusters" {
  type = list
  default = ["cluster"]
}


variable "jumphost_zone" {
  type = string
}

variable "jumphost_user" {
  type = string
}

variable "jumphost_sshkey" {
  type = string
}

