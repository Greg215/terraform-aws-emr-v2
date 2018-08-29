#--------root main for emr-------

provider "aws" {
  region = "${var.aws_region}"
}

variable "common_tags" {
  type = "map"

  default = {
    Name = "tf-emr-cluster"
    builtWith      = "terraform"
    terraformGroup = "tf-emr-module"
  }
}

#resource "aws_key_pair" "deployer" {
#  key_name   = "${var.key_name}"
#  public_key = "${var.pub_key}"
#}

module "network" {
  source = "./network"
  name   = "emr-network"

  vpc_cidr      = "${var.vpc_cidr_block}"
  private_cidrs_storage = ["${var.private_cidrs_storage}"]
  private_cidrs_instance = ["${var.private_cidrs_instance}"]
  public_cidrs  = ["${var.public_cidrs}"]
  accessip      = "${var.public_accessip}"

  tags = "${var.common_tags}"
}

module "cluster" {
  source              = "./cluster"
  names               = ["${var.names}"]
  master_type         = "${var.master_instance}"
  worker_type         = "${var.worker_instance}"
  instance_number     = "${var.instance_number}"
  tf_master_sg        = "${module.network.tf_master_sg}"
  tf_slave_sg         = "${module.network.tf_slave_sg}"
  subnet_ids          = ["${module.network.private_subnets_instance}"]
  key_name            = "${var.key_name}"
  applications        = ["${var.eco-system}"]
  emr_release_version = "${var.emr_version}"
  public_key_path     = "${var.key_path}"
  tags                = "${var.common_tags}"
}
