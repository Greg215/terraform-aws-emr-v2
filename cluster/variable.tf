#--------emr cluster variable file-----

variable "names" {
  default = []
}

variable "key_name" {}

variable "public_key_path" {}

variable "emr_release_version" {}

variable "applications" {
       type = "list"
}

variable "subnet_ids" {
  default = []
}

variable "master_type" {}

variable "worker_type" {}

variable "instance_number" {}

variable "tags" {
  type = "map"

  default = {}
}

variable "tf_master_sg" {}

variable "tf_slave_sg" {}
