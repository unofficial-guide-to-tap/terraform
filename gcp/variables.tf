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


variable "use_existing_zone" {
  type = bool
  default = false
}

variable "zone_dns_name" {
  type = string
}

variable "tap_address" {
  type = string
  default = "1.2.3.4"
}

variable "cnrs_address" {
  type = string
  default = "1.2.3.4"
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

