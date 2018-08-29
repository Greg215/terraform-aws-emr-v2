#---------network main file---------

data "aws_availability_zones" "available" {}

#-----create vpc--------------------
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = "${merge(var.tags, map("name", format("%s", var.name)))}"
}

#-----create internet gateway for public route table-------
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = "${aws_vpc.tf_vpc.id}"
  tags   = "${merge(var.tags, map("name", format("%s", var.name)))}"
}

#------create elastic IP for natgate way-----------
resource "aws_eip" "tf_nateip" {
  vpc   = true
  tags {
     Name = "eip-emr-nat"
  }
#  count = "${length(var.private_cidrs_instance) * lookup(map(var.enable_nat_gateway, 1), "true", 0)}"
}

#-----create natgate way for private route table-----------
resource "aws_nat_gateway" "tf_natgw" {
  allocation_id = "${aws_eip.tf_nateip.id}"
  subnet_id     = "${aws_subnet.tf_private_subnet_instance.id}"
#  count         = "${length(var.private_cidrs_instance) * lookup(map(var.enable_nat_gateway, 1), "true", 0)}"

  tags {
     Name = "nat-emr-private"
  }
  depends_on = ["aws_internet_gateway.tf_igw"]
}

#-----create public route table------------
resource "aws_route_table" "tf_public_rt" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf_igw.id}"
  }

  tags = "${merge(var.tags, map("name", format("%s", var.name)))}"
}

#------create private route table-----------
resource "aws_route_table" "tf_private_rt" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf_igw.id}"
  }
  
  tags                   = "${merge(var.tags, map("name", format("%s", var.name)))}"
}

#-----create subnet -----------------
resource "aws_subnet" "tf_public_subnet" {
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "${var.public_cidrs.[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  tags                    = "${merge(var.tags, map("name", format("%s", var.name)))}"
}

resource "aws_subnet" "tf_private_subnet_instance" {
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "${var.private_cidrs_instance.[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index + 1]}"
  tags                    = "${merge(var.tags, map("name", format("%s", var.name)))}"
}

resource "aws_subnet" "tf_private_subnet_storage" {
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "${var.private_cidrs_storage.[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index + 2]}"
  tags                    = "${merge(var.tags, map("name", format("%s", var.name)))}"
}

#-----create route table association---
resource "aws_route_table_association" "tf_public_accoc" {
  count          = "${aws_subnet.tf_public_subnet.count}"
  subnet_id      = "${aws_subnet.tf_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf_public_rt.id}"
}

resource "aws_route_table_association" "tf_private_accoc" {
  count          = "${aws_subnet.tf_private_subnet_instance.count}"
  subnet_id      = "${aws_subnet.tf_private_subnet_instance.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf_private_rt.id}"
}

#-----create security groups------------
resource "aws_security_group" "tf_master_sg" {
  name        = "tf_master_sg"
  description = "use for access to internet"
  vpc_id      = "${aws_vpc.tf_vpc.id}"
  revoke_rules_on_delete = true

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self = false
    cidr_blocks = ["${var.accessip}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self = false
    cidr_blocks = ["${var.accessip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = false
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
     Name = "emr-sg-master"
  }

}

resource "aws_security_group" "tf_slave_sg" {
  name        = "tf_slave_sg"
  description = "use for internal access"
  vpc_id      = "${aws_vpc.tf_vpc.id}"
  revoke_rules_on_delete = true 
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self = false
    cidr_blocks = ["${var.accessip}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self = false
    cidr_blocks = ["${var.accessip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = false
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
     Name = "emr-sg-slave"
  }

}
