#-------network variable file---------

variable "name" {}

variable "vpc_cidr" {}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "public_cidrs" {
  type = "list"
}

variable "private_cidrs_instance" {
  type = "list"
}

variable "private_cidrs_storage" {
  type = "list"
}

variable "enable_nat_gateway" {
  description = "should be true if you want to provision NAT Gateways for each of your private networks"
  default     = false
}

variable "accessip" {}
