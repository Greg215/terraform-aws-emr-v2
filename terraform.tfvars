names = [
   "emr-cluser",
]
aws_region = "eu-west-1"
aws_availability_zone = [
    "eu-west-1a", 
    "eu-west-1b",
    "eu-west-1c",
    ]

public_accessip = "0.0.0.0/0"
vpc_cidr_block = "10.123.0.0/16"
public_cidrs = [
    "10.123.3.0/24",
]
private_cidrs_instance = [
    "10.123.1.0/24",
]

private_cidrs_storage = [
    "10.123.2.0/24",
]

master_instance = "m4.xlarge"
worker_instance = "m4.xlarge"
instance_number = 4

emr_version = "emr-5.16.0"
eco-system = ["Spark", "Hadoop", "Hue", "Hive", "HCatalog", "Presto", "Tez", "ZooKeeper"]

key_path = "/home/ec2-user/.ssh/id_rsa.pub"
key_name = "tf_key"

pub_key = ""
