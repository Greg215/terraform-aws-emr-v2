#------root variable----

variable "aws_region" {}

variable "aws_availability_zone" {
  type = "list"
}

variable "vpc_cidr_block" {}

variable "public_cidrs" {
  type = "list"
}

variable "private_cidrs_instance" {
  type = "list"
}

variable "private_cidrs_storage" {
  type = "list"
}

variable "public_accessip" {}
variable "key_name" {}
variable "pub_key" {}
variable "key_path" {}

variable "names" {
  type = "list"
}

variable "master_instance" {}
variable "worker_instance" {}
variable "instance_number" {}

variable "eco-system" {
     type = "list"
}
variable "emr_version" {}

