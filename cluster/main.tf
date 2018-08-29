#---------emr cluster main file----------

#------key pair for ec2 instance--------
resource "aws_key_pair" "tf_auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

#-------emr cluster area-----------------
resource "aws_emr_cluster" "emr-cluster" {
  count         = "${length(var.names)}"
  name          = "${element(var.names, count.index)}"
  release_label = "${var.emr_release_version}"
  applications  = ["${var.applications}"]

  ec2_attributes {
    subnet_id                         = "${element(var.subnet_ids, count.index)}"
    key_name                          = "${aws_key_pair.tf_auth.id}"

    emr_managed_master_security_group = "${var.tf_master_sg}"
    emr_managed_slave_security_group  = "${var.tf_slave_sg}"

    instance_profile = "${aws_iam_instance_profile.ec2_profile.arn}"
  }

  master_instance_type = "${var.master_type}"
  core_instance_type   = "${var.worker_type}"
  core_instance_count  = "${var.instance_number}"

  tags = "${merge(var.tags, map("name", element(var.names, count.index)))}"

  service_role = "${aws_iam_role.emr_role.arn}"

  #  depends_on = ["aws_security_group.master", "aws_security_group.slave"]
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key ~/.ssh/id_rsa -i ${self.master_public_dns}, -u ec2-user ansible.yml"
  }
}
