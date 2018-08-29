#-----network output file------

output "vpc_id" {
  value = "${aws_vpc.tf_vpc.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.tf_igw.id}"
}

output "public_route_table_ids" {
  value = ["${aws_route_table.tf_public_rt.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.tf_private_rt.*.id}"]
}

output "private_subnets_instance" {
  value = ["${aws_subnet.tf_private_subnet_instance.*.id}"]
}

output "private_subnets_storage" {
  value = ["${aws_subnet.tf_private_subnet_storage.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.tf_public_subnet.*.id}"]
}

output "tf_master_sg" {
  value = "${aws_security_group.tf_master_sg.id}"
}

output "tf_slave_sg" {
  value = "${aws_security_group.tf_slave_sg.id}"
}
